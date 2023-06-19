#include <iostream>
#include <vector>
using namespace std;

int main () {
    vector<int> vec = {0, 1, 2, 3, 4, 5, 5, 5, 6, 7, 8, 9};
    for (int i = 0, t= 0; i < vec.size(); ++i, ++t) {
        cout<<t<<' '<<i<<' '<<vec[i];
        if (vec[i] == 5) {
            vec.erase(vec.begin() + i);
            cout<<" : erased";
            i--;
        }
        cout<<endl;
    }
    cout<<endl;
    for (int i = 0; i < vec.size() ;i++) {
        cout<<vec[i]<<' ';
    }
    cout<<endl;
    return 0;
}