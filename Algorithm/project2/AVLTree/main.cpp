#include <algorithm>
#include <iterator>
#include <vector>
#include <random>
#include <time.h>
#include <string>

#include "avltree.hpp"
#include <iostream>

//#include "crtdbg.h"

using namespace std;

void test() {
    clock_t start_insert_remove, finish_insert_remove;

    AVLTree<int, string> at;

    start_insert_remove = clock();
    
    // at.insert(16, "yf") ;
    // at.insert(4, "rg") ;
    // at.insert(6, "fj") ;;
    // at.insert(7, "zm") ;
    // at.insert(9, "aq") ;
    // at.insert(13, "gw") ;
    // at.insert(13, "ry") ;
    // at.insert(12, "ve") ;
    // at.insert(2, "xo") ;
    // at.insert(11, "kz") ;
    // at.insert(4, "nv") ;
    // at.insert(6, "yx") ;
    // at.insert(12, "te") ;
    // at.insert(17, "uj") ;
    // at.insert(18, "go") ;
    // at.insert(9, "wb") ;
    // at.insert(10, "an") ;
    // at.insert(19, "it") ;
    // at.insert(3, "wh") ;
    // at.insert(17, "to");

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

    finish_insert_remove = clock();
    cout << "time for insert and remove: " << (double)(finish_insert_remove - start_insert_remove) << "ms" << endl;
    cout << "inorder : " << endl;
    at.inorder(at.root);
    cout<<"preorder : " << endl;
    at.preorder(at.root);

    /*
    47261: 0
    147264: 0
    247267: 0
    347270: 0
    447273: 0
    547276: 0
    647279: 0
    747282: 0
    847285: 0
    947288: 0
    */

    return;
}

int main() {
    test();

    //_CrtDumpMemoryLeaks();

    return 0;
}