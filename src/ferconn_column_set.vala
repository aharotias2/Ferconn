namespace Ferconn {
    public class ColumnSet : Object {
        public string table_name { get; set; }
        public SealedMap<string, Type> column_types;
        public Gee.Map<string, Value?> column_values;

        public ColumnSet(string table_name, ...) {
            var l = va_list();
            this.table_name = table_name;
            this.column_types = new SealedMap<string, Type>();
            this.column_values = new Gee.HashMap<string, Value?>();
            while (true) {
                string? key = l.arg<string?>();
                if (key == null) {
                    break;
                }
                if (column_types.has_key(key)) {
                    printerr(@"It already have a column named $(key). exit");
                    Process.exit(144);
                }
                Type? type = (Type?) l.arg<ulong>();
                column_types[key] = type;
            }
            this.column_types.is_sealed = true;
        }

        public Type get_column_type(string name) {
            return column_types[name];
        }

        public void set_column_type(string name, Type type) {
            column_types[name] = type;
        }

        public new void @set(string name, Value? val) {
            if (column_types[name] == val.type()) {
                column_values[name] = val;
            } else {
                printerr(@"type of $(table_name).$(name) is $(val.type().name())");
            }
        }

        public new Value? @get(string name) {
            if (column_types.has_key(name)) {
                return column_values[name];
            } else {
                printerr(@"Key $(table_name).$(name) does not exist!");
                return null;
            }
        }

        public void set_values(Gee.Map<string, Value?> values) {
            foreach (var key in values.keys) {
                column_values[key] = values[key];
            }
        }

        public Gee.Map<string, Value?> get_values_as_map() {
            return column_values;
        }

        public Gee.Set<string> get_column_names() {
            return column_types.keys;
        }
    }
}
