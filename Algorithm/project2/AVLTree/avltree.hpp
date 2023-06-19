#include <iostream>
#include <optional>
#include <algorithm>
#include <unistd.h>

template <typename T, typename U>
class AVLNode {

public:
    T key;
    U value;
    AVLNode<T, U>* left;
    AVLNode<T, U>* right;
    int height;

    AVLNode<T, U>(const T& k, const U& v)
    {
        key = k;
        value = v;
        left = nullptr;
        right = nullptr;
        height = 1;
    }
    
};

template <typename T, typename U>
class AVLTree {
public:
    AVLNode<T, U>* root = nullptr;
    ~AVLTree() {
        removeall(root);

    }

    void insert(const T& key, const U& value);
    U search(const T& key);
    bool remove(const T& key);

    //for checking
    void preorder(AVLNode<T, U>*& node) {
        if (!node) return;
        std::cout << node->key << ": " << node->value << std::endl;
        preorder(node->left);
        preorder(node->right);
    }
    void inorder(AVLNode<T, U>*& node) {
        if (!node) return;
        inorder(node->left);
        std::cout << node->key << ": " << node->value << std::endl;
        inorder(node->right);
    }

private:
    int getHeight(AVLNode<T, U>*& node);
    int getBalance(AVLNode<T, U>*& node);
    AVLNode<T, U>* rotate_left(AVLNode<T, U>*& node);
    AVLNode<T, U>* rotate_right(AVLNode<T, U>*& node);

    AVLNode<T, U>* insert(AVLNode<T, U>*& node, const T& key, const U& value);
    U search(AVLNode<T, U>*& node, const T& key);
    AVLNode<T, U>* remove(AVLNode<T, U>*& node, const T& key);
    void removeall(AVLNode<T, U>*& node);
    int max(const int& a, const int& b);
};

template <typename T, typename U>
int AVLTree<T, U>::getHeight(AVLNode<T, U>*& node) {
    if (!node) return 0;
    return node->height;
}

template <typename T, typename U>
int AVLTree<T, U>::getBalance(AVLNode<T, U>*& node) {
    if (!node) return 0;
    return getHeight(node->left) - getHeight(node->right);
}

template<typename T, typename U>
void AVLTree<T, U>::insert(const T& key, const U& value) {
    root = insert(root, key, value);
}

template<typename T, typename U>
U AVLTree<T, U>::search(const T& key) {
    return search(root, key);
}

template<typename T, typename U>
bool AVLTree<T, U>::remove(const T& key) {
    if (!search(root, key).length()) return false;
    root = remove(root, key);
    return true;
}

template<typename T, typename U>
AVLNode<T, U>* AVLTree<T, U>::rotate_left(AVLNode<T, U>*& node) {
    //TODO

    AVLNode<T, U>* r_child = node->right;
    node->right = r_child->left;
    r_child->left = node;

    node->height = 1 + max(getHeight(node->left), getHeight(node->right));
    r_child->height = 1 + max(getHeight(r_child->left), getHeight(r_child->right));

    return r_child;
}

template<typename T, typename U>
AVLNode<T, U>* AVLTree<T, U>::rotate_right(AVLNode<T, U>*& node) {
    //TODO

    AVLNode<T, U>* l_child = node->left;
    node->left = l_child->right;
    l_child->right = node;

    node->height = 1 + max(getHeight(node->left), getHeight(node->right));
    l_child->height = 1 + max(getHeight(l_child->left), getHeight(l_child->right));

    return l_child;
}

