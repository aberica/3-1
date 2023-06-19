#include <iostream>
#include <vector>
using namespace std;

class Class{
    public:
    bool exist;
    Class () {
        exist = true;
    }
};

int main () {
    vector<Class*> vec;
    Class* a = new Class();

    vec.push_back(a);

    for(auto itr = vec.begin(); itr != vec.end(); ++itr) {
        std::cout<<(*itr)->exist<<std::endl;
    }


    for(auto itr = vec.begin(); itr != vec.end(); ++itr) {
        auto ele = *itr;
        ele->exist = false;
    }

    for(auto itr = vec.begin(); itr != vec.end(); ++itr) {
        std::cout<<(*itr)->exist<<std::endl;
    }

    return 0;
}