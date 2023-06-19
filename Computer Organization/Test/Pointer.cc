#include <iostream>
using namespace std;

class Class{
    public:
        Class() {
            cout<<"Constructor\n";
            a=nullptr;
        }
        void update() {
            a = new int(10);
        }
        ~Class() {
            cout<<"Destructor\n";
            if(a) {
                cout<<"Delete a : "<<*a<<"\n";

                delete a;
            }
        }
    private:
        int* a;
};


int main () {
    Class* class1 = new Class();
    class1->update();
    delete class1;
    return 0;
}