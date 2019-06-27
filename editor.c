#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

#define BUF_SIZE 256
#define MAX_LINE_NUMBER 256
#define MAX_LINE_LENGTH 256
#define MAX_ROLLBAKC_STEP 20
#define NULL 0

// define some color variables	>> By Shaun Fong
#define NONE                 "\e[0m"
#define BLACK                "\e[0;30m"
#define L_BLACK              "\e[1;30m"
#define RED                  "\e[0;31m"
#define L_RED                "\e[1;31m"
#define GREEN                "\e[0;32m"
#define L_GREEN              "\e[1;32m"
#define YELLOW               "\e[0;33m"
#define L_YELLOW             "\e[1;33m"
#define BLUE                 "\e[0;34m"
#define L_BLUE               "\e[1;34m"
#define PURPLE               "\e[0;35m"
#define L_PURPLE             "\e[1;35m"
#define CYAN                 "\e[0;36m"
#define L_CYAN               "\e[1;36m"
#define GRAY                 "\e[0;37m"
#define WHITE                "\e[1;37m"

char* strcat_n(char* dest, char* src, int len);
int get_line_number(char *text[]);
void show_text(char *text[]);
void com_ins(char *text[], int n, char *extra, int flag);
void com_mod(char *text[], int n, char *extra, int flag);
void com_del(char *text[], int n, int flag);
void com_help(char *text[]);
void com_save(char *text[], char *path);
void com_exit(char *text[], char *path);
void com_create_new_file(char *text[], char *path);
void com_display_color_demo();
void com_init_file(char *text[], char *path);
void show_text_syntax_highlighting(char *text[]);
void com_rollback(char *text[], int n);
void record_command(char *command);
int stringtonumber(char* src);
void number2string(int num, char array[]);


//标记是否更改过
int changed = 0;
int auto_show = 1;
//存储当前最大的行号，从0开始。即若line_number == x，则从text[0]到text[x]可用
int line_number = 0;
// 记录命令，作为回滚的凭借
char *command_set[MAX_ROLLBAKC_STEP] = {};
int upper_bound = -1;

