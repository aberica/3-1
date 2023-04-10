#include <iostream>
using namespace std;

int main(int argc, char** argv){
    cout<<' '<<argc<<'\n';
    for(int i = 0; i<=argc; i++){
        cout<<i<<" : "<<argv[i]<<'\n';
    }
    cout<<"4: "<<argv[4]<<'\n';
}