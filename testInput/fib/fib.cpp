int a[5000] = {1, 1};
int mod = 1000000007;
int n;

int main(){
	int x;
	read(n);
	for (x = 2; x < n; ++x){
		a[x] = (a[x - 2] + a[x - 1]) % mod;
	}
	write(a[n - 1]);
}