int main(int argc, char *argv[])
{
	int is_new_file = 0;

	if (argc == 1)
	{
		printf(1, ">>> \e[1;31mplease input the command as [editor file_name]\n\e[0m");
		exit();
	}

	//存放文件内容
	char *text[MAX_LINE_NUMBER] = {};
	text[0] = malloc(MAX_LINE_LENGTH);
	memset(text[0], 0, MAX_LINE_LENGTH);
	
	//尝试打开文件
	int fd = open(argv[1], O_RDONLY);
	//如果文件存在，则打开并读取里面的内容
	if (fd != -1)
	{
		//printf(1, ">>> \e[1;33mfile exist\n\e[0m");
		char buf[BUF_SIZE] = {};
		int len = 0;
		while ((len = read(fd, buf, BUF_SIZE)) > 0)
		{
			int i = 0;
			int next = 0;
			int is_full = 0;
			while (i < len)
			{
				//拷贝"\n"之前的内容
				for (i = next; i < len && buf[i] != '\n'; i++)
					;
				strcat_n(text[line_number], buf+next, i-next);
				//必要时新建一行
				if (i < len && buf[i] == '\n')
				{
					if (line_number >= MAX_LINE_NUMBER - 1)
						is_full = 1;
					else
					{
						line_number++;
						text[line_number] = malloc(MAX_LINE_LENGTH);
						memset(text[line_number], 0, MAX_LINE_LENGTH);
					}
				}
				if (is_full == 1 || i >= len - 1)
					break;
				else
					next = i + 1;
			}
			if (is_full == 1)
				break;
		}
		close(fd);
	} 
	else{
		com_create_new_file(text, argv[1]);
		is_new_file = 1;
	}
	
	//输出文件内容,不是新建空文件时才输出
	if(!is_new_file && auto_show){
		show_text_syntax_highlighting(text);
	}
	//输出帮助
	//com_help(text);
	
	//处理命令
	char input[MAX_LINE_LENGTH] = {};
	while (1)
	{
		//printf(1, ">>> \e[1;33mplease input command:\n\e[0m");
		printf(1, ">>> \e[1;33m\e[0m");
		memset(input, 0, MAX_LINE_LENGTH);
		gets(input, MAX_LINE_LENGTH);
		int len = strlen(input);
		input[len-1] = '\0';
		len --;
		//寻找命令中第一个空格
		int pos = MAX_LINE_LENGTH - 1;
		int j = 0;
		for (; j < 8; j++)
		{
			if (input[j] == ' ')
			{
				pos = j + 1;
				break;
			}
		}
		//ins
		if (input[0] == 'i' && input[1] == 'n' && input[2] == 's')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
			{
				com_ins(text, stringtonumber(&input[4]), &input[pos], 1);
                                 //插入操作需要更新行号
				line_number = get_line_number(text);
			}
			else if(input[3] == ' '||input[3] == '\0')
			{
				com_ins(text, line_number+1+1, &input[pos], 1);
                                line_number = get_line_number(text);
			}
			else
			{
				//printf(1, ">>> \033[1m\e[43;31minvalid command.\e[0m\n");
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
				//com_help(text);
			}
		}
		//mod
		else if (input[0] == 'm' && input[1] == 'o' && input[2] == 'd')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
				com_mod(text, atoi(&input[4]), &input[pos], 1);
			else if(input[3] == ' '||input[3] == '\0')
				com_mod(text, line_number + 1, &input[pos], 1);
			else
			{
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
				//com_help(text);
			}
		}
		//del
		else if (input[0] == 'd' && input[1] == 'e' && input[2] == 'l')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
			{
				com_del(text, stringtonumber(&input[4]), 1);
                                //删除操作需要更新行号
				line_number = get_line_number(text);
			}	
			else if(input[3]=='\0')
			{
				com_del(text, line_number + 1, 1);
				line_number = get_line_number(text);
			}
			else
			{
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
				//com_help(text);
			}
			
		}
		else if (strcmp(input, "show") == 0)
		{
			auto_show = 1;
			printf(1, ">>> \e[1;33menable show current contents after text changed.\n\e[0m");
		}
		else if (strcmp(input, "hide") == 0)
		{
			auto_show = 0;
			printf(1, ">>> \e[1;33mdisable show current contents after text changed.\n\e[0m");
		}
		// rollback
		else if(strcmp(input, "rb") == 0){
			com_rollback(text, 1);
		}
		else if (strcmp(input, "help") == 0)
			com_help(text);
		// save
		else if (strcmp(input, "save") == 0 || strcmp(input, "CTRL+S\n") == 0)
			com_save(text, argv[1]);
		else if (strcmp(input, "exit") == 0)
			com_exit(text, argv[1]);
		else if (strcmp(input, "demo") == 0)
			com_display_color_demo();
		else if (strcmp(input, "init") == 0)
			com_init_file(text, argv[1]);
		else if(strcmp(input, "disp") == 0){
			show_text_syntax_highlighting(text);
		}
		else if(strcmp(input, "normaldisp") == 0){
			show_text(text);
		}
		else
		{
			printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
			//com_help(text);
		}
	}
	//setProgramStatus(SHELL);
	
	exit();
}

//拼接src的前n个字符到dest
char* strcat_n(char* dest, char* src, int len)
{
	if (len <= 0)
		return dest;
	int pos = strlen(dest);
	if (len + pos >= MAX_LINE_LENGTH)
		return dest;
	int i = 0;
	for (; i < len; i++)
		dest[i+pos] = src[i];
	dest[len+pos] = '\0';
	return dest;
}

void show_text(char *text[])
{
	printf(1, ">>> \033[1m\e[45;33mthe contents of the file are:\e[0m\n");
	printf(1, "\n");
	int j = 0;
	for (; text[j] != NULL; j++)
		if(strcmp(text[j], "\n") == 0){
			printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m\n", (j+1)/100, ((j+1)%100)/10, (j+1)%10);
		}
		else{
			printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m%s\n", (j+1)/100, ((j+1)%100)/10, (j+1)%10, text[j]);
		}
	printf(1, "\n");
}

//获取当前最大的行号，从0开始，即return x表示text[0]到text[x]可用
int get_line_number(char *text[])
{
	int i = 0;
	for (; i < MAX_LINE_NUMBER; i++)
		if (text[i] == NULL)
			return i - 1;
	return i - 1;
}

