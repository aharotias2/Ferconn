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

namespace Petitconn.ValueUtils {
    public Value new_int_value(int src) {
        Value val = Value(Type.INT);
        val.set_int(src);
        return val;
    }
    
    public Value new_long_value(long src) {
        debug("new_long_value: %ld", src);
        Value val = Value(Type.LONG);
        val.set_long(src);
        return val;
    }
    
    public Value new_uint64_value(uint64 src) {
        Value val = Value(Type.UINT64);
        val.set_uint64(src);
        return val;
    }
    
    public Value new_int64_value(int64 src) {
        Value val = Value(Type.INT64);
        val.set_int64(src);
        return val;
    }
    
    public Value new_double_value(double src) {
        Value val = Value(Type.DOUBLE);
        val.set_double(src);
        return val;
    }
    
    public Value new_string_value(string src) {
        Value val = Value(Type.STRING);
        val.set_string(src);
        return val;
    }
    
    public string to_string(Value? src) {
        if (src == null) {
            return "null";
        } else {
            switch (src.type()) {
              case Type.INT: return src.get_int().to_string();
              case Type.DOUBLE: return src.get_double().to_string();
              case Type.LONG: return src.get_long().to_string();
              case Type.FLOAT: return src.get_float().to_string();
              case Type.STRING: return src.get_string();
              default: return "unknown";
            }
        }
    }
}
