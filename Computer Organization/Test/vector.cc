#include <iostream>
#include <vector>
#include <algorithm>

std::vector<int*> vec(10);

void Delete(int* num) {

  auto& vv = vec;
  vv.erase(std::remove(vv.begin(), vv.end(), num), vv.end());
  delete num;
}


int main() {
    for(int i = 0; i < 10; ++i) {
        vec[i] = new int(i);
    }
    for (auto i = vec.begin(); i != vec.end(); ++i) {
        std::cout << *i << " ";
    }
    std::cout << std::endl;

    for (int i = 0; i < 10; i++) {
        if(i % 2 == 0) {
            Delete(vec[i]);
        }
    }




    return 0;

}