int stringtonumber(char* src)
{
	int number = 0; 
	int i=0;
	int pos = strlen(src);
	for(;i<pos;i++)
	{
		if(src[i]==' ') break;
		if(src[i]>57||src[i]<48) return -1;
		number=10*number+(src[i]-48);
	}
	return number;
}

void number2string(int num, char array[]) {
	char array_rvs[20] = {};
	int i, sign;
	if ((sign = num)<0)	// record the sign
		num = -num;		// make num into positive number
	i = 0;
	do {
		array_rvs[i++] = num % 10 + '0';	// fatch the next number
	} while ((num /= 10)>0);				// delete this number 
	if (sign<0)
		array_rvs[i++] = '-';
	array_rvs[i] = '\0';
	int length = strlen(array_rvs);
	for (int j = 0; j < length; j++) {
		array[j] = array_rvs[length - 1 - j];
	}
	array[length] = '\0';
}

//插入命令，n为用户输入的行号，从1开始
//extra:输入命令时接着的信息，代表待插入的文本
void com_ins(char *text[], int n, char *extra, int flag)
{
	if (n <= 0 || n > get_line_number(text) + 1 + 1)
	{
		printf(1, ">>> \033[1m\e[41;33minvalid line number\e[0m\n");
		return;
	}
	char input[MAX_LINE_LENGTH] = {};
	if (*extra == '\0')
	{
		printf(1, "... \e[1;35minput content:\e[0m");
		gets(input, MAX_LINE_LENGTH);
		input[strlen(input)-1] = '\0';
	}
	else
		strcpy(input, extra);
	
	char *part4 = malloc(MAX_LINE_LENGTH); 
	if(flag){
		strcpy(part4, text[n-1]);
	}

	int i = MAX_LINE_NUMBER - 1;
	for (; i > n-1; i--)
	{
		if (text[i-1] == NULL)
			continue;
		else if (text[i] == NULL && text[i-1] != NULL)
		{
			text[i] = malloc(MAX_LINE_LENGTH);
			memset(text[i], 0, MAX_LINE_LENGTH);
			strcpy(text[i], text[i-1]);
		}
		else if (text[i] != NULL && text[i-1] != NULL)
		{
			memset(text[i], 0, MAX_LINE_LENGTH);
			strcpy(text[i], text[i-1]);
		}
	}
	// couldn't understand what this code block means
	// maybe it allocates space for text[n-1] to avoid none space of text[n-1]
	if (text[n-1] == NULL)
	{
		text[n-1] = malloc(MAX_LINE_LENGTH);
		if (text[n-2][0] == '\0')
		{
			memset(text[n-1], 0, MAX_LINE_LENGTH);
			strcpy(text[n-2], input);
			changed = 1;
			if (auto_show == 1)
				show_text_syntax_highlighting(text);
			return;
		}
	}
	memset(text[n-1], 0, MAX_LINE_LENGTH);
	strcpy(text[n-1], input);
	changed = 1;
	
	if(flag){ // 非rollback的调用时才记录命令
		// record the command into command_set
		char *command = malloc(MAX_LINE_LENGTH);
		char part1[] = "ins-";
		char part2[10]; 
		number2string(n, part2);
		char part3[] = " \0";
		strcat_n(part1, part2, strlen(part2));
		strcat_n(part1, part3, strlen(part3));
		strcat_n(part1, part4, strlen(part4));
		strcpy(command, part1);
		record_command(command);
	}

	if (auto_show == 1)
		show_text_syntax_highlighting(text);
}

