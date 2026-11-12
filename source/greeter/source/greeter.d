module greeter;

extern(C) nothrow @nogc:

const(char)* greet()
{
    return "Hello from D (libgreeter)\0".ptr;
}
