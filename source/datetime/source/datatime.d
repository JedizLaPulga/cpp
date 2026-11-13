module datatime;

extern(C++):

struct DateTime
{
    long unixSeconds;

    void setUnix(long value)
    {
        unixSeconds = value;
    }

    long getUnix()
    {
        return unixSeconds;
    }
}

extern(C):

void datetimeInit(DateTime* obj)
{
    if (obj is null) return;
    obj.unixSeconds = 0;
}

void datetimeDestroy(DateTime* obj)
{
    if (obj is null) return;
    obj.unixSeconds = 0;
}
