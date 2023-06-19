#include <algorithm>
#include <iterator>
#include <vector>
#include <random>
#include <time.h>
#include <string>

#include "RBtree.hpp"
#include <iostream>

//#include "crtdbg.h"

using namespace std;

void case1(auto& at){
    at.insert(16, "yf") ;
    at.insert(4, "rg") ;
    at.insert(6, "fj") ;
    at.insert(7, "zm") ;
    at.insert(9, "aq") ;
    at.insert(13, "gw") ;
    at.insert(13, "ry") ;
    at.insert(12, "ve") ;
    at.insert(2, "xo") ;
    at.insert(11, "kz") ;
    at.insert(4, "nv") ;
    at.insert(6, "yx") ;
    at.insert(12, "te") ;
    at.insert(17, "uj") ;
    at.insert(18, "go") ;
    at.insert(9, "wb") ;
    at.insert(10, "an") ;
    at.insert(19, "it") ;
    at.insert(3, "wh") ;
    at.insert(17, "to");
}
void case2(auto& at){
    at.insert(34, "ax");
    at.insert(6, "jr");
    at.insert(7,"zl");
    at.insert(12, "fk") ;
    at.insert(1, "fr") ;
    at.insert(13, "ku");
    at.insert(20, "ye") ;
    at.insert(39,"qh") ;
    at.insert(43, "hb") ;
    at.insert(17, "kp") ;
    at.insert(29, "ld") ;
    at.insert(2, "sg") ;
    at.insert(18, "ku") ;
    at.insert(31, "pq") ;
    at.insert(44, "pr") ;
    at.insert(8, "mu") ;
    at.insert(5, "br") ;
    at.insert(30, "ij") ;
    at.insert(26, "ud") ;
    at.insert(16, "kp");
    at.remove(12); 
    at.remove(1);
    at.remove(18);
    at.remove(20);
    at.remove(44);
    at.remove(2);
    at.remove(26);
    at.remove(7);
    at.remove(8);
    at.remove(16);
}
void case3(auto& at){
    at.insert(20, "uk");
    at.insert(11, "sy");
    at.insert(11, "xi");
    at.insert(20, "td");
    at.insert(15, "xw");
    at.insert(17, "wp");
    at.insert(17, "uh");
    at.insert(11, "hb");
    at.insert(9, "fo");
    at.insert(7, "jo");
    at.insert(10, "qp");
    at.insert(10, "nr");
    at.insert(16, "dw");
    at.insert(7, "zv");
    at.insert(3, "da");
    at.insert(19, "yq");
    at.insert(1, "jn");
    at.insert(16, "wa");
    at.insert(4, "yv");
    at.insert(6, "jr");
}
void test() {
    clock_t start_insert_remove, finish_insert_remove;

    RBTree<int, string> at;

    cout << "======start=======" << endl;
    start_insert_remove = clock();

    case3(at);

    finish_insert_remove = clock();
    cout << "time for insert and remove: " << (double)(finish_insert_remove - start_insert_remove) << "ms" << endl;
    cout << "inorder : " << endl;
    at.inorder(at.root);
    cout << "preorder : " << endl;
    at.preorder(at.root);

    return;
}

int main() {
    test();

    //_CrtDumpMemoryLeaks();

    return 0;
}