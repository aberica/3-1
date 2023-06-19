#include <iostream>

template <typename T>
struct Item{
    T value;
    int priority;
};

template <typename T>
class Queue{
    private:
        int front;
        int rear;
        bool empty;
        int size;
        Item<T> *array;

    public:
        Queue<T>(int _size = 16)
        {
            front = 0;
            rear = _size - 1;
            empty = true;
            size = _size;
            array = new Item<T>[_size];
        }
        ~Queue(){
            delete[] array;
        }

        void enqueue(const T& value, int priority);
        int top();
        T dequeue();        
        bool isFull();
        void Print();
};

template <typename T>
void Queue<T>::enqueue(const T& value, int priority){
    //TODO

    if (isFull()) {
        Item<T>* tmp = new Item<T>[size * 2];
        for (int i = 0; i < size; i++) {
            tmp[i] = array[front];
            if (++front == size) front = 0;
        }
        front = 0;
        rear = size - 1;
        size *= 2;
        delete[] array;
        array = tmp;
    }

    empty = false;
    if (++rear == size) rear = 0;
    array[rear] = { value, priority };

    return;
}

template <typename T>
int Queue<T>::top(){
    //TODO
    //returning the array index of the highest priority item

    //no data
    if (empty) return -1;   

    //1 or more data
    int h_idx = front, idx = front;     
    while (1) {
        if (array[idx].priority > array[h_idx].priority) {
            h_idx = idx;
        }
        if (idx == rear) break;
        
        if (++idx == size) idx = 0;
    }

    return h_idx;
}

template <typename T>
T Queue<T>::dequeue(){
    //TODO

    //no data
    if (empty) return NULL; 

    int t = top();

    //data copy X
    if (front == t) {
        if (front == rear) empty = true;    // only 1 data
        if (++front == size) front = 0;
        return array[t].value;
    }

    //data copy O
    int i = t - 1;
    while (1) {
        if (i < 0) {
            i = size - 1;
            array[0] = array[i];
        }
        else {
            array[i + 1] = array[i];
        }

        if (i == front) break;

        i--;
    }
    if (++front == size) front = 0;
    return array[t].value;
}

template <typename T>
bool Queue<T>::isFull(){
    //TODO

    if (!empty && ((front == 0 && rear == size - 1) || front - 1 == rear)) return true;
    else return false;
}

template <typename T>
void Queue<T>::Print() {
    int idx = front;
    std::cout << "value : ";
    if (!empty) {
        while (1) {
            std::cout << array[idx].value << ' ';
            if (idx == rear) break;
            if (++idx == size) idx = 0;
        }
    }
    std::cout << '\n';
    idx = front;
    std::cout << "prior : ";
    if (!empty) {
        while (1) {
            std::cout << array[idx].priority << ' ';
            if (idx == rear) break;
            if (++idx == size) idx = 0;
        }

    }
    std::cout << '\n';
    std::cout << "front : " << front << ", rear : " << rear << ", top arr : " << top() << ", empty : " << empty << '\n';
}