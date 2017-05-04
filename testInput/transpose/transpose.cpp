
int s[5][5] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25};

int transpose(int n){
	int c[5][5], i, j;
	for (i = 0; i < n; ++i){
		for (j = 0; j < n; ++j){
			c[i][j] = s[j][i];
		}
	}
	for (i = 0; i < n; ++i){
		for (j = 0; j < n; ++j){
			s[i][j] = c[i][j];
		}
	}
}

int main(){
	int n, i, j;
	read(n);
	transpose(n);
	for (i = 0; i < n; ++i){
		for (j = 0; j < n; ++j){
			write(s[i][j]);
		}
	}
}