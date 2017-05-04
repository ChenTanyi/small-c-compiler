
int dp[10][13][2][2], digit[10];

int dfs(int len, int remain, int mask, int state, int fp)
{
    int ret, fpmax, i;
    if(!len){ 
    	if (remain == 0 && mask)
    		return 1;
        else 
        	return 0;
    }
    if(!fp && dp[len][remain][mask][state] != -1) 
        return dp[len][remain][mask][state];
    ret = 0;
    if (fp){
    	fpmax = digit[len];
    } else {
    	fpmax = 9;
    }
    for(i = 0; i <= fpmax; ++i){
        ret += dfs(len - 1, (remain * 10 + i) % 13, (mask || (state && i == 3)), i == 1, fp && i == fpmax);
    }
    if(!fp)
        dp[len][remain][mask][state] = ret;
    return ret;
}

int fun(int n)
{
    int len = 0;
    for(;n;){
        digit[++len] = n % 10; 
        n /= 10;
    }
    return dfs(len, 0, 0, 0, 1);
}

int main()
{
    int n, i, j, k, l;
    for (i = 0; i < 10; ++i){
    	for (j = 0; j < 13; ++j){
    		for (k = 0; k < 2; ++k){
    			for (l = 0; l < 2; ++l){
    				dp[i][j][k][l] = -1;
    			}
    		}
    	}
    }
    for(; ;){
    	read(n);
    	if (n <= -1)
    		break;
    	write(fun(n));
    }
    return 0;
}   