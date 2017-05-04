int s[50];

int main(){
	int n, i;
	read(n);
	i = 0;
	for (; 1; ){
		if (n <= 10)
			if (i > n)
				break;
			else {
				++i;
			}
		--n;
		++i;
	}
	write(n);
	write(i);
}