//修改命令，n为用户输入的行号，从1开始
//extra:输入命令时接着的信息，代表待修改成的文本
void com_mod(char *text[], int n, char *extra, int flag)
{
	if (n <= 0 || n > get_line_number(text) + 1)
	{
		printf(1, ">>> \033[1m\e[41;33minvalid line number\e[0m\n");
		return;
	}
	char input[MAX_LINE_LENGTH] = {};
	if (*extra == '\0')
	{
		printf(1, "... \e[1;35minput content:\e[0m");
		gets(input, MAX_LINE_LENGTH);
		input[strlen(input)-1] = '\0';
	}
	else
		strcpy(input, extra);

	char *part4 = malloc(MAX_LINE_LENGTH); 
	if(flag){
		strcpy(part4, text[n-1]);
	}

	memset(text[n-1], 0, MAX_LINE_LENGTH);
	strcpy(text[n-1], input);
	changed = 1;

	if(flag){ // 非rollback调用才记录
		// record the command into command_set
		char *command = malloc(MAX_LINE_LENGTH);
		char part1[] = "mod-";
		char part2[10]; 
		number2string(n, part2);
		char part3[] = " \0";
		strcat_n(part1, part2, strlen(part2));
		strcat_n(part1, part3, strlen(part3));
		strcat_n(part1, part4, strlen(part4));
		strcpy(command, part1);
		record_command(command);
	}

	if (auto_show == 1)
		show_text_syntax_highlighting(text);
}

//删除命令，n为用户输入的行号，从1开始
void com_del(char *text[], int n, int flag)
{
	if (n <= 0 || n > get_line_number(text) + 1)
	{
		//printf(1, "n: %d\n", n);
		printf(1, ">>> \033[1m\e[41;33minvalid line number\e[0m\n");
		return;
	}

	char *part4 = malloc(MAX_LINE_LENGTH); 
	if(flag){
		strcpy(part4, text[n-1]);
	}

	memset(text[n-1], 0, MAX_LINE_LENGTH);
	int i = n - 1;
	for (; text[i+1] != NULL; i++)
	{
		strcpy(text[i], text[i+1]);
		memset(text[i+1], 0, MAX_LINE_LENGTH);
	}
	if (i != 0)
	{
		free(text[i]);
		text[i] = 0;
	}
	changed = 1;

	// 有bug，实在解决不了，所以del不提供撤回功能
	if(0){ // 非rollback调用才记录
		char part1[] = "del-";
		char part2[10]; 
		number2string(n, part2);
		char part3[] = " \0";
		strcat_n(part1, part2, strlen(part2));
		strcat_n(part1, part3, strlen(part3));
		// 没有part5做中介，会优化出bug，还不是很懂
		char* part5 = malloc(MAX_LINE_LENGTH);
		memset(part5, 0, MAX_LINE_LENGTH);
		strcat_n(part5, part1, strlen(part1));
		strcat_n(part5, part4, strlen(part4));
		record_command(part5);
	}

	if (auto_show == 1)
		show_text_syntax_highlighting(text);
}

void com_save(char *text[], char *path)
{
	//删除旧有文件
	unlink(path);
	//新建文件并打开
	int fd = open(path, O_WRONLY|O_CREATE);
	if (fd == -1)
	{
		printf(1, ">>> \033[1m\e[41;33msave failed, file can't open:\e[0m\n");
		//setProgramStatus(SHELL);
		exit();
	}
	if (text[0] == NULL)
	{
		close(fd);
		return;
	}
	//写数据
	write(fd, text[0], strlen(text[0]));
	int i = 1;
	for (; text[i] != NULL; i++)
	{
		printf(fd, "\n");
		write(fd, text[i], strlen(text[i]));
	}
	close(fd);
	printf(1, ">>> \e[1;32msaved successfully\e[0m\n");
	changed = 0;
	return;
}

void com_exit(char *text[], char *path)
{
	//询问是否保存
	while (changed == 1)
	{
		printf(1, ">>> \e[1;33msave the file?\e[0m \033[1m\e[46;33my\e[0m/\033[1m\e[41;33mn\e[0m\n");
		char input[MAX_LINE_LENGTH] = {};
		gets(input, MAX_LINE_LENGTH);
		input[strlen(input)-1] = '\0';
		if (strcmp(input, "y") == 0)
			com_save(text, path);
		else if(strcmp(input, "n") == 0)
			break;
		else
		printf(2, ">>> \e[1;31mwrong answer?\e[0m\n");
	}
	//释放内存
	int i = 0;
	for (; text[i] != NULL; i++)
	{
		free(text[i]);
		text[i] = 0;
	}
	//退出
	//setProgramStatus(SHELL);
	exit();
}

