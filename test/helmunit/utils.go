package helmunit

func mergeMaps(a, b map[string]interface{}) map[string]interface{} {
    out := make(map[string]interface{}, len(a))
    for k, v := range a {
        out[k] = v
    }
    for k, v := range b {
        if v, ok := v.(map[string]interface{}); ok {
            if bv, ok := out[k]; ok {
                if bv, ok := bv.(map[string]interface{}); ok {
                    out[k] = mergeMaps(bv, v)
                    continue
                }
            }
        }
        out[k] = v
    }
    return out
}
