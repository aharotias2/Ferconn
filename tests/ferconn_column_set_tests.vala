class WpTable : Ferconn.ColumnSet {
    public WpTable() {
        base("wp_test", "id", Type.LONG, "title", Type.STRING);
    }
}

int main(string[] argv) {
    var table = new WpTable();
    table["id"] = (long) 1;
    table["title"] = "hoge";
    print("%ld, %s\n", table["id"].get_long(), table["title"].get_string());
    return 0;
}
