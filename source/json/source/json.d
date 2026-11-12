module json;

import std.json;
import std.array : Appender, appender;
import std.format : format;
import core.stdc.string;

private void formatValue(JSONValue value, ref Appender!string output)
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
            output.put("[");
            foreach (size_t i, item; value.array) {
                formatValue(item, output);
                if (i + 1 < value.array.length) output.put(",");
            }
            output.put("]");
            break;
        case JSONType.object:
            output.put("{");
            size_t i = 0;
            foreach (key, item; value.object) {
                output.put("\"" ~ key ~ "\":");
                formatValue(item, output);
                if (i + 1 < value.object.length) output.put(",");
                i++;
            }
            output.put("}");
            break;
    }
}

extern(C++):

struct Json {
    JSONValue* data;
    
    void parse(const(char)* jsonStr)
    {
        if (jsonStr == null) return;
        try {
            *data = parseJSON(jsonStr[0..strlen(jsonStr)]);
        } catch (Exception e) {
            *data = JSONValue(null);
        }
    }
    
    const(char)* stringify()
    {
        try {
            auto output = appender!string;
            formatValue(*data, output);
            return output.data.dup.ptr;
        } catch (Exception e) {
            return "null".ptr;
        }
    }
    
    long getLength()
    {
        if (data.type == JSONType.array) {
            return data.array.length;
        }
        return -1;
    }
}

extern(C):

void jsonInit(Json* obj)
{
    try {
        obj.data = new JSONValue(null);
    } catch (Exception e) {
    }
}

void jsonDestroy(Json* obj)
{
    if (obj !is null && obj.data !is null) {
        destroy(obj.data);
        obj.data = null;
    }
}
