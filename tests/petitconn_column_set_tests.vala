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

class WpTable : Petitconn.ColumnSet {
    public WpTable() {
        base("wp_test", "id", Type.LONG, "title", Type.STRING);
    }
}

int main(string[] argv) {
    switch (argv[1]) {
      case "1":
        test_1();
        break;
      case "2":
        test_2();
        break;
    }
    return 0;
}

void test_1() {
    var table = new WpTable();
    table["id"] = (long) 1;
    table["title"] = "hoge";
    print("%ld, %s\n", table["id"].get_long(), table["title"].get_string());
}

void test_2() {
    var table = new WpTable();
    table["id"] = (long) 1;
    print("%ld, %s\n", table["id"].get_long(), Petitconn.ValueUtils.get_string_or_null(table["title"]));
}
