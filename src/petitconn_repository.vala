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

namespace Petitconn {
    public class Repository : Object {
        public Gda.Connection conn { get; set; }

        public Repository(Gda.Connection conn) {
            this.conn = conn;
        }
        
        public Gee.List<Gee.Map<string, Value?>> select_as_map(ColumnSet condition) throws Error {
            string[] column_names = condition.column_types.keys.to_array();
            Gda.DataModel data = SqlUtils.execute_select(conn,
                    condition.table_name, column_names, condition.column_values);
            int num_rows = data.get_n_rows();
            int num_cols = data.get_n_columns();
            var result = new Gee.ArrayList<Gee.Map<string, Value?>>();
            for (int i = 0; i < num_rows; i++) {
                var rec = new Gee.HashMap<string, Value?>();
                for (int j = 0; j < num_cols; j++) {
                    Value val = data.get_value_at(j, i);
                    // I don't really understand the gda specs, and I don't know how to handle time-based values,
                    // so I'll convert them to strings for now. It's "TODO"
                    // I feel like it will probably be solved if the version of gda in the Ubuntu repository goes up.
                    if (val.type() == typeof(Gda.Timestamp)) {
                        var ts = val as Gda.Timestamp;
                        string tss = "%04d-%02d-%02d %02d:%02d:%02d".printf(
                                ts.year, ts.month, ts.day, ts.hour, ts.minute, ts.second);
                        rec[column_names[j]] = tss;
                    } else {
                        rec[column_names[j]] = val;
                    }
                }
                result.add(rec);
            }
            return result;
        }

        public bool insert(ColumnSet values) throws Error {
            return SqlUtils.execute_insert(conn, values.table_name, values.column_values);
        }

        public int update(ColumnSet condition, ColumnSet values) throws Error {
            return SqlUtils.execute_update(conn, condition.table_name, condition.column_values, values.column_values);
        }

        public int @delete(ColumnSet condition) throws Error {
            return SqlUtils.execute_delete(conn, condition.table_name, condition.column_values);
        }
    }
}