// create new file
void com_create_new_file(char *text[], char *path){
	int fd = open(path, O_WRONLY|O_CREATE);
	if(fd == -1){
		printf(1, ">>> \e[1;31mcreate file failed\e[0m\n");
		exit();
	}
}

// 输出颜色demo
void com_display_color_demo(){
	printf(1, ">>> \e[1;33mcolor demo:\n\e[0m");
	printf(1, "----------------+-------------------------------+-----------------------\n");
	printf(1, "L_BLACK: 	| \e[1;30mI am happy Shaun Fong.\e[0m	|	\e[1;30m\\e[1;30m\e[0m\n");
	printf(1, "BLACK: 		| \e[0;30mI am happy Shaun Fong.\e[0m	|	\e[0;30m\\e[0;30m\e[0m\n");
	printf(1, "RED: 		| \e[0;31mI am happy Shaun Fong.\e[0m	|	\e[0;31m\\e[0;31m\e[0m\n");
	printf(1, "L_RED: 		| \e[1;31mI am happy Shaun Fong.\e[0m	|	\e[1;31m\\e[1;31m\e[0m\n");
	printf(1, "GREEN: 		| \e[0;32mI am happy Shaun Fong.\e[0m	|	\e[0;32m\\e[0;32m\e[0m\n");
	printf(1, "L_GREEN: 	| \e[1;32mI am happy Shaun Fong.\e[0m	|	\e[1;32m\\e[1;32m\e[0m\n");
	printf(1, "YELLOW:		| \e[0;33mI am happy Shaun Fong. \e[0m	|	\e[0;33m\\e[0;33m\e[0m\n");
	printf(1, "L_YELLOW:	| \e[1;33mI am happy Shaun Fong. \e[0m	|	\e[1;33m\\e[1;33m\e[0m\n");
	printf(1, "BLUE: 		| \e[0;34mI am happy Shaun Fong. \e[0m	|	\e[0;34m\\e[0;34m\e[0m\n");
	printf(1, "L_BLUE:		| \e[1;34mI am happy Shaun Fong. \e[0m	|	\e[1;34m\\e[1;34m\e[0m\n");
	printf(1, "PURPLE:		| \e[0;35mI am happy Shaun Fong. \e[0m	|	\e[0;35m\\e[0;35m\e[0m\n");
	printf(1, "L_PURPLE: 	| \e[1;35mI am happy Shaun Fong. \e[0m	|	\e[1;35m\\e[1;35m\e[0m\n");
	printf(1, "CYAN: 		| \e[0;36mI am happy Shaun Fong. \e[0m	|	\e[0;36m\\e[0;36m\e[0m\n");
	printf(1, "L_CYAN:		| \e[1;36mI am happy Shaun Fong. \e[0m	|	\e[1;36m\\e[1;36m\e[0m\n");
	printf(1, "GRAY: 		| \e[0;37mI am happy Shaun Fong. \e[0m	|	\e[0;37m\\e[0;37m\e[0m\n");
	printf(1, "WHITE: 		| \e[1;37mI am happy Shaun Fong. \e[0m	|	\e[1;37m\\e[1;37m\e[0m\n");
	printf(1, "----------------+-------------------------------+-----------------------\n");
}

void com_help(char *text[])
{
	printf(1, ">>> \e[1;33minstructions for use:\n\e[0m");
	printf(1, "--------+--------------------------------------------------------------\n");
	printf(1, "\e[1;32mins-n:\e[0m 	| insert a line after line n\n");
	printf(1, "\e[1;32mmod-n:\e[0m 	| modify line n\n");
	printf(1, "\e[1;32mdel-n:\e[0m 	| delete line n\n");
	printf(1, "\e[1;32mins:\e[0m 	| insert a line after the last line\n");
	printf(1, "\e[1;32mmod:\e[0m 	| modify the last line\n");
	printf(1, "\e[1;32mdel:\e[0m 	| delete the last line\n");
	printf(1, "\e[1;32mshow:\e[0m 	| enable show current contents after executing a command.\n");
	printf(1, "\e[1;32mhide:\e[0m 	| disable show current contents after executing a command.\n");
	printf(1, "\e[1;32msave:\e[0m 	| save the file\n");
	printf(1, "\e[1;32mexit:\e[0m 	| exit editor\n");
	printf(1, "\e[1;32mhelp:\e[0m	| help info\n");
	printf(1, "\e[1;32mdemo:\e[0m	| color demo\n");
	printf(1, "\e[1;32minit:\e[0m	| initial file\n");
	printf(1, "\e[1;32mdisp:\e[0m	| display with highlighting\n");
	printf(1, "\e[1;32mrb:\e[0m	| rollback the file\n");
	printf(1, "--------+--------------------------------------------------------------\n");
}

