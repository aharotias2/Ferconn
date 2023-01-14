namespace Ferconn.GeeUtils {
    public string map_string_value_to_string(Gee.Map<string, Value?> map) {
        var sb = new StringBuilder();
        foreach (var key in map.keys) {
            sb.append(key).append(" = ").append(ValueUtils.to_string(map[key])).append("; ");
        }
        return sb.str;
    }
}
