namespace Ferconn {
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