// 预留数据
void com_init_file(char *text[], char *path){
	char *buf[MAX_LINE_NUMBER] = {};
	for(int i = 0; i < MAX_LINE_NUMBER; i++){
		buf[i] = malloc(MAX_LINE_LENGTH);
	}
	strcpy(buf[0], "// Create a NULL-terminated string by reading the provided file");
	strcpy(buf[1], "static char* readShaderSource(const char* shaderFile)");
	strcpy(buf[2], "{");
	strcpy(buf[3], "	int flag = 24;");
	strcpy(buf[4], "	double ways = 100.43;");
	strcpy(buf[5], "	if ( fp == NULL ) {");
	strcpy(buf[6], "		return NULL;");
	strcpy(buf[7], "	}");
	strcpy(buf[8], "	fseek(fp, 0L, SEEK_END);	//search something");
	strcpy(buf[9], "	long size = ftell(fp);");
	strcpy(buf[10], "	fseek(fp, 0L, SEEK_SET);");
	strcpy(buf[11], "	char* buf = new char[size + 1];");
	strcpy(buf[12], "	memset(buf, 0, size + 1);	//Initiate every bit of buf as 0");
	strcpy(buf[13], "	fread(buf, 1, size, fp);");
	strcpy(buf[14], "	buf[size] = '\\0';");
	strcpy(buf[15], "	fclose(fp);			// close 'fp' stream.");
	strcpy(buf[16], "	return buf;");
	strcpy(buf[17], "	while (flag != 0){");
	strcpy(buf[18], "		ways = ways + ways * 12;");
	strcpy(buf[19], "	}");
	strcpy(buf[20], "	for (int a = 10; a >= 0; a--){");
	strcpy(buf[21], "		float tmp_value = 20.5;");
	strcpy(buf[22], "		printf(\"the real value of variable tmp_value is:%f\", tmp_value);");
	strcpy(buf[23], "		continue;");
	strcpy(buf[24], "	}");
	strcpy(buf[25], "}");
	strcpy(buf[26], "// demo | made by Shaun Fong");

	// 将数据覆盖进text的空间中
	for(int i = 0; i <= 26; i++){
		text[i] = malloc(MAX_LINE_LENGTH);
		strcpy(text[i], buf[i]);
	}

	line_number = get_line_number(text);

	show_text_syntax_highlighting(text);

	changed = 1;
}

