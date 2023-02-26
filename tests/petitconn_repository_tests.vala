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

class TestTable : Petitconn.ColumnSet {
    public int id {
        get {
            return Petitconn.ValueUtils.get_int_or_zero(this["id"]);
        }
        set {
            this["id"] = Petitconn.ValueUtils.new_int_value(value);
        }
    }

    public string name {
        owned get {
            return Petitconn.ValueUtils.get_string_or_null(this["name"]);
        }
        set {
            this["name"] = Petitconn.ValueUtils.new_string_value(value);
        }
    }
    
    public TestTable() {
        base("test_table", "id", Type.INT, "name", Type.STRING);
    }
}

int main(string[] argv) {
    try {
        Gda.init();
        Gda.Connection? conn = Gda.Connection.open_from_string("SQLite",
            "DB_DIR=../tests;DB_NAME=test.db", null, NONE);
        if (conn == null) {
            printerr("connection was not established\n");
            return 1;
        }
        Petitconn.Repository repository = new Petitconn.Repository(conn);
        
        // test insert
        TestTable dto1 = new TestTable();
        dto1.id = 0;
        dto1.name = "Tarou";
        bool is_insert_success = repository.insert(dto1);
        assert(is_insert_success);
        
        // test update
        TestTable dto2 = new TestTable();
        dto2.id = 0;
        TestTable dto3 = new TestTable();
        dto3.name = "Jirou";
        int update_count = repository.update(dto2, dto3);
        assert(update_count == 1);
        
        // test select
        var list = repository.select_as_map(dto2);
        assert(list.size == 1);
        
        // test set_values
        TestTable dto4 = new TestTable();
        dto4.set_values(list[0]);
        assert(dto4.name == "Jirou");
        
        // test delete
        int delete_count = repository.delete(dto2);
        assert(delete_count == 1);
        
        // test select again
        list = repository.select_as_map(dto2);
        assert(list.size == 0);
        
        return 0;
    } catch (Error e) {
        printerr("%s\n", e.message);
        return 127;
    }
}
