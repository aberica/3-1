#include <iostream>
#include <fstream>
#define MAX 5000000	// max size of num array
using namespace std;

// All index starts from 1, not 0.
int N, M;
int num[MAX + 10], median[MAX / 5 + 10];					// num<-test.in, median<-A[1:5], A[6:10]...

// "Randomized_select"
int Median_of_Three(int A[], int p, int r) {
    int m = p + (r - p) / 2;
    
    if (A[p] > A[m]) swap(A[p], A[m]);
    if (A[p] > A[r]) swap(A[p], A[r]);
    if (A[m] > A[r]) swap(A[m], A[r]);

    swap(A[m], A[r]);
    return A[r];
}
int Partition(int A[], int p, int r) {						// make partition of A[p:r] by A[r]
	int x = Median_of_Three(A, p, r);
	int i = p - 1;
	for (int j = p; j < r; j++) {
		if (A[j] > x) continue;
		i++;
		swap(A[i], A[j]);
	}
	swap(A[i+1], A[r]);

	int j;
	for(j = i; j >= p && A[j] == A[i + 1]; j--) {}
	return ((j+1)+(i+1))/2;
}
int Randomized_select(int A[], int p, int r, int i) {		// find i'th biggest num in unsorted A[p:r] with random partition
	if (p == r) return A[p];
	int q = Partition(A, p, r);						// q<-partition idx
	int k = q - p + 1;
	if (i == k) return A[q];
	else if (i < k) return Randomized_select(A, p, q - 1, i);
	else return Randomized_select(A, q + 1, r, i - k);
}

// "Deterministic_select"
void Insertion_sort(int A[], int p, int r) {				// insertion sort about A[p:r]
	int i, j, key;
	for (i = p + 1; i <= r; i++) {
		key = A[i];
		for (j = i - 1; j >= p && A[j] >= key; j--) {
			A[j + 1] = A[j];
		}
		A[j + 1] = key;
	}
}
int Partition(int A[], int p, int r, int x) {				// make partition of A[p:r] by x
	for (int j = p; j <= r; j++) {
		if (A[j] != x) continue;
		swap(A[j], A[r]);
		break;
	}
	return Partition(A, p, r);
}
int Deterministic_select(int A[], int p, int r, int i) {	// find i'th biggest num in unsorted A[p:r] with partition using median
	int n = r - p + 1;
	int median_num = (n + 4) / 5;
	if (n <= 5) {
		Insertion_sort(A, p, r);
		return A[p+i-1];
	}
	for (int t = 1; t <= median_num; t++) {				// e.g.) median[1] = A[p:p+4]
		int a = p + (t - 1) * 5;
		int b = min(a + 4, r);
		Insertion_sort(A, a, b);
		median[t] = A[(a + b) / 2];
	}
	int M = Deterministic_select(median, 1, median_num, (1 + median_num) / 2);	// M<-median of median array

	int q = Partition(A, p, r, M);
	int k = q - p + 1;
	if (i == k) return A[q];
	else if (i < k) return Deterministic_select(A, p, q - 1, i);
	else return Deterministic_select(A, q + 1, r, i - k);
}


int main(int argc, char** argv) {
	string T = argv[1], inp = argv[2], out = argv[3];

	ifstream ifs; ifs.open(inp);
	ofstream ofs; ofs.open(out);
	ifs>>N>>M;

	for(int i = 1; i<=N; i++) ifs>>num[i];

	if(T=="1") ofs<<Randomized_select(num, 1, N, M);
	else if(T=="2") ofs<<Deterministic_select(num, 1, N, M);

	return 0;
}
