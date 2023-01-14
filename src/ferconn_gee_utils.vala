/*
 *  Copyright 2023 Tanaka Takayuki (田中喬之)
 *
 *  This file is part of Ferconn.
 *
 *  Ferconn is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Ferconn is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Ferconn.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Tanaka Takayuki <aharotias2@gmail.com>
 */

namespace Ferconn.GeeUtils {
    public string map_string_value_to_string(Gee.Map<string, Value?> map) {
        var sb = new StringBuilder();
        foreach (var key in map.keys) {
            sb.append(key).append(" = ").append(ValueUtils.to_string(map[key])).append("; ");
        }
        return sb.str;
    }
}
