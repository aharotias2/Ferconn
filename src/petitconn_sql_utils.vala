/*
 *  Copyright 2023 Tanaka Takayuki (田中喬之)
 *
 *  This file is part of Petitconn.
 *
 *  Petitconn is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Petitconn is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Petitconn.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Tanaka Takayuki <aharotias2@gmail.com>
 */

namespace Petitconn.SqlUtils {
    private string? create_set_expression(string name, Value value, string? name_suffix = null) {
        switch (value.type()) {
          case Type.INT:
            return @"$(name) = ##$(name)$(name_suffix ?? "")::gint";
          case Type.DOUBLE:
            return @"$(name) = ##$(name)$(name_suffix ?? "")::gdouble";
          case Type.FLOAT:
            return @"$(name) = ##$(name)$(name_suffix ?? "")::gfloat";
          case Type.LONG:
            return @"$(name) = ##$(name)$(name_suffix ?? "")::glong";
          case Type.STRING:
            return @"$(name) = ##$(name)$(name_suffix ?? "")::string";
        }
        printerr("ERROR: Unsupported Type of value: %s\n", value.type().name());
        Process.exit(127);
    }

    private string create_select_sql(string table_name, string[] column_names, Gee.Map<string, Value?>? condition) {
        var sql = new StringBuilder("select ");
        sql.append(string.joinv(", ", column_names)).append(" from ").append(table_name);
        Gee.List<string> where_clause = new Gee.ArrayList<string>();
        foreach (var entry in condition.entries) {
            where_clause.add(SqlUtils.create_set_expression(entry.key, entry.value));
        }
        sql.append(" where ").append(string.joinv(" and ", where_clause.to_array()));
        debug("%s %s", sql.str, GeeUtils.map_string_value_to_string(condition));
        return sql.str;
    }

    private Gda.DataModel execute_select(Gda.Connection conn, string table_name, string[] column_names,
            Gee.Map<string, Value?>? condition) throws Error {
        var parser = conn.create_parser();
        var stmt = parser.parse_string(
                SqlUtils.create_select_sql(table_name, column_names, condition),
                null);
        Gda.Set params;
        stmt.get_parameters(out params);
        foreach (var entry in condition.entries) {
            Gda.Holder holder;
            holder = params.get_holder(entry.key);
            holder.set_value(entry.value);
        }
        return conn.statement_execute_select(stmt, params);
    }

    private bool execute_insert(Gda.Connection conn, string table_name, Gee.Map<string, Value?> values) throws Error {
        SList<string> col_names = new SList<string>();
        SList<Value?> col_values = new SList<Value?>();
        foreach (var entry in values.entries) {
            col_names.append(entry.key);
            col_values.append(entry.value);
        }
        return conn.insert_row_into_table_v(table_name, col_names, col_values);
    }
    
    private int execute_update(Gda.Connection conn, string table_name,
            Gee.Map<string, Value?> condition, Gee.Map<string, Value?> values) throws Error {
        StringBuilder sql = new StringBuilder("update ");
        sql.append(table_name);
        Gee.List<string> set_clause = new Gee.ArrayList<string>();
        foreach (var name in values.keys) {
            set_clause.add(SqlUtils.create_set_expression(name, values[name], "_to_set"));
        }
        sql.append(" set ").append(string.joinv(", ", set_clause.to_array()));
        Gee.List<string> where_clause = new Gee.ArrayList<string>();
        foreach (var name in condition.keys) {
            where_clause.add(SqlUtils.create_set_expression(name, condition[name], "_cond"));
        }
        sql.append(" where ").append(string.joinv(" and ", where_clause.to_array()));
        debug("WpTermTaxonomyDao.update: %s", sql.str);
        var parser = conn.create_parser();
        var stmt = parser.parse_string(sql.str, null);
        Gda.Set params;
        stmt.get_parameters(out params);
        foreach (var name_to_set in values.keys) {
            Gda.Holder holder = params.get_holder(name_to_set + "_to_set");
            holder.set_value(values[name_to_set]);
        }
        foreach (var name_cond in condition.keys) {
            Gda.Holder holder = params.get_holder(name_cond + "_cond");
            holder.set_value(condition[name_cond]);
        }
        Gda.Set last_insert_row;
        return conn.statement_execute_non_select(stmt, params, out last_insert_row);
    }
    
    private int execute_delete(Gda.Connection conn, string table_name, Gee.Map<string, Value?> condition) throws Error {
        StringBuilder sql = new StringBuilder("delete from ");
        sql.append(table_name);
        Gee.List<string> where_clause = new Gee.ArrayList<string>();
        foreach (var name in condition.keys) {
            where_clause.add(SqlUtils.create_set_expression(name, condition[name]));
        }
        sql.append(" where ").append(string.joinv(" and ", where_clause.to_array()));
        var parser = conn.create_parser();
        var stmt = parser.parse_string(sql.str, null);
        Gda.Set params;
        stmt.get_parameters(out params);
        foreach (var name_cond in condition.keys) {
            Gda.Holder holder = params.get_holder(name_cond);
            holder.set_value(condition[name_cond]);
        }
        Gda.Set last_insert_row;
        return conn.statement_execute_non_select(stmt, params, out last_insert_row);
    }
}
