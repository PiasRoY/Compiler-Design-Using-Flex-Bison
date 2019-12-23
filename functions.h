#define MX_NODE 100000
#define alphabet_size 62

int root, nnode, var_no;
int isWord[MX_NODE];
int node[MX_NODE][alphabet_size];

void initialize()
{
	root = 0;
	nnode = 0;
	var_no = 0;
	for(int i = 0; i < alphabet_size; i++)
		node[root][i] = -1;
}

int insert(char *s)
{
	int now, len, index;

	len = strlen(s);
	now = root;

	for(int i = 0; i < len; i++) { 
		if(s[i] >= 'a' && s[i] <= 'z') index = s[i]-'a';
		else if(s[i] >= 'A' && s[i] <= 'Z') index = s[i]-'A'+26;
		else if(s[i] >= '0' && s[i] <= '9') index = s[i]-'0'+52;

		if(node[now][index] == -1) {
			node[now][index] = ++nnode;
			for(int j = 0; j < alphabet_size; j++)
				node[nnode][j] = -1;
		}
		now = node[now][index];
	}

	isWord[now] = var_no++;
	return isWord[now];
}

int query(char *s)
{
	int now, len, index;

	len = strlen(s);
	now = root;

	for(int i = 0; i < len; i++) {
		if(s[i] >= 'a' && s[i] <= 'z') index = s[i]-'a';
		else if(s[i] >= 'A' && s[i] <= 'Z') index = s[i]-'A'+26;
		else if(s[i] >= '0' && s[i] <= '9') index = s[i]-'0'+52;

		if(node[now][index] == -1) return -1;
		now = node[now][index];
	}
	
	return isWord[now];
}

