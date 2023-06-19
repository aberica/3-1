#include <iostream>
#include <algorithm>
#include <optional>
//#include <unistd.h>

template <typename T, typename U>
class RBNode {

public:
    T key;
    U value;
    RBNode<T, U>* parent;
    RBNode<T, U>* left;
    RBNode<T, U>* right;
    int color; // 1 -> red, 0 -> black

    RBNode<T, U>(const T& k, const U& v)
    {
        key = k;
        value = v;
        left = nullptr;
        right = nullptr;
        parent = nullptr;
    }

};

template <typename T, typename U>
class RBTree {
public:
    RBNode<T, U>* root = nullptr;
    ~RBTree() {
        removeall(root);
    }

    void insert(const T& key, const U& value);
    U search(const T& key);
    bool remove(const T& key);

    //for checking
    void preorder(RBNode<T, U>*& node) {
        if (!node) return;

        std::cout << node->key << ": " << node->value << std::endl;
        preorder(node->left);
        preorder(node->right);
    }
    void inorder(RBNode<T, U>*& node) {
        if (!node) return;

        inorder(node->left);
        std::cout << node->key << ": " << node->value << std::endl;
        inorder(node->right);
    }

private:
    RBNode<T, U>* rotate_left(RBNode<T, U>*& node);
    RBNode<T, U>* rotate_right(RBNode<T, U>*& node);

    RBNode<T, U>* insert(RBNode<T, U>*& node, const T& key, const U& value);
    U search(RBNode<T, U>*& node, const T& key);
    RBNode<T, U>* remove(RBNode<T, U>*& node, const T& key);
    void removeall(RBNode<T, U>*& node);
    int nullpath_length(RBNode<T, U>*& node);
    RBNode<T, U>* remove_balancing(RBNode<T, U>*& node);
};

template<typename T, typename U>
void RBTree<T, U>::insert(const T& key, const U& value) {
    root = insert(root, key, value);
}

template<typename T, typename U>
U RBTree<T, U>::search(const T& key) {
    return search(root, key);
}

template<typename T, typename U>
bool RBTree<T, U>::remove(const T& key) {
    if (!search(root, key).length()) return false;
    root = remove(root, key);
    return true;
}

template<typename T, typename U>
RBNode<T, U>* RBTree<T, U>::rotate_left(RBNode<T, U>*& node) {
    //TODO

    RBNode<T, U>* r_child = node->right;

    node->right = r_child->left;
    r_child->left = node;
    node = r_child;

    node->parent = node;
    node->left->parent = node;
    if (node->left->right != nullptr) node->left->right->parent = node->right;

    return node;
}

template<typename T, typename U>
RBNode<T, U>* RBTree<T, U>::rotate_right(RBNode<T, U>*& node) {
    //TODO

    RBNode<T, U>* l_child = node->left;

    node->left = l_child->right;
    l_child->right = node;
    node = l_child;

    node->parent = node;
    node->right->parent = node;
    if (node->right->left != nullptr) node->right->left->parent = node->left;

    return node;
}

template<typename T, typename U>
RBNode<T, U>* RBTree<T, U>::insert(RBNode<T, U>*& node, const T& key, const U& value) {
    //TODO

    //empty tree
    if (node == nullptr) {
        node = new RBNode<T, U>(key, value);
        node->color = 0;
        node->parent = node;
    }
    //left
    else if (key < node->key) {
        node->left = insert(node->left, key, value);
        node->left->parent = node;
        if (node->left->key == key && node->left->left == nullptr && node->left->right == nullptr) node->left->color = 1;
    }
    //right
    else if (node->key < key) {
        node->right = insert(node->right, key, value);
        node->right->parent = node;
        if (node->right->key == key && node->right->left == nullptr && node->right->right == nullptr) node->right->color = 1;
    }
    //same key node found
    else if (node->key == key) {
        node->value = value;
    }

    //color swap
    // node:black, l_child:red, r_child:red 
    if (node->color == 0 &&
        node->left != nullptr && node->left->color == 1 && 
        node->right != nullptr && node->right->color == 1) {
        if (node->parent != node) node->color = 1;
        node->left->color = 0;
        node->right->color = 0;
    }

    //rotate_right
    if (node->color == 0 && node->left != nullptr && node->left->color == 1 && 
        ((node->left->left != nullptr && node->left->left->color == 1) || (node->left->right != nullptr && node->left->right->color == 1))) {
        if (node->left->right != nullptr && node->left->right->color == 1) {
            RBNode<T, U>* l_child = node->left;
            RBNode<T, U>* lr_child = node->left->right;

            l_child->right = lr_child->left;
            node->left = lr_child;
            lr_child->left = l_child;

            node->left->parent = node;
            node->left->left->parent = node->left;
            if (node->left->left->right != nullptr) node->left->left->right->parent = node->left->left;
        }
        node = rotate_right(node);
        node->color = 0;
        node->right->color = 1;
    }
    //rotate_left
    else if (node->color == 0 && node->right != nullptr && node->right->color == 1 && 
        ((node->right->left != nullptr && node->right->left->color == 1) || (node->right->right != nullptr && node->right->right->color == 1))) {
        if (node->right->left != nullptr && node->right->left->color == 1) {
            RBNode<T, U>* r_child = node->right;
            RBNode<T, U>* rl_child = node->right->left;

            r_child->left = rl_child->right;
            node->right = rl_child;
            rl_child->right = r_child;

            node->right->parent = node;
            node->right->right->parent = node->right;
            if (node->right->right->left != nullptr) node->right->right->left->parent = node->right->right;
        }
        node = rotate_left(node);
        node->color = 0;
        node->left->color = 1;
    }

    return node;
}

