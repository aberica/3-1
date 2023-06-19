#ifndef __FHEAP_H_
#define __FHEAP_H_

#include <iostream>
#include <initializer_list>
#include <optional>
#include <vector>
#include <cmath>
#include <memory>
#include <queue>

template <typename T>
class PriorityQueue {
    public:
        virtual void insert(const T& item) = 0;
        virtual std::optional<T> extract_min() = 0;
        virtual bool is_empty() const = 0;
};

template <typename T>
class FibonacciNode {
    public:
        // Constructors
        FibonacciNode();
        FibonacciNode(const T& item)
            :key(item), degree(0), marked(false), child(nullptr), right(nullptr) {}

        // Destructor
		// You can implement your custom destructor.
        ~FibonacciNode() = default;
        
        T key;
        size_t degree;
		bool marked;

		std::shared_ptr<FibonacciNode<T>> right;
		std::shared_ptr<FibonacciNode<T>> child;
        // NOTE: To prevent circular reference, left/parent pointer should be set to weak_ptr.
        std::weak_ptr<FibonacciNode<T>> left;
        std::weak_ptr<FibonacciNode<T>> parent;
};

template <typename T>
class FibonacciHeap : public PriorityQueue<T> {
    public:
        // Constructors
        FibonacciHeap()
            : min_node(nullptr), size_(0) {}
        FibonacciHeap(const T& item)
            : min_node(nullptr), size_(0) { insert(item); }

        // Disable copy constructor.
        FibonacciHeap(const FibonacciHeap<T> &);

        // Destructor
        ~FibonacciHeap();

        void insert(const T& item) override;
		void insert(std::shared_ptr<FibonacciNode<T>>& node);

        // Return raw pointer of the min_node.
        FibonacciNode<T>* get_min_node() { return min_node.get(); }

        std::optional<T> get_min() const;

        std::optional<T> extract_min() override;

		void decrease_key(std::shared_ptr<FibonacciNode<T>>& x, T new_key);

		void remove(std::shared_ptr<FibonacciNode<T>>& node);

        bool is_empty() const override { return !size_; }

        size_t size() const { return size_; }
		
    private:

        std::shared_ptr<FibonacciNode<T>> min_node;
        size_t size_;

        void consolidate();
        void merge(std::shared_ptr<FibonacciNode<T>>& x, std::shared_ptr<FibonacciNode<T>>& y);
		void cut(std::shared_ptr<FibonacciNode<T>>& x);
		void recursive_cut(std::shared_ptr<FibonacciNode<T>>& x);

};

template <typename T>
FibonacciHeap<T>::~FibonacciHeap() {
	// TODO
	// NOTE: Be aware of memory leak or memory error.
    remove(min_node);
}

template <typename T>
std::optional<T> FibonacciHeap<T>::get_min() const {
	if(!min_node) 
		return std::nullopt;
	else
		return min_node.get()->key;
}

template <typename T>
void FibonacciHeap<T>::insert(const T& item) {
	std::shared_ptr<FibonacciNode<T>> node = std::make_shared<FibonacciNode<T>>(item);
	insert(node);
}

template <typename T>
void FibonacciHeap<T>::insert(std::shared_ptr<FibonacciNode<T>>& node) {
	// TODO
    size_++;
    if(!min_node) {
        node.get()->left = node;
        node.get()->right = node;
        min_node = node;
    }
    else {
        std::shared_ptr<FibonacciNode<T>> left_node = min_node.get()->left.lock();
        std::shared_ptr<FibonacciNode<T>> right_node = min_node;
        left_node.get()->right = node;
        node.get()->left = left_node;
        node.get()->right = right_node;
        right_node.get()->left = node;
        
        if(node.get()->key <= min_node.get()->key) {
            min_node = node;
        }
    }
}

template <typename T>
std::optional<T> FibonacciHeap<T>::extract_min() {
	// TODO
    if(!min_node) {
        return std::nullopt;
    }

    size_--;
    T return_key = min_node.get()->key;
    std::shared_ptr<FibonacciNode<T>> right_node = (min_node.get()->right == min_node) ? nullptr : min_node.get()->right;
    std::shared_ptr<FibonacciNode<T>> child_node = min_node.get()->child;

    if(!right_node && !child_node){
        remove(min_node);
    }
    else if(right_node && !child_node){
        std::shared_ptr<FibonacciNode<T>> left_node = min_node.get()->left.lock();
        left_node.get()->right = right_node;
        right_node.get()->left = left_node;
        
        remove(min_node);
        min_node = right_node;
    }
    else if(!right_node && child_node){
        remove(min_node);
        min_node = child_node;
    }
    else if(right_node && child_node) {
        std::shared_ptr<FibonacciNode<T>> left_node = min_node.get()->left.lock();
        std::shared_ptr<FibonacciNode<T>> child_left_node = min_node.get()->child->right;
        std::shared_ptr<FibonacciNode<T>> child_right_node = child_node;

        left_node.get()->right = child_left_node;
        child_left_node.get()->left = left_node;
        child_right_node.get()->right = right_node;
        right_node.get()->left = child_right_node;

        remove(min_node);
        min_node = right_node;
    }

    if(min_node) consolidate();
    
    return return_key;
}

