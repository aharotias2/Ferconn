class TestTable : Ferconn.ColumnSet {
    public int id {
        get {
            return this["id"].get_int();
        }
        set {
            this["id"] = Ferconn.ValueUtils.new_int_value(value);
        }
    }

    public string name {
        owned get {
            return this["name"].get_string();
        }
        set {
            this["name"] = Ferconn.ValueUtils.new_string_value(value);
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
        Ferconn.AbstractDao dao = new Ferconn.AbstractDao(conn);
        
        // test insert
        TestTable dto1 = new TestTable();
        dto1.id = 0;
        dto1.name = "Tarou";
        bool is_insert_success = dao.insert(dto1);
        assert(is_insert_success);
        
        // test update
        TestTable dto2 = new TestTable();
        dto2.id = 0;
        TestTable dto3 = new TestTable();
        dto3.name = "Jirou";
        int update_count = dao.update(dto2, dto3);
        assert(update_count == 1);
        
        // test select
        var list = dao.select_as_map(dto2);
        assert(list.size == 1);
        
        // test set_values
        TestTable dto4 = new TestTable();
        dto4.set_values(list[0]);
        assert(dto4.name == "Jirou");
        
        // test delete
        int delete_count = dao.delete(dto2);
        assert(delete_count == 1);
        
        // test select again
        list = dao.select_as_map(dto2);
        assert(list.size == 0);
        
        return 0;
    } catch (Error e) {
        printerr("%s\n", e.message);
        return 127;
    }
}