template<typename T, typename U>
U RBTree<T, U>::search(RBNode<T, U>*& node, const T& key) {
    //TODO
    //return NULL if there are no such key, return value if there is

    if (node == nullptr) return "";

    if (key < node->key) return search(node->left, key);
    if (node->key < key) return search(node->right, key);
    return node->value;
}

template<typename T, typename U>
RBNode<T, U>* RBTree<T, U>::remove(RBNode<T, U>*& node, const T& key) {
    //TODO
    
    //left
    if (key < node->key) {
        node->left = remove(node->left, key);
        if (node->left != nullptr) node->left->parent = node;
    }
    //right
    else if (node->key < key) {
        node->right = remove(node->right, key);
        if (node->right != nullptr) node->right->parent = node;
    }
    //found
    else {
        //no child
        if (node->left == nullptr && node->right == nullptr) {
            delete node;
            return nullptr;
        }
        //has r_child
        else if (node->right != nullptr) {
            RBNode<T, U>* max_node = node->right;
            while (max_node->left != nullptr) max_node = max_node->left;
            node->key = max_node->key;
            node->value = max_node->value;
            node->right = remove(node->right, max_node->key);
            if (node->right != nullptr) node->right->parent = node;
        }
        //has l_child
        else if (node->left != nullptr) {
            RBNode<T, U>* min_node = node->left;
            while (min_node->right != nullptr) min_node = min_node->right;
            node->key = min_node->key;
            node->value = min_node->value;
            node->left = remove(node->left, min_node->key);
            if (node->left != nullptr) node->left->parent = node;
        }
    }

    node = remove_balancing(node);
    
    return node;
}

template<typename T, typename U>
void RBTree<T, U>::removeall(RBNode<T, U>*& node) {
    //TODO
    //for destructor

    if (node == nullptr) return;
    if (node->left != nullptr) removeall(node->left);
    if (node->right != nullptr) removeall(node->right);
    delete node;
}

template<typename T, typename U>
int RBTree<T, U>::nullpath_length(RBNode<T, U>*& node) {
    if (node == nullptr) return 0;
    if (node->color == 0) return nullpath_length(node->left) + 1;
    else return nullpath_length(node->left);
}

template<typename T, typename U>
RBNode<T, U>* RBTree<T, U>::remove_balancing(RBNode<T, U>*& node) {

    //left short
    if (nullpath_length(node->left) < nullpath_length(node->right)) {
        //l_child: red_and_black
        if (node->left != nullptr && node->left->color == 1) {
            node->left->color = 0;
        }
        //l_child: doubly_black(nullptr or black)
        else {
            // r_child: red - case1
            if (node->right != nullptr && node->right->color == 1) {
                node->color = 1;
                node->right->color = 0;
                node = rotate_left(node);
                node->left = remove_balancing(node->left);
                node->left->parent = node;
                if (node->left->color == 1) {
                    node->left->color = 0;
                    return node;
                }
            }
            // r_child: black ->
            //  rl_child: black, rr_child: black - case2
            if (node->right != nullptr && node->right->color == 0 &&
                (node->right->left == nullptr || node->right->left->color == 0) &&
                (node->right->right == nullptr || node->right->right->color == 0)) {
                node->right->color = 1;
            }
            //  rl_child: red, rr_child: black - case3
            if (node->right != nullptr && node->right->color == 0 &&
                node->right->left != nullptr && node->right->left->color == 1 &&
                (node->right->right == nullptr || node->right->right->color == 0)) {
                node->right->color = 1;
                node->right->left->color = 0;
                node->right = rotate_right(node->right);
                node->right->parent = node;
            }
            //  rl_child: ?, rr_child: red - case4
            if (node->right != nullptr && node->right->color == 0 &&
                node->right->right != nullptr && node->right->right->color == 1) {
                node->right->color = node->color;
                node->right->right->color = 0;
                node->color = 0;
                node = rotate_left(node);
                node->parent = node;
            }
        }
    }

    //right short
    else if (nullpath_length(node->left) > nullpath_length(node->right)) {
        //r_child: red_and_black
        if (node->right != nullptr && node->right->color == 1) {
            node->right->color = 0;
        }
        //r_child: doubly_black
        else {
            // l_child: red - case1
            if (node->left != nullptr && node->left->color == 1) {
                node->color = 1;
                node->left->color = 0;
                node = rotate_right(node);
                node->right = remove_balancing(node->right);
                node->right->parent = node;
                if (node->right->color == 1) {
                    node->right->color = 0;
                    return node;
                }
            }
            // l_child: black
            //  lr_child: black, ll_child: black - case2
            if (node->left != nullptr && node->left->color == 0 &&
                (node->left->right == nullptr || node->left->right->color == 0) &&
                (node->left->left == nullptr || node->left->left->color == 0)) {
                node->left->color = 1;
            }
            //  lr_child: red, ll_child: black - case3
            if (node->left != nullptr && node->left->color == 0 &&
                node->left->right != nullptr && node->left->right->color == 1 &&
                (node->left->left == nullptr || node->left->left->color == 0)) {
                node->left->color = 1;
                node->left->right->color = 0;
                node->left = rotate_left(node->left);
                node->left->parent = node;
            }
            //  lr_child: ?, ll_child: red - case4
            if (node->left != nullptr && node->left->color == 0 &&
                node->left->left != nullptr && node->left->left->color == 1) {
                node->left->color = node->color;
                node->left->left->color = 0;
                node->color = 0;
                node = rotate_right(node);
            }
        }
    }

    return node;
}