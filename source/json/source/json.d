module json;

import std.json;
import std.array : Appender, appender, split;
import std.format : format;
import std.stdio : writeln;
import core.stdc.string;

private void toPrettyString(JSONValue value, ref Appender!string output, int indent)
{
    final switch (value.type) {
        case JSONType.null_:
            output.put("null");
            break;
        case JSONType.true_:
            output.put("true");
            break;
        case JSONType.false_:
            output.put("false");
            break;
        case JSONType.integer:
            output.put(format("%d", value.integer));
            break;
        case JSONType.uinteger:
            output.put(format("%u", value.uinteger));
            break;
        case JSONType.float_:
            output.put(format("%g", value.floating));
            break;
        case JSONType.string:
            output.put('"');
            foreach (c; value.str) {
                if (c == '"') output.put("\\\"");
                else if (c == '\\') output.put("\\\\");
                else if (c == '\n') output.put("\\n");
                else output.put(c);
            }
            output.put('"');
            break;
        case JSONType.array:
            if (value.array.length == 0) {
                output.put("[]");
            } else {
                output.put("[\n");
                foreach (size_t i, item; value.array) {
                    for (int j = 0; j <= indent; j++) output.put("  ");
                    toPrettyString(item, output, indent + 1);
                    if (i + 1 < value.array.length) output.put(",");
                    output.put("\n");
                }
                for (int j = 0; j < indent; j++) output.put("  ");
                output.put("]");
            }
            break;
        case JSONType.object:
            if (value.object.length == 0) {
                output.put("{}");
            } else {
                output.put("{\n");
                size_t i = 0;
                foreach (key, item; value.object) {
                    for (int j = 0; j <= indent; j++) output.put("  ");
                    output.put("\"" ~ key ~ "\": ");
                    toPrettyString(item, output, indent + 1);
                    if (i + 1 < value.object.length) output.put(",");
                    output.put("\n");
                    i++;
                }
                for (int j = 0; j < indent; j++) output.put("  ");
                output.put("}");
            }
            break;
    }
}

extern(C++):

/// Parse JSON string and output formatted result to stdout
void parseAndDisplay(const(char)* jsonStr)
{
    if (jsonStr == null) return;
    
    try {
        JSONValue parsed = parseJSON(jsonStr[0..strlen(jsonStr)]);
        
        auto output = appender!string;
        toPrettyString(parsed, output, 0);
        writeln(output.data);
    } catch (Exception e) {
        writeln("Error parsing JSON");
    }
}

/// Extract value from JSON by key path (dot-separated)
const(char)* getValueByPath(const(char)* jsonStr, const(char)* keyPath)
{
    if (jsonStr == null || keyPath == null) return "null".ptr;
    
    try {
        JSONValue parsed = parseJSON(jsonStr[0..strlen(jsonStr)]);
        string path = keyPath[0..strlen(keyPath)].dup;
        auto keys = path.split(".");
        JSONValue current = parsed;
        
        foreach (key; keys) {
            if (current.type == JSONType.object && key in current.object) {
                current = current.object[key];
            } else {
                return "null".ptr;
            }
        }
        
        writeln(current.toString());
        return current.toString().dup.ptr;
    } catch (Exception e) {
        return "null".ptr;
    }
}

/// Filter array of objects by key-value pair
const(char)* filterByField(const(char)* jsonStr, const(char)* fieldName, const(char)* fieldValue)
{
    if (jsonStr == null || fieldName == null || fieldValue == null) return "[]".ptr;
    
    try {
        JSONValue parsed = parseJSON(jsonStr[0..strlen(jsonStr)]);
        
        if (parsed.type != JSONType.array) return "[]".ptr;
        
        JSONValue[] filtered;
        string field = fieldName[0..strlen(fieldName)].dup;
        string value = fieldValue[0..strlen(fieldValue)].dup;
        
        foreach (item; parsed.array) {
            if (item.type == JSONType.object && field in item.object) {
                if (item.object[field].toString() == value || 
                    (item.object[field].type == JSONType.string && item.object[field].str == value)) {
                    filtered ~= item;
                }
            }
        }
        
        JSONValue result = JSONValue(filtered);
        auto output = appender!string;
        toPrettyString(result, output, 0);
        writeln(output.data);
        return result.toString().dup.ptr;
    } catch (Exception e) {
        return "[]".ptr;
    }
}

/// Transform array elements by mapping a field
const(char)* mapField(const(char)* jsonStr, const(char)* fieldName)
{
    if (jsonStr == null || fieldName == null) return "[]".ptr;
    
    try {
        JSONValue parsed = parseJSON(jsonStr[0..strlen(jsonStr)]);
        
        if (parsed.type != JSONType.array) return "[]".ptr;
        
        JSONValue[] mapped;
        string field = fieldName[0..strlen(fieldName)].dup;
        
        foreach (item; parsed.array) {
            if (item.type == JSONType.object && field in item.object) {
                mapped ~= item.object[field];
            }
        }
        
        JSONValue result = JSONValue(mapped);
        auto output = appender!string;
        toPrettyString(result, output, 0);
        writeln(output.data);
        return result.toString().dup.ptr;
    } catch (Exception e) {
        return "[]".ptr;
    }
}

/// Merge two JSON objects
const(char)* mergeObjects(const(char)* json1, const(char)* json2)
{
    if (json1 == null || json2 == null) return "{}".ptr;
    
    try {
        JSONValue obj1 = parseJSON(json1[0..strlen(json1)]);
        JSONValue obj2 = parseJSON(json2[0..strlen(json2)]);
        
        if (obj1.type != JSONType.object || obj2.type != JSONType.object) {
            return "{}".ptr;
        }
        
        foreach (key, value; obj2.object) {
            obj1.object[key] = value;
        }
        
        auto output = appender!string;
        toPrettyString(obj1, output, 0);
        writeln(output.data);
        return obj1.toString().dup.ptr;
    } catch (Exception e) {
        return "{}".ptr;
    }
}

/// Count elements in array
long countElements(const(char)* jsonStr)
{
    if (jsonStr == null) return 0;
    
    try {
        JSONValue parsed = parseJSON(jsonStr[0..strlen(jsonStr)]);
        if (parsed.type == JSONType.array) {
            writeln(format("Array has %d elements", parsed.array.length));
            return parsed.array.length;
        }
        return -1;
    } catch (Exception e) {
        return -1;
    }
}
