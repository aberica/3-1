#include "header.h"

Class::Class() {
    a = nullptr;
}
void Class::update() {
    a = new int(10);
}
Class::~Class() {
    if(a) {
        delete a;
    }
}