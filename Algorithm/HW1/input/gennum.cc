#include <iostream>
#include <random>
#include <fstream>

#define MAX 10000000

using namespace std;

int main(){
    string type; cout<<"type(zero, one, ascending, random): "; cin>>type;

    string address; cout<<"address: "; cin>>address;
    ofstream ofs; ofs.open(address);

    int N; cout<<"N: "; cin>>N;
    int M; cout<<"M: "; cin>>M;
    
    ofs<<N<<' '<<M<<'\n';
    if(type == "zero"){
        for(int i = 1; i<=MAX; i++){
            ofs<<0<<' ';
        }
    }
    else if(type == "one"){
        for(int i = 1; i<=MAX; i++){
            ofs<<1<<' ';
        }
    }
    else if(type == "ascending"){
        for(int i = 1; i<=N; i++){
            ofs<<i<<' ';
        }
    }
    else if(type=="random"){
        int max_num; cout<<"max num: ";cin>>max_num;
        srand(time(NULL));
        for(int i = 1; i<=N; i++){
            ofs<<rand()%max_num<<' ';
        }
    }
    
    return 0;
}