template<typename T, typename U>
AVLNode<T, U>* AVLTree<T, U>::insert(AVLNode<T, U>*& node, const T& key, const U& value) {
    //TODO
    
    //empty tree
    if (node == nullptr) {
        node = new AVLNode<T, U>(key, value);
    }
    //left
    else if (key < node->key) {
        node->left = insert(node->left, key, value);
    }
    //right
    else if (node->key < key) {
        node->right = insert(node->right, key, value);
    }
    //same key found
    else if (node->key == key) {
        node->value = value;
    }

    node->height = 1 + max(getHeight(node->left), getHeight(node->right));
    
    //balancing
    // right subtree tall unbalance
    if (getBalance(node) < -1) {
        //right-left
        if (getBalance(node->right) > 0) {
            AVLNode<T, U>* rl_child = node->right->left;
            node->right->left = rl_child->right;
            rl_child->right = node->right;
            node->right = rl_child;
            rl_child->right->height = 1 + max(getHeight(rl_child->right->left), getHeight(rl_child->right->right));
            rl_child->height = 1 + max(getHeight(rl_child->left), getHeight(rl_child->right));
        }

        //right-right
        node = rotate_left(node);
    }
    // left subtree tall unbalance
    else if (getBalance(node) > 1) {
        //left-right
        if (getBalance(node->left) < 0) {
            AVLNode<T, U>* lr_child = node->left->right;
            node->left->right = lr_child->left;
            lr_child->left = node->left;
            node->left = lr_child;
            lr_child->left->height = 1 + max(getHeight(lr_child->left->right), getHeight(lr_child->left->left));
            lr_child->height = 1 + max(getHeight(lr_child->right), getHeight(lr_child->left));
        }

        //left-left
        node = rotate_right(node);
    }
    
    return node;
}

template<typename T, typename U>
U AVLTree<T, U>::search(AVLNode<T, U>*& node, const T& key) {
    //TODO
    //return NULL if there are no such key, return value if there is

    if (node == nullptr) return "";
    
    if (key < node->key) return search(node->left, key);
    if (node->key < key) return search(node->right, key);
    return node->value;
}

template<typename T, typename U>
AVLNode<T, U>* AVLTree<T, U>::remove(AVLNode<T, U>*& node, const T& key) {
    //TODO
    
    //left
    if (key < node->key) {
        node->left = remove(node->left, key);
    }
    //right
    else if (node->key < key) {
        node->right = remove(node->right, key);
    }
    //found
    else if(node->key == key) {
        //no child
        if (node->left == nullptr && node->right == nullptr) {
            delete node;
            return nullptr;
        }
        //has r_child
        else if (node->right != nullptr) {
            AVLNode<T, U>* max_node = node->right;
            while (max_node->left != nullptr) max_node = max_node->left;
            node->key = max_node->key;
            node->value = max_node->value;
            node->right = remove(node->right, max_node->key);
        }
        //has l_child
        else if (node->left != nullptr) {
            AVLNode<T, U>* min_node = node->left;
            while (min_node->right != nullptr) min_node = min_node->right;
            node->key = min_node->key;
            node->value = min_node->value;
            node->left = remove(node->left, min_node->key);
        }
    }

    node->height = 1 + max(getHeight(node->left), getHeight(node->right));

    //balancing
    // right subtree tall unbalance
    if (getBalance(node) < -1) {
        //right-left
        if (getBalance(node->right) > 0) {
            AVLNode<T, U>* rl_child = node->right->left;
            node->right->left = rl_child->right;
            rl_child->right = node->right;
            node->right = rl_child;
            rl_child->right->height = 1 + max(getHeight(rl_child->right->left), getHeight(rl_child->right->right));
            rl_child->height = 1 + max(getHeight(rl_child->left), getHeight(rl_child->right));
        }

        //right-right
        node = rotate_left(node);
    }
    // left subtree tall unbalance
    else if (getBalance(node) > 1) {
        //left-right
        if (getBalance(node->left) < 0) {
            AVLNode<T, U>* lr_child = node->left->right;
            node->left->right = lr_child->left;
            lr_child->left = node->left;
            node->left = lr_child;
            lr_child->left->height = 1 + max(getHeight(lr_child->left->right), getHeight(lr_child->left->left));
            lr_child->height = 1 + max(getHeight(lr_child->right), getHeight(lr_child->left));
        }

        //left-left
        node = rotate_right(node);
    }

    return node;
}

template<typename T, typename U>
void AVLTree<T, U>::removeall(AVLNode<T, U>*& node) {
    //TODO
    //for destructor
    if (node->left != nullptr) removeall(node->left);
    if (node->right != nullptr) removeall(node->right);
    delete node;
}

template<typename T, typename U>
int AVLTree<T, U>::max(const int& a, const int& b){
    if(a>b) return a;
    else return b;
}