template <typename T>
void FibonacciHeap<T>::decrease_key(std::shared_ptr<FibonacciNode<T>>& x, T new_key) {
	// TODO
    x.get()->key = new_key;

    if(!x.get()->parent.expired()) {
        std::shared_ptr<FibonacciNode<T>> parent = x.get()->parent.lock();
        if(new_key < parent.get()->key) {
            cut(x);
            recursive_cut(parent);
        }
    }

    if(x.get()->key < min_node.get()->key) {
        min_node = x;
    }
}

template <typename T>
void FibonacciHeap<T>::remove(std::shared_ptr<FibonacciNode<T>>& x) {
	// TODO
    if(x == nullptr) return;

    if(x == x.get()->right){
    	x.get()->right = nullptr;
    }
    x = nullptr;
}

template <typename T>
void FibonacciHeap<T>::consolidate() {
	float phi = (1 + sqrt(5)) / 2.0;
	int len = int(log(size_) / log(phi)) + 10;
	// TODO
    std::shared_ptr<FibonacciNode<T>>* sptarr = new std::shared_ptr<FibonacciNode<T>>[len];
    std::shared_ptr<FibonacciNode<T>> node = min_node;

    while(1) {
        size_t d = node.get()->degree;
        if(!sptarr[d]) {
            sptarr[d] = node;
            node = node.get()->right;
            if(node == min_node) {
                break;
            }
        }
        else if(node == sptarr[d]) {
            node = node.get()->right;
            if(node == min_node) break;
        }
        else {
            merge(node, sptarr[d]);
            sptarr[d] = nullptr;
        }
    }
    delete[] sptarr;
    
    node = min_node;
    std::shared_ptr<FibonacciNode<T>> Min_node = min_node;
    while(1){
        if(node.get()->key < Min_node.get()->key) {
            Min_node = node;
        }

        node = node.get()->right;
        if(node == min_node) {
            break;
        }
    }
    min_node = Min_node;
}

template <typename T>
void FibonacciHeap<T>::merge(std::shared_ptr<FibonacciNode<T>>& x, std::shared_ptr<FibonacciNode<T>>& y) {
	// TODO
    if(x.get()->key > y.get()->key) x.swap(y);
    if(min_node == y) min_node = x;

    std::shared_ptr<FibonacciNode<T>> y_left = y.get()->left.lock();
    std::shared_ptr<FibonacciNode<T>> y_right = y.get()->right;
    y_left.get()->right = y_right;
    y_right.get()->left = y_left;
    
    if(!x.get()->child) {
        x.get()->child = y;
        y.get()->parent = x;
        x.get()->degree++;

        y.get()->left = y;
        y.get()->right = y;
    }
    else {
        y.get()->parent = x;
        x.get()->degree++;
        
        std::shared_ptr<FibonacciNode<T>> x_child_left = x.get()->child;
        std::shared_ptr<FibonacciNode<T>> x_child_right = x_child_left.get()->right;
        x_child_left.get()->right = y;
        y.get()->left = x_child_left;
        y.get()->right = x_child_right;
        x_child_right.get()->left = y;
    }
}
template <typename T>
void FibonacciHeap<T>::cut(std::shared_ptr<FibonacciNode<T>>& x) {
	// TODO
    std::shared_ptr<FibonacciNode<T>> parent = x.get()->parent.lock();
    if(x.get()->right == x){
        parent.get()->child = nullptr;
    }
    else {
        std::shared_ptr<FibonacciNode<T>> x_left_node = x.get()->left.lock();
        std::shared_ptr<FibonacciNode<T>> x_right_node = x.get()->right;
        x_left_node.get()->right = x_right_node;
        x_right_node.get()->left = x_left_node;
        parent.get()->child = x_right_node;
    }

    parent.get()->degree--;
    
    std::shared_ptr<FibonacciNode<T>> left_node = min_node.get()->left.lock();
    std::shared_ptr<FibonacciNode<T>> right_node = min_node;
    left_node.get()->right = x;
    x.get()->left = left_node;
    x.get()->right = right_node;
    right_node.get()->left = x;

    x.get()->marked = false;
    x.get()->parent.reset();
}

template <typename T>
void FibonacciHeap<T>::recursive_cut(std::shared_ptr<FibonacciNode<T>>& x) {
	// TODO
    if(x.get()->parent.expired()) return;

    std::shared_ptr<FibonacciNode<T>> parent = x.get()->parent.lock();
    if(x.get()->marked == false){
        x.get()->marked = true;
    }
    else{
        cut(x);
        recursive_cut(parent);
    }
}

#endif // __FHEAP_H_
