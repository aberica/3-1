#include <iostream>
#include "header.h"

int main () {
    Class* class1 = new Class();
    class1->update();
    delete class1;
    return 0;
}