// 语法高亮
void show_text_syntax_highlighting(char *text[]){
	printf(1, ">>> \033[1m\e[45;33mthe contents of the file are:\e[0m\n");
	printf(1, "\n");
	int j = 0;
	for (; text[j] != NULL; j++){
		printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m", (j+1)/100, ((j+1)%100)/10, (j+1)%10);
		
		// 寻找第一个非空字符
		int pos = 0;
		for(int a = 0; a < MAX_LINE_LENGTH; a++){
			if(text[j][a] != ' '){
				pos = a;
				break;
			}
		}

		if(strcmp(text[j], "\n") == 0){
			printf(1, "\n");
		}
		else if(text[j][pos] == '/' && text[j][pos+1] == '/'){
			printf(1, "\e[1;32m%s\n\e[0m", text[j]);
		}
		else{
			int mark = 0;
			int flag_annotation = 0;
			while(mark < MAX_LINE_LENGTH && text[j][mark] != NULL){
				// do something with 'mark' and print all the statements 
				// by the way of one letter by one letter
				// judge annotation
				if(flag_annotation){
					printf(1, "\e[1;32m%c\e[0m", text[j][mark++]);
					//mark++;
					continue;
				}

				// numbers
				if(text[j][mark] >= '0' && text[j][mark] <= '9'){
					printf(1, "\033[0;33m%c\033[0m", text[j][mark]);
					mark++;
				}
				// printf
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'p' && text[j][mark+1] == 'r' 
					&& text[j][mark+2] == 'i' && text[j][mark+3] == 'n' && text[j][mark+4] == 't' 
					&& text[j][mark+5] == 'f'){
					printf(1, "\e[1;36m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+4]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+5]);
					mark = mark + 6;
				}
				// int
				else if((mark+2)<MAX_LINE_LENGTH && text[j][mark] == 'i' && text[j][mark+1] == 'n' 
					&& text[j][mark+2] == 't'){
					// highlighting 'int' string
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					mark = mark + 3;
				}
				// float
				else if((mark+4)<MAX_LINE_LENGTH && text[j][mark] == 'f' && text[j][mark+1] == 'l' && text[j][mark+2] == 'o'
					&& text[j][mark+3] == 'a' && text[j][mark+4] == 't'){
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
					mark = mark + 5;
				}
				// double
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'd' && text[j][mark+1] == 'o' && text[j][mark+2] == 'u'
					&& text[j][mark+3] == 'b' && text[j][mark+4] == 'l' && text[j][mark+5] == 'e'){
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+5]);
					mark = mark + 6;
				}
				// char
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'c' && text[j][mark+1] == 'h' && text[j][mark+2] == 'a'
					&& text[j][mark+3] == 'r'){
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
					mark = mark + 4;
				}
				// if
				else if((mark+1)<MAX_LINE_LENGTH && text[j][mark] == 'i' && text[j][mark+1] == 'f'){
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
					mark = mark + 2;
				}
				// else
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'e' && text[j][mark+1] == 'l' && text[j][mark+2] == 's'
					&& text[j][mark+3] == 'e'){
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
					mark = mark + 4;
				}
				// else if
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'e' && text[j][mark+1] == 'l' && text[j][mark+2] == 's'
					&& text[j][mark+3] == 'e' && text[j][mark+4] == ' ' && text[j][mark+5] == 'i' && text[j][mark+6] == 'f'){
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+4]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+5]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+6]);
					mark = mark + 7;
				}
				// for
				else if((mark+2)<MAX_LINE_LENGTH && text[j][mark] == 'f' && text[j][mark+1] == 'o' && text[j][mark+2] == 'r'){
					// highlighting 'int' string
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
					mark = mark + 3;
				}
				// while
				else if((mark+4)<MAX_LINE_LENGTH && text[j][mark] == 'w' && text[j][mark+1] == 'h' && text[j][mark+2] == 'i'
					&& text[j][mark+3] == 'l' && text[j][mark+4] == 'e'){
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+4]);
					mark = mark + 5;
				}
				// long
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'l' && text[j][mark+1] == 'o' && text[j][mark+2] == 'n'
					&& text[j][mark+3] == 'g'){
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
					mark = mark + 4;
				}
				// {}[]()
				else if(text[j][mark] == '{' || text[j][mark] == '}' || text[j][mark] == '[' || text[j][mark] == ']'
					|| text[j][mark] == '(' || text[j][mark] == ')'){
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					mark++;
				}
				// static
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 's' && text[j][mark+1] == 't' && text[j][mark+2] == 'a'
					&& text[j][mark+3] == 't' && text[j][mark+4] == 'i' && text[j][mark+5] == 'c'){
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+5]);
					mark = mark + 6;
				}
				// const
				else if((mark+4)<MAX_LINE_LENGTH && text[j][mark] == 'c' && text[j][mark+1] == 'o' && text[j][mark+2] == 'n'
					&& text[j][mark+3] == 's' && text[j][mark+4] == 't'){
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
					mark = mark + 5;
				}
				// memset
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'm' && text[j][mark+1] == 'e' && text[j][mark+2] == 'm'
					&& text[j][mark+3] == 's' && text[j][mark+4] == 'e' && text[j][mark+5] == 't'){
					printf(1, "\e[1;36m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+4]);
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+5]);
					mark = mark + 6;
				}
				// //
				else if((mark+1)<MAX_LINE_LENGTH && text[j][mark] == '/' && text[j][mark] == '/'){
					printf(1, "\e[1;32m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;32m%c\e[0m", text[j][mark+1]);
					mark = mark + 2;
					flag_annotation = 1;
				}
				// NULL
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'N' && text[j][mark+1] == 'U' && text[j][mark+2] == 'L'
					&& text[j][mark+3] == 'L'){
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
					mark = mark + 4;
				}
				// character string
				else if(text[j][mark] == '"'){
					int tmp_pos = mark+1;
					int end = -1;
					while(tmp_pos < MAX_LINE_LENGTH){
						if(text[j][tmp_pos] == '"'){
							end = tmp_pos;
							break;
						}
						else{
							tmp_pos++;
						}
					}
					for(int inter = mark; inter <= end; inter++){
						printf(1, "\e[1;33m%c\e[0m", text[j][inter]);
					}
					mark = end + 1;
				}
				// single character
				else if(text[j][mark] == '\''){
					int tmp_pos = mark+1;
					int end = -1;
					while(tmp_pos < MAX_LINE_LENGTH){
						if(text[j][tmp_pos] == '\''){
							end = tmp_pos;
							break;
						}
						else{
							tmp_pos++;
						}
					}
					for(int inter = mark; inter <= end; inter++){
						printf(1, "\e[1;33m%c\e[0m", text[j][inter]);
					}
					mark = end + 1;
				}
				// continue
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'c' && text[j][mark+1] == 'o' && text[j][mark+2] == 'n'
					&& text[j][mark+3] == 't' && text[j][mark+4] == 'i' && text[j][mark+5] == 'n' && text[j][mark+6] == 'u'
					&& text[j][mark+7] == 'e'){
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+4]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+5]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+6]);
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+7]);
					mark = mark + 8;
				}
				// return
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'r' && text[j][mark+1] == 'e' && text[j][mark+2] == 't'
					&& text[j][mark+3] == 'u' && text[j][mark+4] == 'r' && text[j][mark+5] == 'n'){
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+5]);
					mark = mark + 6;
				}
				else{
					printf(1, "%c\e[0m", text[j][mark]);
					mark++;
				}
			}
			printf(1, "\n");
		}
	}
	printf(1, "\n");
}

