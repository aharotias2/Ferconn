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
    public class SealedMap<T, S> : Gee.HashMap<T, S> {
        public bool is_sealed {
            get {
                return _is_sealed;
            }
            set {
                if (!_is_sealed && value) {
                    _is_sealed = true;
                }
            }
        }
        private bool _is_sealed;

        public new void @set(T key, S val) {
            if (!is_sealed) {
                base.set(key, val);
            }
        }
    }
}
