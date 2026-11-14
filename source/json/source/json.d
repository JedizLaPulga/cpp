module json;

import std.json;
import core.stdc.string;
import std.string : toStringz;

extern(C++):

struct Json {
    private JSONValue* data;
    
    void init()
    {
        if (data is null) data = new JSONValue(null);
    }
    
    void destroy()
    {
        if (data !is null) {
            .destroy(data);
            data = null;
        }
    }
    
    const(char)* parse(const(char)* jsonStr)
    {
        if (jsonStr == null) return toStringz("");
        try {
            if (data is null) init();
            *data = parseJSON(jsonStr[0..strlen(jsonStr)]);
            return toStringz("ok");
        } catch (Exception e) {
            return toStringz("error");
        }
    }
    
    const(char)* stringify() const
    {
        return (data is null) ? toStringz("null") : toStringz(data.toString());
    }
    
    long getLength() const
    {
        return (data is null || data.type != JSONType.array) ? -1 : cast(long)data.array.length;
    }
}
