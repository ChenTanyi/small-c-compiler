
int s[50], a = 0x7fffffff;

int part(int l, int r){
	int x = s[l], tmp;
	int i = l, j = r;
	for (; ;){
		for (; s[i] < x; ++i);
		for (; s[j] > x; --j);
		if (i >= j){
			return j;
		}
		tmp = s[i];
		s[i] = s[j];
		s[j] = tmp;
	}
}

int qsort(int l, int r){
	if (l < r){
		int p = part(l, r);
		qsort(l, p);
		qsort(p + 1, r);
	}
}

int main(){
	int n, i;
	read(n);
	for (i = 0; i < n; ++i){
		read(s[i]);
	}
	qsort(0, n - 1);
	for (i = 0; i < n; ++i){
		write(s[i]);
	}
}