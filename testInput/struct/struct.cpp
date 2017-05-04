struct a{
	int x;
	int y;
};

struct b{
	int a;
	int x;
} c;

struct {
	int w;
} d;

int l;

int main(){
	struct e {
		int a;
	} w;
	struct f {
		int e;
	} g;
	struct {
		int h;
	}h;
	struct a x;
	struct b y;
	struct e z;

	c.a = 1;
	c.x = 2;
	d.w = 3;
	g.e = 4;
	h.h = 5;
	x.x = 6;
	x.y = 7;
	y.a = 8;
	y.x = 9;
	z.a = 10;
	write(c.a);
	write(c.x);
	write(d.w);
	write(g.e);
	write(h.h);
	write(x.x);
	write(x.y);
	write(y.a);
	write(y.x);
	write(z.a);
}