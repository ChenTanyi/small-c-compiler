int gcd(int a, int b){
	if (!b)
		return a;
	return gcd(b, a % b);
}

int main(){
	int a, b;
	read(a);
	read(b);
	write(gcd(a, b));
}