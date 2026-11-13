#include <iostream>

#include "../build/include/datetime.hpp"

int main()
{
    DateTimeHandle value;
    value.setUnix(1731456000);
    std::cout << "unix=" << value.getUnix() << std::endl;
    return 0;
}