void com_rollback(char *text[], int n){
	// rollback the command
	if(upper_bound < 0){
		printf(1, ">>> \033[1m\e[41;33mcouldn't rollback\e[0m\n");
		return;
	}

	char *input = malloc(MAX_LINE_LENGTH);
	strcpy(input, command_set[upper_bound]);
	upper_bound--;
	// searching the first space of command
	int pos = MAX_LINE_LENGTH - 1;
	int j = 0;
	for (; j < 10; j++)
	{
		if (input[j] == ' ')
		{
			pos = j + 1;
			break;
		}
	}
	// deal 'ins' command
	if (input[0] == 'i' && input[1] == 'n' && input[2] == 's')
	{
		// the line to be deleted
		int line = stringtonumber(&input[4]);
		com_del(text, line, 0);
		line_number = get_line_number(text);
	}
	// deal 'mod' command
	else if (input[0] == 'm' && input[1] == 'o' && input[2] == 'd')
	{
		// the line to be modified
		int line = stringtonumber(&input[4]);
		// the content of mod
		char *content = &input[pos];
		com_mod(text, line, content, 0);
		line_number = get_line_number(text);
	}
	// deal 'del' command
	else if (input[0] == 'd' && input[1] == 'e' && input[2] == 'l')
	{
		// the line to be deleted
		int line = stringtonumber(&input[4]);
		// the content of deletion
		char *content = &input[pos];
		com_ins(text, line, content, 0);
		line_number = get_line_number(text);
	}
}

void record_command(char *command){
	if((upper_bound+1) < MAX_ROLLBAKC_STEP){
		command_set[upper_bound+1] = malloc(MAX_LINE_LENGTH);
		strcpy(command_set[upper_bound+1], command);
		upper_bound++;
	}
	else{
		for(int i = 1; i < MAX_ROLLBAKC_STEP; i++){
			strcpy(command_set[i-1], command_set[i]);
		}
		strcpy(command_set[upper_bound], command);
		upper_bound = MAX_ROLLBAKC_STEP - 1;
	}
}