
_editor:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// 记录命令，作为回滚的凭借
char *command_set[MAX_ROLLBAKC_STEP] = {};
int upper_bound = -1;

int main(int argc, char *argv[])
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	57                   	push   %edi
       e:	56                   	push   %esi
       f:	53                   	push   %ebx
      10:	51                   	push   %ecx
      11:	81 ec 38 06 00 00    	sub    $0x638,%esp
      17:	89 cb                	mov    %ecx,%ebx
	int is_new_file = 0;
      19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	if (argc == 1)
      20:	83 3b 01             	cmpl   $0x1,(%ebx)
      23:	75 17                	jne    3c <main+0x3c>
	{
		printf(1, ">>> \e[1;31mplease input the command as [editor file_name]\n\e[0m");
      25:	83 ec 08             	sub    $0x8,%esp
      28:	68 5c 4b 00 00       	push   $0x4b5c
      2d:	6a 01                	push   $0x1
      2f:	e8 70 47 00 00       	call   47a4 <printf>
      34:	83 c4 10             	add    $0x10,%esp
		exit();
      37:	e8 f1 45 00 00       	call   462d <exit>
	}

	//存放文件内容
	char *text[MAX_LINE_NUMBER] = {};
      3c:	8d 95 c4 fb ff ff    	lea    -0x43c(%ebp),%edx
      42:	b8 00 00 00 00       	mov    $0x0,%eax
      47:	b9 00 01 00 00       	mov    $0x100,%ecx
      4c:	89 d7                	mov    %edx,%edi
      4e:	f3 ab                	rep stos %eax,%es:(%edi)
	text[0] = malloc(MAX_LINE_LENGTH);
      50:	83 ec 0c             	sub    $0xc,%esp
      53:	68 00 01 00 00       	push   $0x100
      58:	e8 1a 4a 00 00       	call   4a77 <malloc>
      5d:	83 c4 10             	add    $0x10,%esp
      60:	89 85 c4 fb ff ff    	mov    %eax,-0x43c(%ebp)
	memset(text[0], 0, MAX_LINE_LENGTH);
      66:	8b 85 c4 fb ff ff    	mov    -0x43c(%ebp),%eax
      6c:	83 ec 04             	sub    $0x4,%esp
      6f:	68 00 01 00 00       	push   $0x100
      74:	6a 00                	push   $0x0
      76:	50                   	push   %eax
      77:	e8 16 44 00 00       	call   4492 <memset>
      7c:	83 c4 10             	add    $0x10,%esp
	
	//尝试打开文件
	int fd = open(argv[1], O_RDONLY);
      7f:	8b 43 04             	mov    0x4(%ebx),%eax
      82:	83 c0 04             	add    $0x4,%eax
      85:	8b 00                	mov    (%eax),%eax
      87:	83 ec 08             	sub    $0x8,%esp
      8a:	6a 00                	push   $0x0
      8c:	50                   	push   %eax
      8d:	e8 db 45 00 00       	call   466d <open>
      92:	83 c4 10             	add    $0x10,%esp
      95:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//如果文件存在，则打开并读取里面的内容
	if (fd != -1)
      98:	83 7d cc ff          	cmpl   $0xffffffff,-0x34(%ebp)
      9c:	0f 84 6b 01 00 00    	je     20d <main+0x20d>
	{
		//printf(1, ">>> \e[1;33mfile exist\n\e[0m");
		char buf[BUF_SIZE] = {};
      a2:	8d 95 c4 f9 ff ff    	lea    -0x63c(%ebp),%edx
      a8:	b8 00 00 00 00       	mov    $0x0,%eax
      ad:	b9 40 00 00 00       	mov    $0x40,%ecx
      b2:	89 d7                	mov    %edx,%edi
      b4:	f3 ab                	rep stos %eax,%es:(%edi)
		int len = 0;
      b6:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
		while ((len = read(fd, buf, BUF_SIZE)) > 0)
      bd:	e9 11 01 00 00       	jmp    1d3 <main+0x1d3>
		{
			int i = 0;
      c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			int next = 0;
      c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			int is_full = 0;
      d0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			while (i < len)
      d7:	e9 e5 00 00 00       	jmp    1c1 <main+0x1c1>
			{
				//拷贝"\n"之前的内容
				for (i = next; i < len && buf[i] != '\n'; i++)
      dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
      df:	89 45 e0             	mov    %eax,-0x20(%ebp)
      e2:	eb 04                	jmp    e8 <main+0xe8>
      e4:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
      e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
      eb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
      ee:	7d 12                	jge    102 <main+0x102>
      f0:	8d 95 c4 f9 ff ff    	lea    -0x63c(%ebp),%edx
      f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
      f9:	01 d0                	add    %edx,%eax
      fb:	0f b6 00             	movzbl (%eax),%eax
      fe:	3c 0a                	cmp    $0xa,%al
     100:	75 e2                	jne    e4 <main+0xe4>
					;
				strcat_n(text[line_number], buf+next, i-next);
     102:	8b 45 e0             	mov    -0x20(%ebp),%eax
     105:	2b 45 dc             	sub    -0x24(%ebp),%eax
     108:	89 c2                	mov    %eax,%edx
     10a:	8b 45 dc             	mov    -0x24(%ebp),%eax
     10d:	8d 8d c4 f9 ff ff    	lea    -0x63c(%ebp),%ecx
     113:	01 c1                	add    %eax,%ecx
     115:	a1 84 5e 00 00       	mov    0x5e84,%eax
     11a:	8b 84 85 c4 fb ff ff 	mov    -0x43c(%ebp,%eax,4),%eax
     121:	83 ec 04             	sub    $0x4,%esp
     124:	52                   	push   %edx
     125:	51                   	push   %ecx
     126:	50                   	push   %eax
     127:	e8 04 07 00 00       	call   830 <strcat_n>
     12c:	83 c4 10             	add    $0x10,%esp
				//必要时新建一行
				if (i < len && buf[i] == '\n')
     12f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     132:	3b 45 c8             	cmp    -0x38(%ebp),%eax
     135:	7d 70                	jge    1a7 <main+0x1a7>
     137:	8d 95 c4 f9 ff ff    	lea    -0x63c(%ebp),%edx
     13d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     140:	01 d0                	add    %edx,%eax
     142:	0f b6 00             	movzbl (%eax),%eax
     145:	3c 0a                	cmp    $0xa,%al
     147:	75 5e                	jne    1a7 <main+0x1a7>
				{
					if (line_number >= MAX_LINE_NUMBER - 1)
     149:	a1 84 5e 00 00       	mov    0x5e84,%eax
     14e:	3d fe 00 00 00       	cmp    $0xfe,%eax
     153:	7e 09                	jle    15e <main+0x15e>
						is_full = 1;
     155:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
     15c:	eb 49                	jmp    1a7 <main+0x1a7>
					else
					{
						line_number++;
     15e:	a1 84 5e 00 00       	mov    0x5e84,%eax
     163:	83 c0 01             	add    $0x1,%eax
     166:	a3 84 5e 00 00       	mov    %eax,0x5e84
						text[line_number] = malloc(MAX_LINE_LENGTH);
     16b:	8b 35 84 5e 00 00    	mov    0x5e84,%esi
     171:	83 ec 0c             	sub    $0xc,%esp
     174:	68 00 01 00 00       	push   $0x100
     179:	e8 f9 48 00 00       	call   4a77 <malloc>
     17e:	83 c4 10             	add    $0x10,%esp
     181:	89 84 b5 c4 fb ff ff 	mov    %eax,-0x43c(%ebp,%esi,4)
						memset(text[line_number], 0, MAX_LINE_LENGTH);
     188:	a1 84 5e 00 00       	mov    0x5e84,%eax
     18d:	8b 84 85 c4 fb ff ff 	mov    -0x43c(%ebp,%eax,4),%eax
     194:	83 ec 04             	sub    $0x4,%esp
     197:	68 00 01 00 00       	push   $0x100
     19c:	6a 00                	push   $0x0
     19e:	50                   	push   %eax
     19f:	e8 ee 42 00 00       	call   4492 <memset>
     1a4:	83 c4 10             	add    $0x10,%esp
					}
				}
				if (is_full == 1 || i >= len - 1)
     1a7:	83 7d d8 01          	cmpl   $0x1,-0x28(%ebp)
     1ab:	74 20                	je     1cd <main+0x1cd>
     1ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
     1b0:	83 e8 01             	sub    $0x1,%eax
     1b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     1b6:	7e 15                	jle    1cd <main+0x1cd>
					break;
				else
					next = i + 1;
     1b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1bb:	83 c0 01             	add    $0x1,%eax
     1be:	89 45 dc             	mov    %eax,-0x24(%ebp)
		while ((len = read(fd, buf, BUF_SIZE)) > 0)
		{
			int i = 0;
			int next = 0;
			int is_full = 0;
			while (i < len)
     1c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1c4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
     1c7:	0f 8c 0f ff ff ff    	jl     dc <main+0xdc>
				if (is_full == 1 || i >= len - 1)
					break;
				else
					next = i + 1;
			}
			if (is_full == 1)
     1cd:	83 7d d8 01          	cmpl   $0x1,-0x28(%ebp)
     1d1:	74 29                	je     1fc <main+0x1fc>
	if (fd != -1)
	{
		//printf(1, ">>> \e[1;33mfile exist\n\e[0m");
		char buf[BUF_SIZE] = {};
		int len = 0;
		while ((len = read(fd, buf, BUF_SIZE)) > 0)
     1d3:	83 ec 04             	sub    $0x4,%esp
     1d6:	68 00 01 00 00       	push   $0x100
     1db:	8d 85 c4 f9 ff ff    	lea    -0x63c(%ebp),%eax
     1e1:	50                   	push   %eax
     1e2:	ff 75 cc             	pushl  -0x34(%ebp)
     1e5:	e8 5b 44 00 00       	call   4645 <read>
     1ea:	83 c4 10             	add    $0x10,%esp
     1ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
     1f0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
     1f4:	0f 8f c8 fe ff ff    	jg     c2 <main+0xc2>
     1fa:	eb 01                	jmp    1fd <main+0x1fd>
					break;
				else
					next = i + 1;
			}
			if (is_full == 1)
				break;
     1fc:	90                   	nop
		}
		close(fd);
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	ff 75 cc             	pushl  -0x34(%ebp)
     203:	e8 4d 44 00 00       	call   4655 <close>
     208:	83 c4 10             	add    $0x10,%esp
     20b:	eb 22                	jmp    22f <main+0x22f>
	} 
	else{
		com_create_new_file(text, argv[1]);
     20d:	8b 43 04             	mov    0x4(%ebx),%eax
     210:	83 c0 04             	add    $0x4,%eax
     213:	8b 00                	mov    (%eax),%eax
     215:	83 ec 08             	sub    $0x8,%esp
     218:	50                   	push   %eax
     219:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     21f:	50                   	push   %eax
     220:	e8 36 15 00 00       	call   175b <com_create_new_file>
     225:	83 c4 10             	add    $0x10,%esp
		is_new_file = 1;
     228:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	}
	
	//输出文件内容,不是新建空文件时才输出
	if(!is_new_file && auto_show){
     22f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     233:	75 1b                	jne    250 <main+0x250>
     235:	a1 5c 5e 00 00       	mov    0x5e5c,%eax
     23a:	85 c0                	test   %eax,%eax
     23c:	74 12                	je     250 <main+0x250>
		show_text_syntax_highlighting(text);
     23e:	83 ec 0c             	sub    $0xc,%esp
     241:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     247:	50                   	push   %eax
     248:	e8 44 1b 00 00       	call   1d91 <show_text_syntax_highlighting>
     24d:	83 c4 10             	add    $0x10,%esp
	}
	//输出帮助
	//com_help(text);
	
	//处理命令
	char input[MAX_LINE_LENGTH] = {};
     250:	8d 95 c4 fa ff ff    	lea    -0x53c(%ebp),%edx
     256:	b8 00 00 00 00       	mov    $0x0,%eax
     25b:	b9 40 00 00 00       	mov    $0x40,%ecx
     260:	89 d7                	mov    %edx,%edi
     262:	f3 ab                	rep stos %eax,%es:(%edi)
	while (1)
	{
		//printf(1, ">>> \e[1;33mplease input command:\n\e[0m");
		printf(1, ">>> \e[1;33m\e[0m");
     264:	83 ec 08             	sub    $0x8,%esp
     267:	68 9b 4b 00 00       	push   $0x4b9b
     26c:	6a 01                	push   $0x1
     26e:	e8 31 45 00 00       	call   47a4 <printf>
     273:	83 c4 10             	add    $0x10,%esp
		memset(input, 0, MAX_LINE_LENGTH);
     276:	83 ec 04             	sub    $0x4,%esp
     279:	68 00 01 00 00       	push   $0x100
     27e:	6a 00                	push   $0x0
     280:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     286:	50                   	push   %eax
     287:	e8 06 42 00 00       	call   4492 <memset>
     28c:	83 c4 10             	add    $0x10,%esp
		gets(input, MAX_LINE_LENGTH);
     28f:	83 ec 08             	sub    $0x8,%esp
     292:	68 00 01 00 00       	push   $0x100
     297:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     29d:	50                   	push   %eax
     29e:	e8 3c 42 00 00       	call   44df <gets>
     2a3:	83 c4 10             	add    $0x10,%esp
		int len = strlen(input);
     2a6:	83 ec 0c             	sub    $0xc,%esp
     2a9:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     2af:	50                   	push   %eax
     2b0:	e8 b6 41 00 00       	call   446b <strlen>
     2b5:	83 c4 10             	add    $0x10,%esp
     2b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		input[len-1] = '\0';
     2bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     2be:	83 e8 01             	sub    $0x1,%eax
     2c1:	c6 84 05 c4 fa ff ff 	movb   $0x0,-0x53c(%ebp,%eax,1)
     2c8:	00 
		len --;
     2c9:	83 6d c4 01          	subl   $0x1,-0x3c(%ebp)
		//寻找命令中第一个空格
		int pos = MAX_LINE_LENGTH - 1;
     2cd:	c7 45 d4 ff 00 00 00 	movl   $0xff,-0x2c(%ebp)
		int j = 0;
     2d4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (; j < 8; j++)
     2db:	eb 21                	jmp    2fe <main+0x2fe>
		{
			if (input[j] == ' ')
     2dd:	8d 95 c4 fa ff ff    	lea    -0x53c(%ebp),%edx
     2e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
     2e6:	01 d0                	add    %edx,%eax
     2e8:	0f b6 00             	movzbl (%eax),%eax
     2eb:	3c 20                	cmp    $0x20,%al
     2ed:	75 0b                	jne    2fa <main+0x2fa>
			{
				pos = j + 1;
     2ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
     2f2:	83 c0 01             	add    $0x1,%eax
     2f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				break;
     2f8:	eb 0a                	jmp    304 <main+0x304>
		input[len-1] = '\0';
		len --;
		//寻找命令中第一个空格
		int pos = MAX_LINE_LENGTH - 1;
		int j = 0;
		for (; j < 8; j++)
     2fa:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
     2fe:	83 7d d0 07          	cmpl   $0x7,-0x30(%ebp)
     302:	7e d9                	jle    2dd <main+0x2dd>
				pos = j + 1;
				break;
			}
		}
		//ins
		if (input[0] == 'i' && input[1] == 'n' && input[2] == 's')
     304:	0f b6 85 c4 fa ff ff 	movzbl -0x53c(%ebp),%eax
     30b:	3c 69                	cmp    $0x69,%al
     30d:	0f 85 00 01 00 00    	jne    413 <main+0x413>
     313:	0f b6 85 c5 fa ff ff 	movzbl -0x53b(%ebp),%eax
     31a:	3c 6e                	cmp    $0x6e,%al
     31c:	0f 85 f1 00 00 00    	jne    413 <main+0x413>
     322:	0f b6 85 c6 fa ff ff 	movzbl -0x53a(%ebp),%eax
     329:	3c 73                	cmp    $0x73,%al
     32b:	0f 85 e2 00 00 00    	jne    413 <main+0x413>
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     331:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     338:	3c 2d                	cmp    $0x2d,%al
     33a:	75 66                	jne    3a2 <main+0x3a2>
     33c:	83 ec 0c             	sub    $0xc,%esp
     33f:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     345:	83 c0 04             	add    $0x4,%eax
     348:	50                   	push   %eax
     349:	e8 71 07 00 00       	call   abf <stringtonumber>
     34e:	83 c4 10             	add    $0x10,%esp
     351:	85 c0                	test   %eax,%eax
     353:	78 4d                	js     3a2 <main+0x3a2>
			{
				com_ins(text, stringtonumber(&input[4]), &input[pos], 1);
     355:	8d 95 c4 fa ff ff    	lea    -0x53c(%ebp),%edx
     35b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     35e:	8d 34 02             	lea    (%edx,%eax,1),%esi
     361:	83 ec 0c             	sub    $0xc,%esp
     364:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     36a:	83 c0 04             	add    $0x4,%eax
     36d:	50                   	push   %eax
     36e:	e8 4c 07 00 00       	call   abf <stringtonumber>
     373:	83 c4 10             	add    $0x10,%esp
     376:	6a 01                	push   $0x1
     378:	56                   	push   %esi
     379:	50                   	push   %eax
     37a:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     380:	50                   	push   %eax
     381:	e8 d1 08 00 00       	call   c57 <com_ins>
     386:	83 c4 10             	add    $0x10,%esp
                                 //插入操作需要更新行号
				line_number = get_line_number(text);
     389:	83 ec 0c             	sub    $0xc,%esp
     38c:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     392:	50                   	push   %eax
     393:	e8 e6 06 00 00       	call   a7e <get_line_number>
     398:	83 c4 10             	add    $0x10,%esp
     39b:	a3 84 5e 00 00       	mov    %eax,0x5e84
     3a0:	eb 6c                	jmp    40e <main+0x40e>
			}
			else if(input[3] == ' '||input[3] == '\0')
     3a2:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     3a9:	3c 20                	cmp    $0x20,%al
     3ab:	74 0b                	je     3b8 <main+0x3b8>
     3ad:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     3b4:	84 c0                	test   %al,%al
     3b6:	75 3f                	jne    3f7 <main+0x3f7>
			{
				com_ins(text, line_number+1+1, &input[pos], 1);
     3b8:	8d 95 c4 fa ff ff    	lea    -0x53c(%ebp),%edx
     3be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     3c1:	01 c2                	add    %eax,%edx
     3c3:	a1 84 5e 00 00       	mov    0x5e84,%eax
     3c8:	83 c0 02             	add    $0x2,%eax
     3cb:	6a 01                	push   $0x1
     3cd:	52                   	push   %edx
     3ce:	50                   	push   %eax
     3cf:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     3d5:	50                   	push   %eax
     3d6:	e8 7c 08 00 00       	call   c57 <com_ins>
     3db:	83 c4 10             	add    $0x10,%esp
                                line_number = get_line_number(text);
     3de:	83 ec 0c             	sub    $0xc,%esp
     3e1:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     3e7:	50                   	push   %eax
     3e8:	e8 91 06 00 00       	call   a7e <get_line_number>
     3ed:	83 c4 10             	add    $0x10,%esp
     3f0:	a3 84 5e 00 00       	mov    %eax,0x5e84
     3f5:	eb 17                	jmp    40e <main+0x40e>
			}
			else
			{
				//printf(1, ">>> \033[1m\e[43;31minvalid command.\e[0m\n");
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
     3f7:	83 ec 08             	sub    $0x8,%esp
     3fa:	68 ac 4b 00 00       	push   $0x4bac
     3ff:	6a 01                	push   $0x1
     401:	e8 9e 43 00 00       	call   47a4 <printf>
     406:	83 c4 10             	add    $0x10,%esp
			}
		}
		//ins
		if (input[0] == 'i' && input[1] == 'n' && input[2] == 's')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     409:	e9 1d 04 00 00       	jmp    82b <main+0x82b>
     40e:	e9 18 04 00 00       	jmp    82b <main+0x82b>
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
				//com_help(text);
			}
		}
		//mod
		else if (input[0] == 'm' && input[1] == 'o' && input[2] == 'd')
     413:	0f b6 85 c4 fa ff ff 	movzbl -0x53c(%ebp),%eax
     41a:	3c 6d                	cmp    $0x6d,%al
     41c:	0f 85 d2 00 00 00    	jne    4f4 <main+0x4f4>
     422:	0f b6 85 c5 fa ff ff 	movzbl -0x53b(%ebp),%eax
     429:	3c 6f                	cmp    $0x6f,%al
     42b:	0f 85 c3 00 00 00    	jne    4f4 <main+0x4f4>
     431:	0f b6 85 c6 fa ff ff 	movzbl -0x53a(%ebp),%eax
     438:	3c 64                	cmp    $0x64,%al
     43a:	0f 85 b4 00 00 00    	jne    4f4 <main+0x4f4>
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     440:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     447:	3c 2d                	cmp    $0x2d,%al
     449:	75 4f                	jne    49a <main+0x49a>
     44b:	83 ec 0c             	sub    $0xc,%esp
     44e:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     454:	83 c0 04             	add    $0x4,%eax
     457:	50                   	push   %eax
     458:	e8 62 06 00 00       	call   abf <stringtonumber>
     45d:	83 c4 10             	add    $0x10,%esp
     460:	85 c0                	test   %eax,%eax
     462:	78 36                	js     49a <main+0x49a>
				com_mod(text, atoi(&input[4]), &input[pos], 1);
     464:	8d 95 c4 fa ff ff    	lea    -0x53c(%ebp),%edx
     46a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     46d:	8d 34 02             	lea    (%edx,%eax,1),%esi
     470:	83 ec 0c             	sub    $0xc,%esp
     473:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     479:	83 c0 04             	add    $0x4,%eax
     47c:	50                   	push   %eax
     47d:	e8 19 41 00 00       	call   459b <atoi>
     482:	83 c4 10             	add    $0x10,%esp
     485:	6a 01                	push   $0x1
     487:	56                   	push   %esi
     488:	50                   	push   %eax
     489:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     48f:	50                   	push   %eax
     490:	e8 89 0c 00 00       	call   111e <com_mod>
     495:	83 c4 10             	add    $0x10,%esp
     498:	eb 55                	jmp    4ef <main+0x4ef>
			else if(input[3] == ' '||input[3] == '\0')
     49a:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     4a1:	3c 20                	cmp    $0x20,%al
     4a3:	74 0b                	je     4b0 <main+0x4b0>
     4a5:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     4ac:	84 c0                	test   %al,%al
     4ae:	75 28                	jne    4d8 <main+0x4d8>
				com_mod(text, line_number + 1, &input[pos], 1);
     4b0:	8d 95 c4 fa ff ff    	lea    -0x53c(%ebp),%edx
     4b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     4b9:	01 c2                	add    %eax,%edx
     4bb:	a1 84 5e 00 00       	mov    0x5e84,%eax
     4c0:	83 c0 01             	add    $0x1,%eax
     4c3:	6a 01                	push   $0x1
     4c5:	52                   	push   %edx
     4c6:	50                   	push   %eax
     4c7:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     4cd:	50                   	push   %eax
     4ce:	e8 4b 0c 00 00       	call   111e <com_mod>
     4d3:	83 c4 10             	add    $0x10,%esp
     4d6:	eb 17                	jmp    4ef <main+0x4ef>
			else
			{
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
     4d8:	83 ec 08             	sub    $0x8,%esp
     4db:	68 ac 4b 00 00       	push   $0x4bac
     4e0:	6a 01                	push   $0x1
     4e2:	e8 bd 42 00 00       	call   47a4 <printf>
     4e7:	83 c4 10             	add    $0x10,%esp
			}
		}
		//mod
		else if (input[0] == 'm' && input[1] == 'o' && input[2] == 'd')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     4ea:	e9 3c 03 00 00       	jmp    82b <main+0x82b>
     4ef:	e9 37 03 00 00       	jmp    82b <main+0x82b>
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
				//com_help(text);
			}
		}
		//del
		else if (input[0] == 'd' && input[1] == 'e' && input[2] == 'l')
     4f4:	0f b6 85 c4 fa ff ff 	movzbl -0x53c(%ebp),%eax
     4fb:	3c 64                	cmp    $0x64,%al
     4fd:	0f 85 e3 00 00 00    	jne    5e6 <main+0x5e6>
     503:	0f b6 85 c5 fa ff ff 	movzbl -0x53b(%ebp),%eax
     50a:	3c 65                	cmp    $0x65,%al
     50c:	0f 85 d4 00 00 00    	jne    5e6 <main+0x5e6>
     512:	0f b6 85 c6 fa ff ff 	movzbl -0x53a(%ebp),%eax
     519:	3c 6c                	cmp    $0x6c,%al
     51b:	0f 85 c5 00 00 00    	jne    5e6 <main+0x5e6>
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     521:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     528:	3c 2d                	cmp    $0x2d,%al
     52a:	75 5f                	jne    58b <main+0x58b>
     52c:	83 ec 0c             	sub    $0xc,%esp
     52f:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     535:	83 c0 04             	add    $0x4,%eax
     538:	50                   	push   %eax
     539:	e8 81 05 00 00       	call   abf <stringtonumber>
     53e:	83 c4 10             	add    $0x10,%esp
     541:	85 c0                	test   %eax,%eax
     543:	78 46                	js     58b <main+0x58b>
			{
				com_del(text, stringtonumber(&input[4]), 1);
     545:	83 ec 0c             	sub    $0xc,%esp
     548:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     54e:	83 c0 04             	add    $0x4,%eax
     551:	50                   	push   %eax
     552:	e8 68 05 00 00       	call   abf <stringtonumber>
     557:	83 c4 10             	add    $0x10,%esp
     55a:	83 ec 04             	sub    $0x4,%esp
     55d:	6a 01                	push   $0x1
     55f:	50                   	push   %eax
     560:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     566:	50                   	push   %eax
     567:	e8 1b 0e 00 00       	call   1387 <com_del>
     56c:	83 c4 10             	add    $0x10,%esp
                                //删除操作需要更新行号
				line_number = get_line_number(text);
     56f:	83 ec 0c             	sub    $0xc,%esp
     572:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     578:	50                   	push   %eax
     579:	e8 00 05 00 00       	call   a7e <get_line_number>
     57e:	83 c4 10             	add    $0x10,%esp
     581:	a3 84 5e 00 00       	mov    %eax,0x5e84
			}
		}
		//del
		else if (input[0] == 'd' && input[1] == 'e' && input[2] == 'l')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     586:	e9 a0 02 00 00       	jmp    82b <main+0x82b>
			{
				com_del(text, stringtonumber(&input[4]), 1);
                                //删除操作需要更新行号
				line_number = get_line_number(text);
			}	
			else if(input[3]=='\0')
     58b:	0f b6 85 c7 fa ff ff 	movzbl -0x539(%ebp),%eax
     592:	84 c0                	test   %al,%al
     594:	75 39                	jne    5cf <main+0x5cf>
			{
				com_del(text, line_number + 1, 1);
     596:	a1 84 5e 00 00       	mov    0x5e84,%eax
     59b:	83 c0 01             	add    $0x1,%eax
     59e:	83 ec 04             	sub    $0x4,%esp
     5a1:	6a 01                	push   $0x1
     5a3:	50                   	push   %eax
     5a4:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     5aa:	50                   	push   %eax
     5ab:	e8 d7 0d 00 00       	call   1387 <com_del>
     5b0:	83 c4 10             	add    $0x10,%esp
				line_number = get_line_number(text);
     5b3:	83 ec 0c             	sub    $0xc,%esp
     5b6:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     5bc:	50                   	push   %eax
     5bd:	e8 bc 04 00 00       	call   a7e <get_line_number>
     5c2:	83 c4 10             	add    $0x10,%esp
     5c5:	a3 84 5e 00 00       	mov    %eax,0x5e84
			}
		}
		//del
		else if (input[0] == 'd' && input[1] == 'e' && input[2] == 'l')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     5ca:	e9 5c 02 00 00       	jmp    82b <main+0x82b>
				com_del(text, line_number + 1, 1);
				line_number = get_line_number(text);
			}
			else
			{
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
     5cf:	83 ec 08             	sub    $0x8,%esp
     5d2:	68 ac 4b 00 00       	push   $0x4bac
     5d7:	6a 01                	push   $0x1
     5d9:	e8 c6 41 00 00       	call   47a4 <printf>
     5de:	83 c4 10             	add    $0x10,%esp
			}
		}
		//del
		else if (input[0] == 'd' && input[1] == 'e' && input[2] == 'l')
		{
			if (input[3] == '-'&&stringtonumber(&input[4])>=0)
     5e1:	e9 45 02 00 00       	jmp    82b <main+0x82b>
				printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
				//com_help(text);
			}
			
		}
		else if (strcmp(input, "show") == 0)
     5e6:	83 ec 08             	sub    $0x8,%esp
     5e9:	68 d2 4b 00 00       	push   $0x4bd2
     5ee:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     5f4:	50                   	push   %eax
     5f5:	e8 32 3e 00 00       	call   442c <strcmp>
     5fa:	83 c4 10             	add    $0x10,%esp
     5fd:	85 c0                	test   %eax,%eax
     5ff:	75 21                	jne    622 <main+0x622>
		{
			auto_show = 1;
     601:	c7 05 5c 5e 00 00 01 	movl   $0x1,0x5e5c
     608:	00 00 00 
			printf(1, ">>> \e[1;33menable show current contents after text changed.\n\e[0m");
     60b:	83 ec 08             	sub    $0x8,%esp
     60e:	68 d8 4b 00 00       	push   $0x4bd8
     613:	6a 01                	push   $0x1
     615:	e8 8a 41 00 00       	call   47a4 <printf>
     61a:	83 c4 10             	add    $0x10,%esp
     61d:	e9 42 fc ff ff       	jmp    264 <main+0x264>
		}
		else if (strcmp(input, "hide") == 0)
     622:	83 ec 08             	sub    $0x8,%esp
     625:	68 19 4c 00 00       	push   $0x4c19
     62a:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     630:	50                   	push   %eax
     631:	e8 f6 3d 00 00       	call   442c <strcmp>
     636:	83 c4 10             	add    $0x10,%esp
     639:	85 c0                	test   %eax,%eax
     63b:	75 21                	jne    65e <main+0x65e>
		{
			auto_show = 0;
     63d:	c7 05 5c 5e 00 00 00 	movl   $0x0,0x5e5c
     644:	00 00 00 
			printf(1, ">>> \e[1;33mdisable show current contents after text changed.\n\e[0m");
     647:	83 ec 08             	sub    $0x8,%esp
     64a:	68 20 4c 00 00       	push   $0x4c20
     64f:	6a 01                	push   $0x1
     651:	e8 4e 41 00 00       	call   47a4 <printf>
     656:	83 c4 10             	add    $0x10,%esp
     659:	e9 06 fc ff ff       	jmp    264 <main+0x264>
		}
		// rollback
		else if(strcmp(input, "rb") == 0){
     65e:	83 ec 08             	sub    $0x8,%esp
     661:	68 62 4c 00 00       	push   $0x4c62
     666:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     66c:	50                   	push   %eax
     66d:	e8 ba 3d 00 00       	call   442c <strcmp>
     672:	83 c4 10             	add    $0x10,%esp
     675:	85 c0                	test   %eax,%eax
     677:	75 19                	jne    692 <main+0x692>
			com_rollback(text, 1);
     679:	83 ec 08             	sub    $0x8,%esp
     67c:	6a 01                	push   $0x1
     67e:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     684:	50                   	push   %eax
     685:	e8 b9 3a 00 00       	call   4143 <com_rollback>
     68a:	83 c4 10             	add    $0x10,%esp
     68d:	e9 d2 fb ff ff       	jmp    264 <main+0x264>
		}
		else if (strcmp(input, "help") == 0)
     692:	83 ec 08             	sub    $0x8,%esp
     695:	68 65 4c 00 00       	push   $0x4c65
     69a:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     6a0:	50                   	push   %eax
     6a1:	e8 86 3d 00 00       	call   442c <strcmp>
     6a6:	83 c4 10             	add    $0x10,%esp
     6a9:	85 c0                	test   %eax,%eax
     6ab:	75 17                	jne    6c4 <main+0x6c4>
			com_help(text);
     6ad:	83 ec 0c             	sub    $0xc,%esp
     6b0:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     6b6:	50                   	push   %eax
     6b7:	e8 3a 12 00 00       	call   18f6 <com_help>
     6bc:	83 c4 10             	add    $0x10,%esp
     6bf:	e9 a0 fb ff ff       	jmp    264 <main+0x264>
		// save
		else if (strcmp(input, "save") == 0 || strcmp(input, "CTRL+S\n") == 0)
     6c4:	83 ec 08             	sub    $0x8,%esp
     6c7:	68 6a 4c 00 00       	push   $0x4c6a
     6cc:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     6d2:	50                   	push   %eax
     6d3:	e8 54 3d 00 00       	call   442c <strcmp>
     6d8:	83 c4 10             	add    $0x10,%esp
     6db:	85 c0                	test   %eax,%eax
     6dd:	74 1b                	je     6fa <main+0x6fa>
     6df:	83 ec 08             	sub    $0x8,%esp
     6e2:	68 6f 4c 00 00       	push   $0x4c6f
     6e7:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     6ed:	50                   	push   %eax
     6ee:	e8 39 3d 00 00       	call   442c <strcmp>
     6f3:	83 c4 10             	add    $0x10,%esp
     6f6:	85 c0                	test   %eax,%eax
     6f8:	75 20                	jne    71a <main+0x71a>
			com_save(text, argv[1]);
     6fa:	8b 43 04             	mov    0x4(%ebx),%eax
     6fd:	83 c0 04             	add    $0x4,%eax
     700:	8b 00                	mov    (%eax),%eax
     702:	83 ec 08             	sub    $0x8,%esp
     705:	50                   	push   %eax
     706:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     70c:	50                   	push   %eax
     70d:	e8 ee 0d 00 00       	call   1500 <com_save>
     712:	83 c4 10             	add    $0x10,%esp
     715:	e9 11 01 00 00       	jmp    82b <main+0x82b>
		else if (strcmp(input, "exit") == 0)
     71a:	83 ec 08             	sub    $0x8,%esp
     71d:	68 77 4c 00 00       	push   $0x4c77
     722:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     728:	50                   	push   %eax
     729:	e8 fe 3c 00 00       	call   442c <strcmp>
     72e:	83 c4 10             	add    $0x10,%esp
     731:	85 c0                	test   %eax,%eax
     733:	75 20                	jne    755 <main+0x755>
			com_exit(text, argv[1]);
     735:	8b 43 04             	mov    0x4(%ebx),%eax
     738:	83 c0 04             	add    $0x4,%eax
     73b:	8b 00                	mov    (%eax),%eax
     73d:	83 ec 08             	sub    $0x8,%esp
     740:	50                   	push   %eax
     741:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     747:	50                   	push   %eax
     748:	e8 e0 0e 00 00       	call   162d <com_exit>
     74d:	83 c4 10             	add    $0x10,%esp
     750:	e9 0f fb ff ff       	jmp    264 <main+0x264>
		else if (strcmp(input, "demo") == 0)
     755:	83 ec 08             	sub    $0x8,%esp
     758:	68 7c 4c 00 00       	push   $0x4c7c
     75d:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     763:	50                   	push   %eax
     764:	e8 c3 3c 00 00       	call   442c <strcmp>
     769:	83 c4 10             	add    $0x10,%esp
     76c:	85 c0                	test   %eax,%eax
     76e:	75 0a                	jne    77a <main+0x77a>
			com_display_color_demo();
     770:	e8 22 10 00 00       	call   1797 <com_display_color_demo>
     775:	e9 ea fa ff ff       	jmp    264 <main+0x264>
		else if (strcmp(input, "init") == 0)
     77a:	83 ec 08             	sub    $0x8,%esp
     77d:	68 81 4c 00 00       	push   $0x4c81
     782:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     788:	50                   	push   %eax
     789:	e8 9e 3c 00 00       	call   442c <strcmp>
     78e:	83 c4 10             	add    $0x10,%esp
     791:	85 c0                	test   %eax,%eax
     793:	75 20                	jne    7b5 <main+0x7b5>
			com_init_file(text, argv[1]);
     795:	8b 43 04             	mov    0x4(%ebx),%eax
     798:	83 c0 04             	add    $0x4,%eax
     79b:	8b 00                	mov    (%eax),%eax
     79d:	83 ec 08             	sub    $0x8,%esp
     7a0:	50                   	push   %eax
     7a1:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     7a7:	50                   	push   %eax
     7a8:	e8 96 12 00 00       	call   1a43 <com_init_file>
     7ad:	83 c4 10             	add    $0x10,%esp
     7b0:	e9 af fa ff ff       	jmp    264 <main+0x264>
		else if(strcmp(input, "disp") == 0){
     7b5:	83 ec 08             	sub    $0x8,%esp
     7b8:	68 86 4c 00 00       	push   $0x4c86
     7bd:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     7c3:	50                   	push   %eax
     7c4:	e8 63 3c 00 00       	call   442c <strcmp>
     7c9:	83 c4 10             	add    $0x10,%esp
     7cc:	85 c0                	test   %eax,%eax
     7ce:	75 17                	jne    7e7 <main+0x7e7>
			show_text_syntax_highlighting(text);
     7d0:	83 ec 0c             	sub    $0xc,%esp
     7d3:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     7d9:	50                   	push   %eax
     7da:	e8 b2 15 00 00       	call   1d91 <show_text_syntax_highlighting>
     7df:	83 c4 10             	add    $0x10,%esp
     7e2:	e9 7d fa ff ff       	jmp    264 <main+0x264>
		}
		else if(strcmp(input, "normaldisp") == 0){
     7e7:	83 ec 08             	sub    $0x8,%esp
     7ea:	68 8b 4c 00 00       	push   $0x4c8b
     7ef:	8d 85 c4 fa ff ff    	lea    -0x53c(%ebp),%eax
     7f5:	50                   	push   %eax
     7f6:	e8 31 3c 00 00       	call   442c <strcmp>
     7fb:	83 c4 10             	add    $0x10,%esp
     7fe:	85 c0                	test   %eax,%eax
     800:	75 17                	jne    819 <main+0x819>
			show_text(text);
     802:	83 ec 0c             	sub    $0xc,%esp
     805:	8d 85 c4 fb ff ff    	lea    -0x43c(%ebp),%eax
     80b:	50                   	push   %eax
     80c:	e8 9d 00 00 00       	call   8ae <show_text>
     811:	83 c4 10             	add    $0x10,%esp
     814:	e9 4b fa ff ff       	jmp    264 <main+0x264>
		}
		else
		{
			printf(1, ">>> \033[1m\e[41;33minvalid command.\e[0m\n");
     819:	83 ec 08             	sub    $0x8,%esp
     81c:	68 ac 4b 00 00       	push   $0x4bac
     821:	6a 01                	push   $0x1
     823:	e8 7c 3f 00 00       	call   47a4 <printf>
     828:	83 c4 10             	add    $0x10,%esp
			//com_help(text);
		}
	}
     82b:	e9 34 fa ff ff       	jmp    264 <main+0x264>

00000830 <strcat_n>:
	exit();
}

//拼接src的前n个字符到dest
char* strcat_n(char* dest, char* src, int len)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	83 ec 18             	sub    $0x18,%esp
	if (len <= 0)
     836:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     83a:	7f 05                	jg     841 <strcat_n+0x11>
		return dest;
     83c:	8b 45 08             	mov    0x8(%ebp),%eax
     83f:	eb 6b                	jmp    8ac <strcat_n+0x7c>
	int pos = strlen(dest);
     841:	83 ec 0c             	sub    $0xc,%esp
     844:	ff 75 08             	pushl  0x8(%ebp)
     847:	e8 1f 3c 00 00       	call   446b <strlen>
     84c:	83 c4 10             	add    $0x10,%esp
     84f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (len + pos >= MAX_LINE_LENGTH)
     852:	8b 55 10             	mov    0x10(%ebp),%edx
     855:	8b 45 f0             	mov    -0x10(%ebp),%eax
     858:	01 d0                	add    %edx,%eax
     85a:	3d ff 00 00 00       	cmp    $0xff,%eax
     85f:	7e 05                	jle    866 <strcat_n+0x36>
		return dest;
     861:	8b 45 08             	mov    0x8(%ebp),%eax
     864:	eb 46                	jmp    8ac <strcat_n+0x7c>
	int i = 0;
     866:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; i < len; i++)
     86d:	eb 20                	jmp    88f <strcat_n+0x5f>
		dest[i+pos] = src[i];
     86f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     872:	8b 45 f0             	mov    -0x10(%ebp),%eax
     875:	01 d0                	add    %edx,%eax
     877:	89 c2                	mov    %eax,%edx
     879:	8b 45 08             	mov    0x8(%ebp),%eax
     87c:	01 c2                	add    %eax,%edx
     87e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     881:	8b 45 0c             	mov    0xc(%ebp),%eax
     884:	01 c8                	add    %ecx,%eax
     886:	0f b6 00             	movzbl (%eax),%eax
     889:	88 02                	mov    %al,(%edx)
		return dest;
	int pos = strlen(dest);
	if (len + pos >= MAX_LINE_LENGTH)
		return dest;
	int i = 0;
	for (; i < len; i++)
     88b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     892:	3b 45 10             	cmp    0x10(%ebp),%eax
     895:	7c d8                	jl     86f <strcat_n+0x3f>
		dest[i+pos] = src[i];
	dest[len+pos] = '\0';
     897:	8b 55 10             	mov    0x10(%ebp),%edx
     89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     89d:	01 d0                	add    %edx,%eax
     89f:	89 c2                	mov    %eax,%edx
     8a1:	8b 45 08             	mov    0x8(%ebp),%eax
     8a4:	01 d0                	add    %edx,%eax
     8a6:	c6 00 00             	movb   $0x0,(%eax)
	return dest;
     8a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     8ac:	c9                   	leave  
     8ad:	c3                   	ret    

000008ae <show_text>:

void show_text(char *text[])
{
     8ae:	55                   	push   %ebp
     8af:	89 e5                	mov    %esp,%ebp
     8b1:	57                   	push   %edi
     8b2:	56                   	push   %esi
     8b3:	53                   	push   %ebx
     8b4:	83 ec 1c             	sub    $0x1c,%esp
	printf(1, ">>> \033[1m\e[45;33mthe contents of the file are:\e[0m\n");
     8b7:	83 ec 08             	sub    $0x8,%esp
     8ba:	68 98 4c 00 00       	push   $0x4c98
     8bf:	6a 01                	push   $0x1
     8c1:	e8 de 3e 00 00       	call   47a4 <printf>
     8c6:	83 c4 10             	add    $0x10,%esp
	printf(1, "\n");
     8c9:	83 ec 08             	sub    $0x8,%esp
     8cc:	68 cb 4c 00 00       	push   $0x4ccb
     8d1:	6a 01                	push   $0x1
     8d3:	e8 cc 3e 00 00       	call   47a4 <printf>
     8d8:	83 c4 10             	add    $0x10,%esp
	int j = 0;
     8db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (; text[j] != NULL; j++)
     8e2:	e9 63 01 00 00       	jmp    a4a <show_text+0x19c>
		if(strcmp(text[j], "\n") == 0){
     8e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     8f1:	8b 45 08             	mov    0x8(%ebp),%eax
     8f4:	01 d0                	add    %edx,%eax
     8f6:	8b 00                	mov    (%eax),%eax
     8f8:	83 ec 08             	sub    $0x8,%esp
     8fb:	68 cb 4c 00 00       	push   $0x4ccb
     900:	50                   	push   %eax
     901:	e8 26 3b 00 00       	call   442c <strcmp>
     906:	83 c4 10             	add    $0x10,%esp
     909:	85 c0                	test   %eax,%eax
     90b:	0f 85 94 00 00 00    	jne    9a5 <show_text+0xf7>
			printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m\n", (j+1)/100, ((j+1)%100)/10, (j+1)%10);
     911:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     914:	8d 58 01             	lea    0x1(%eax),%ebx
     917:	ba 67 66 66 66       	mov    $0x66666667,%edx
     91c:	89 d8                	mov    %ebx,%eax
     91e:	f7 ea                	imul   %edx
     920:	c1 fa 02             	sar    $0x2,%edx
     923:	89 d8                	mov    %ebx,%eax
     925:	c1 f8 1f             	sar    $0x1f,%eax
     928:	89 d1                	mov    %edx,%ecx
     92a:	29 c1                	sub    %eax,%ecx
     92c:	89 c8                	mov    %ecx,%eax
     92e:	c1 e0 02             	shl    $0x2,%eax
     931:	01 c8                	add    %ecx,%eax
     933:	01 c0                	add    %eax,%eax
     935:	89 d9                	mov    %ebx,%ecx
     937:	29 c1                	sub    %eax,%ecx
     939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     93c:	8d 70 01             	lea    0x1(%eax),%esi
     93f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
     944:	89 f0                	mov    %esi,%eax
     946:	f7 ea                	imul   %edx
     948:	c1 fa 05             	sar    $0x5,%edx
     94b:	89 f0                	mov    %esi,%eax
     94d:	c1 f8 1f             	sar    $0x1f,%eax
     950:	89 d3                	mov    %edx,%ebx
     952:	29 c3                	sub    %eax,%ebx
     954:	6b c3 64             	imul   $0x64,%ebx,%eax
     957:	29 c6                	sub    %eax,%esi
     959:	89 f3                	mov    %esi,%ebx
     95b:	ba 67 66 66 66       	mov    $0x66666667,%edx
     960:	89 d8                	mov    %ebx,%eax
     962:	f7 ea                	imul   %edx
     964:	c1 fa 02             	sar    $0x2,%edx
     967:	89 d8                	mov    %ebx,%eax
     969:	c1 f8 1f             	sar    $0x1f,%eax
     96c:	89 d6                	mov    %edx,%esi
     96e:	29 c6                	sub    %eax,%esi
     970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     973:	8d 58 01             	lea    0x1(%eax),%ebx
     976:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
     97b:	89 d8                	mov    %ebx,%eax
     97d:	f7 ea                	imul   %edx
     97f:	c1 fa 05             	sar    $0x5,%edx
     982:	89 d8                	mov    %ebx,%eax
     984:	c1 f8 1f             	sar    $0x1f,%eax
     987:	29 c2                	sub    %eax,%edx
     989:	89 d0                	mov    %edx,%eax
     98b:	83 ec 0c             	sub    $0xc,%esp
     98e:	51                   	push   %ecx
     98f:	56                   	push   %esi
     990:	50                   	push   %eax
     991:	68 d0 4c 00 00       	push   $0x4cd0
     996:	6a 01                	push   $0x1
     998:	e8 07 3e 00 00       	call   47a4 <printf>
     99d:	83 c4 20             	add    $0x20,%esp
     9a0:	e9 a1 00 00 00       	jmp    a46 <show_text+0x198>
		}
		else{
			printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m%s\n", (j+1)/100, ((j+1)%100)/10, (j+1)%10, text[j]);
     9a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     9af:	8b 45 08             	mov    0x8(%ebp),%eax
     9b2:	01 d0                	add    %edx,%eax
     9b4:	8b 38                	mov    (%eax),%edi
     9b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9b9:	8d 58 01             	lea    0x1(%eax),%ebx
     9bc:	ba 67 66 66 66       	mov    $0x66666667,%edx
     9c1:	89 d8                	mov    %ebx,%eax
     9c3:	f7 ea                	imul   %edx
     9c5:	c1 fa 02             	sar    $0x2,%edx
     9c8:	89 d8                	mov    %ebx,%eax
     9ca:	c1 f8 1f             	sar    $0x1f,%eax
     9cd:	89 d1                	mov    %edx,%ecx
     9cf:	29 c1                	sub    %eax,%ecx
     9d1:	89 c8                	mov    %ecx,%eax
     9d3:	c1 e0 02             	shl    $0x2,%eax
     9d6:	01 c8                	add    %ecx,%eax
     9d8:	01 c0                	add    %eax,%eax
     9da:	89 d9                	mov    %ebx,%ecx
     9dc:	29 c1                	sub    %eax,%ecx
     9de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9e1:	8d 70 01             	lea    0x1(%eax),%esi
     9e4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
     9e9:	89 f0                	mov    %esi,%eax
     9eb:	f7 ea                	imul   %edx
     9ed:	c1 fa 05             	sar    $0x5,%edx
     9f0:	89 f0                	mov    %esi,%eax
     9f2:	c1 f8 1f             	sar    $0x1f,%eax
     9f5:	89 d3                	mov    %edx,%ebx
     9f7:	29 c3                	sub    %eax,%ebx
     9f9:	6b c3 64             	imul   $0x64,%ebx,%eax
     9fc:	29 c6                	sub    %eax,%esi
     9fe:	89 f3                	mov    %esi,%ebx
     a00:	ba 67 66 66 66       	mov    $0x66666667,%edx
     a05:	89 d8                	mov    %ebx,%eax
     a07:	f7 ea                	imul   %edx
     a09:	c1 fa 02             	sar    $0x2,%edx
     a0c:	89 d8                	mov    %ebx,%eax
     a0e:	c1 f8 1f             	sar    $0x1f,%eax
     a11:	89 d6                	mov    %edx,%esi
     a13:	29 c6                	sub    %eax,%esi
     a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a18:	8d 58 01             	lea    0x1(%eax),%ebx
     a1b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
     a20:	89 d8                	mov    %ebx,%eax
     a22:	f7 ea                	imul   %edx
     a24:	c1 fa 05             	sar    $0x5,%edx
     a27:	89 d8                	mov    %ebx,%eax
     a29:	c1 f8 1f             	sar    $0x1f,%eax
     a2c:	29 c2                	sub    %eax,%edx
     a2e:	89 d0                	mov    %edx,%eax
     a30:	83 ec 08             	sub    $0x8,%esp
     a33:	57                   	push   %edi
     a34:	51                   	push   %ecx
     a35:	56                   	push   %esi
     a36:	50                   	push   %eax
     a37:	68 f0 4c 00 00       	push   $0x4cf0
     a3c:	6a 01                	push   $0x1
     a3e:	e8 61 3d 00 00       	call   47a4 <printf>
     a43:	83 c4 20             	add    $0x20,%esp
void show_text(char *text[])
{
	printf(1, ">>> \033[1m\e[45;33mthe contents of the file are:\e[0m\n");
	printf(1, "\n");
	int j = 0;
	for (; text[j] != NULL; j++)
     a46:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
     a4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     a54:	8b 45 08             	mov    0x8(%ebp),%eax
     a57:	01 d0                	add    %edx,%eax
     a59:	8b 00                	mov    (%eax),%eax
     a5b:	85 c0                	test   %eax,%eax
     a5d:	0f 85 84 fe ff ff    	jne    8e7 <show_text+0x39>
			printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m\n", (j+1)/100, ((j+1)%100)/10, (j+1)%10);
		}
		else{
			printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m%s\n", (j+1)/100, ((j+1)%100)/10, (j+1)%10, text[j]);
		}
	printf(1, "\n");
     a63:	83 ec 08             	sub    $0x8,%esp
     a66:	68 cb 4c 00 00       	push   $0x4ccb
     a6b:	6a 01                	push   $0x1
     a6d:	e8 32 3d 00 00       	call   47a4 <printf>
     a72:	83 c4 10             	add    $0x10,%esp
}
     a75:	90                   	nop
     a76:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a79:	5b                   	pop    %ebx
     a7a:	5e                   	pop    %esi
     a7b:	5f                   	pop    %edi
     a7c:	5d                   	pop    %ebp
     a7d:	c3                   	ret    

00000a7e <get_line_number>:

//获取当前最大的行号，从0开始，即return x表示text[0]到text[x]可用
int get_line_number(char *text[])
{
     a7e:	55                   	push   %ebp
     a7f:	89 e5                	mov    %esp,%ebp
     a81:	83 ec 10             	sub    $0x10,%esp
	int i = 0;
     a84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (; i < MAX_LINE_NUMBER; i++)
     a8b:	eb 21                	jmp    aae <get_line_number+0x30>
		if (text[i] == NULL)
     a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     a97:	8b 45 08             	mov    0x8(%ebp),%eax
     a9a:	01 d0                	add    %edx,%eax
     a9c:	8b 00                	mov    (%eax),%eax
     a9e:	85 c0                	test   %eax,%eax
     aa0:	75 08                	jne    aaa <get_line_number+0x2c>
			return i - 1;
     aa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     aa5:	83 e8 01             	sub    $0x1,%eax
     aa8:	eb 13                	jmp    abd <get_line_number+0x3f>

//获取当前最大的行号，从0开始，即return x表示text[0]到text[x]可用
int get_line_number(char *text[])
{
	int i = 0;
	for (; i < MAX_LINE_NUMBER; i++)
     aaa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     aae:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
     ab5:	7e d6                	jle    a8d <get_line_number+0xf>
		if (text[i] == NULL)
			return i - 1;
	return i - 1;
     ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     aba:	83 e8 01             	sub    $0x1,%eax
}
     abd:	c9                   	leave  
     abe:	c3                   	ret    

00000abf <stringtonumber>:

int stringtonumber(char* src)
{
     abf:	55                   	push   %ebp
     ac0:	89 e5                	mov    %esp,%ebp
     ac2:	83 ec 18             	sub    $0x18,%esp
	int number = 0; 
     ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i=0;
     acc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int pos = strlen(src);
     ad3:	83 ec 0c             	sub    $0xc,%esp
     ad6:	ff 75 08             	pushl  0x8(%ebp)
     ad9:	e8 8d 39 00 00       	call   446b <strlen>
     ade:	83 c4 10             	add    $0x10,%esp
     ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for(;i<pos;i++)
     ae4:	eb 5c                	jmp    b42 <stringtonumber+0x83>
	{
		if(src[i]==' ') break;
     ae6:	8b 55 f0             	mov    -0x10(%ebp),%edx
     ae9:	8b 45 08             	mov    0x8(%ebp),%eax
     aec:	01 d0                	add    %edx,%eax
     aee:	0f b6 00             	movzbl (%eax),%eax
     af1:	3c 20                	cmp    $0x20,%al
     af3:	74 57                	je     b4c <stringtonumber+0x8d>
		if(src[i]>57||src[i]<48) return -1;
     af5:	8b 55 f0             	mov    -0x10(%ebp),%edx
     af8:	8b 45 08             	mov    0x8(%ebp),%eax
     afb:	01 d0                	add    %edx,%eax
     afd:	0f b6 00             	movzbl (%eax),%eax
     b00:	3c 39                	cmp    $0x39,%al
     b02:	7f 0f                	jg     b13 <stringtonumber+0x54>
     b04:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b07:	8b 45 08             	mov    0x8(%ebp),%eax
     b0a:	01 d0                	add    %edx,%eax
     b0c:	0f b6 00             	movzbl (%eax),%eax
     b0f:	3c 2f                	cmp    $0x2f,%al
     b11:	7f 07                	jg     b1a <stringtonumber+0x5b>
     b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     b18:	eb 36                	jmp    b50 <stringtonumber+0x91>
		number=10*number+(src[i]-48);
     b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b1d:	89 d0                	mov    %edx,%eax
     b1f:	c1 e0 02             	shl    $0x2,%eax
     b22:	01 d0                	add    %edx,%eax
     b24:	01 c0                	add    %eax,%eax
     b26:	89 c1                	mov    %eax,%ecx
     b28:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b2b:	8b 45 08             	mov    0x8(%ebp),%eax
     b2e:	01 d0                	add    %edx,%eax
     b30:	0f b6 00             	movzbl (%eax),%eax
     b33:	0f be c0             	movsbl %al,%eax
     b36:	83 e8 30             	sub    $0x30,%eax
     b39:	01 c8                	add    %ecx,%eax
     b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
int stringtonumber(char* src)
{
	int number = 0; 
	int i=0;
	int pos = strlen(src);
	for(;i<pos;i++)
     b3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     b48:	7c 9c                	jl     ae6 <stringtonumber+0x27>
     b4a:	eb 01                	jmp    b4d <stringtonumber+0x8e>
	{
		if(src[i]==' ') break;
     b4c:	90                   	nop
		if(src[i]>57||src[i]<48) return -1;
		number=10*number+(src[i]-48);
	}
	return number;
     b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b50:	c9                   	leave  
     b51:	c3                   	ret    

00000b52 <number2string>:

void number2string(int num, char array[]) {
     b52:	55                   	push   %ebp
     b53:	89 e5                	mov    %esp,%ebp
     b55:	53                   	push   %ebx
     b56:	83 ec 34             	sub    $0x34,%esp
	char array_rvs[20] = {};
     b59:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     b60:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     b67:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
     b6e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
     b75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int i, sign;
	if ((sign = num)<0)	// record the sign
     b7c:	8b 45 08             	mov    0x8(%ebp),%eax
     b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     b86:	79 03                	jns    b8b <number2string+0x39>
		num = -num;		// make num into positive number
     b88:	f7 5d 08             	negl   0x8(%ebp)
	i = 0;
     b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	do {
		array_rvs[i++] = num % 10 + '0';	// fatch the next number
     b92:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     b95:	8d 43 01             	lea    0x1(%ebx),%eax
     b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b9e:	ba 67 66 66 66       	mov    $0x66666667,%edx
     ba3:	89 c8                	mov    %ecx,%eax
     ba5:	f7 ea                	imul   %edx
     ba7:	c1 fa 02             	sar    $0x2,%edx
     baa:	89 c8                	mov    %ecx,%eax
     bac:	c1 f8 1f             	sar    $0x1f,%eax
     baf:	29 c2                	sub    %eax,%edx
     bb1:	89 d0                	mov    %edx,%eax
     bb3:	c1 e0 02             	shl    $0x2,%eax
     bb6:	01 d0                	add    %edx,%eax
     bb8:	01 c0                	add    %eax,%eax
     bba:	29 c1                	sub    %eax,%ecx
     bbc:	89 ca                	mov    %ecx,%edx
     bbe:	89 d0                	mov    %edx,%eax
     bc0:	83 c0 30             	add    $0x30,%eax
     bc3:	88 44 1d d4          	mov    %al,-0x2c(%ebp,%ebx,1)
	} while ((num /= 10)>0);				// delete this number 
     bc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bca:	ba 67 66 66 66       	mov    $0x66666667,%edx
     bcf:	89 c8                	mov    %ecx,%eax
     bd1:	f7 ea                	imul   %edx
     bd3:	c1 fa 02             	sar    $0x2,%edx
     bd6:	89 c8                	mov    %ecx,%eax
     bd8:	c1 f8 1f             	sar    $0x1f,%eax
     bdb:	29 c2                	sub    %eax,%edx
     bdd:	89 d0                	mov    %edx,%eax
     bdf:	89 45 08             	mov    %eax,0x8(%ebp)
     be2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     be6:	7f aa                	jg     b92 <number2string+0x40>
	if (sign<0)
     be8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     bec:	79 0e                	jns    bfc <number2string+0xaa>
		array_rvs[i++] = '-';
     bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bf1:	8d 50 01             	lea    0x1(%eax),%edx
     bf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
     bf7:	c6 44 05 d4 2d       	movb   $0x2d,-0x2c(%ebp,%eax,1)
	array_rvs[i] = '\0';
     bfc:	8d 55 d4             	lea    -0x2c(%ebp),%edx
     bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c02:	01 d0                	add    %edx,%eax
     c04:	c6 00 00             	movb   $0x0,(%eax)
	int length = strlen(array_rvs);
     c07:	83 ec 0c             	sub    $0xc,%esp
     c0a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
     c0d:	50                   	push   %eax
     c0e:	e8 58 38 00 00       	call   446b <strlen>
     c13:	83 c4 10             	add    $0x10,%esp
     c16:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int j = 0; j < length; j++) {
     c19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     c20:	eb 1c                	jmp    c3e <number2string+0xec>
		array[j] = array_rvs[length - 1 - j];
     c22:	8b 55 f0             	mov    -0x10(%ebp),%edx
     c25:	8b 45 0c             	mov    0xc(%ebp),%eax
     c28:	01 c2                	add    %eax,%edx
     c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c2d:	83 e8 01             	sub    $0x1,%eax
     c30:	2b 45 f0             	sub    -0x10(%ebp),%eax
     c33:	0f b6 44 05 d4       	movzbl -0x2c(%ebp,%eax,1),%eax
     c38:	88 02                	mov    %al,(%edx)
	} while ((num /= 10)>0);				// delete this number 
	if (sign<0)
		array_rvs[i++] = '-';
	array_rvs[i] = '\0';
	int length = strlen(array_rvs);
	for (int j = 0; j < length; j++) {
     c3a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c41:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     c44:	7c dc                	jl     c22 <number2string+0xd0>
		array[j] = array_rvs[length - 1 - j];
	}
	array[length] = '\0';
     c46:	8b 55 e8             	mov    -0x18(%ebp),%edx
     c49:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4c:	01 d0                	add    %edx,%eax
     c4e:	c6 00 00             	movb   $0x0,(%eax)
}
     c51:	90                   	nop
     c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c55:	c9                   	leave  
     c56:	c3                   	ret    

00000c57 <com_ins>:

//插入命令，n为用户输入的行号，从1开始
//extra:输入命令时接着的信息，代表待插入的文本
void com_ins(char *text[], int n, char *extra, int flag)
{
     c57:	55                   	push   %ebp
     c58:	89 e5                	mov    %esp,%ebp
     c5a:	57                   	push   %edi
     c5b:	53                   	push   %ebx
     c5c:	81 ec 20 01 00 00    	sub    $0x120,%esp
	if (n <= 0 || n > get_line_number(text) + 1 + 1)
     c62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     c66:	7e 13                	jle    c7b <com_ins+0x24>
     c68:	ff 75 08             	pushl  0x8(%ebp)
     c6b:	e8 0e fe ff ff       	call   a7e <get_line_number>
     c70:	83 c4 04             	add    $0x4,%esp
     c73:	83 c0 02             	add    $0x2,%eax
     c76:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c79:	7d 17                	jge    c92 <com_ins+0x3b>
	{
		printf(1, ">>> \033[1m\e[41;33minvalid line number\e[0m\n");
     c7b:	83 ec 08             	sub    $0x8,%esp
     c7e:	68 14 4d 00 00       	push   $0x4d14
     c83:	6a 01                	push   $0x1
     c85:	e8 1a 3b 00 00       	call   47a4 <printf>
     c8a:	83 c4 10             	add    $0x10,%esp
		return;
     c8d:	e9 85 04 00 00       	jmp    1117 <com_ins+0x4c0>
	}
	char input[MAX_LINE_LENGTH] = {};
     c92:	8d 95 ec fe ff ff    	lea    -0x114(%ebp),%edx
     c98:	b8 00 00 00 00       	mov    $0x0,%eax
     c9d:	b9 40 00 00 00       	mov    $0x40,%ecx
     ca2:	89 d7                	mov    %edx,%edi
     ca4:	f3 ab                	rep stos %eax,%es:(%edi)
	if (*extra == '\0')
     ca6:	8b 45 10             	mov    0x10(%ebp),%eax
     ca9:	0f b6 00             	movzbl (%eax),%eax
     cac:	84 c0                	test   %al,%al
     cae:	75 48                	jne    cf8 <com_ins+0xa1>
	{
		printf(1, "... \e[1;35minput content:\e[0m");
     cb0:	83 ec 08             	sub    $0x8,%esp
     cb3:	68 3d 4d 00 00       	push   $0x4d3d
     cb8:	6a 01                	push   $0x1
     cba:	e8 e5 3a 00 00       	call   47a4 <printf>
     cbf:	83 c4 10             	add    $0x10,%esp
		gets(input, MAX_LINE_LENGTH);
     cc2:	83 ec 08             	sub    $0x8,%esp
     cc5:	68 00 01 00 00       	push   $0x100
     cca:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
     cd0:	50                   	push   %eax
     cd1:	e8 09 38 00 00       	call   44df <gets>
     cd6:	83 c4 10             	add    $0x10,%esp
		input[strlen(input)-1] = '\0';
     cd9:	83 ec 0c             	sub    $0xc,%esp
     cdc:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
     ce2:	50                   	push   %eax
     ce3:	e8 83 37 00 00       	call   446b <strlen>
     ce8:	83 c4 10             	add    $0x10,%esp
     ceb:	83 e8 01             	sub    $0x1,%eax
     cee:	c6 84 05 ec fe ff ff 	movb   $0x0,-0x114(%ebp,%eax,1)
     cf5:	00 
     cf6:	eb 15                	jmp    d0d <com_ins+0xb6>
	}
	else
		strcpy(input, extra);
     cf8:	83 ec 08             	sub    $0x8,%esp
     cfb:	ff 75 10             	pushl  0x10(%ebp)
     cfe:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
     d04:	50                   	push   %eax
     d05:	e8 f2 36 00 00       	call   43fc <strcpy>
     d0a:	83 c4 10             	add    $0x10,%esp
	
	char *part4 = malloc(MAX_LINE_LENGTH); 
     d0d:	83 ec 0c             	sub    $0xc,%esp
     d10:	68 00 01 00 00       	push   $0x100
     d15:	e8 5d 3d 00 00       	call   4a77 <malloc>
     d1a:	83 c4 10             	add    $0x10,%esp
     d1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(flag){
     d20:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     d24:	74 25                	je     d4b <com_ins+0xf4>
		strcpy(part4, text[n-1]);
     d26:	8b 45 0c             	mov    0xc(%ebp),%eax
     d29:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     d2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     d35:	8b 45 08             	mov    0x8(%ebp),%eax
     d38:	01 d0                	add    %edx,%eax
     d3a:	8b 00                	mov    (%eax),%eax
     d3c:	83 ec 08             	sub    $0x8,%esp
     d3f:	50                   	push   %eax
     d40:	ff 75 f0             	pushl  -0x10(%ebp)
     d43:	e8 b4 36 00 00       	call   43fc <strcpy>
     d48:	83 c4 10             	add    $0x10,%esp
	}

	int i = MAX_LINE_NUMBER - 1;
     d4b:	c7 45 f4 ff 00 00 00 	movl   $0xff,-0xc(%ebp)
	for (; i > n-1; i--)
     d52:	e9 5e 01 00 00       	jmp    eb5 <com_ins+0x25e>
	{
		if (text[i-1] == NULL)
     d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d5a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     d5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     d66:	8b 45 08             	mov    0x8(%ebp),%eax
     d69:	01 d0                	add    %edx,%eax
     d6b:	8b 00                	mov    (%eax),%eax
     d6d:	85 c0                	test   %eax,%eax
     d6f:	0f 84 3b 01 00 00    	je     eb0 <com_ins+0x259>
			continue;
		else if (text[i] == NULL && text[i-1] != NULL)
     d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     d7f:	8b 45 08             	mov    0x8(%ebp),%eax
     d82:	01 d0                	add    %edx,%eax
     d84:	8b 00                	mov    (%eax),%eax
     d86:	85 c0                	test   %eax,%eax
     d88:	0f 85 99 00 00 00    	jne    e27 <com_ins+0x1d0>
     d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d91:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     d96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     d9d:	8b 45 08             	mov    0x8(%ebp),%eax
     da0:	01 d0                	add    %edx,%eax
     da2:	8b 00                	mov    (%eax),%eax
     da4:	85 c0                	test   %eax,%eax
     da6:	74 7f                	je     e27 <com_ins+0x1d0>
		{
			text[i] = malloc(MAX_LINE_LENGTH);
     da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     db2:	8b 45 08             	mov    0x8(%ebp),%eax
     db5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
     db8:	83 ec 0c             	sub    $0xc,%esp
     dbb:	68 00 01 00 00       	push   $0x100
     dc0:	e8 b2 3c 00 00       	call   4a77 <malloc>
     dc5:	83 c4 10             	add    $0x10,%esp
     dc8:	89 03                	mov    %eax,(%ebx)
			memset(text[i], 0, MAX_LINE_LENGTH);
     dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     dd4:	8b 45 08             	mov    0x8(%ebp),%eax
     dd7:	01 d0                	add    %edx,%eax
     dd9:	8b 00                	mov    (%eax),%eax
     ddb:	83 ec 04             	sub    $0x4,%esp
     dde:	68 00 01 00 00       	push   $0x100
     de3:	6a 00                	push   $0x0
     de5:	50                   	push   %eax
     de6:	e8 a7 36 00 00       	call   4492 <memset>
     deb:	83 c4 10             	add    $0x10,%esp
			strcpy(text[i], text[i-1]);
     dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     df6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     dfd:	8b 45 08             	mov    0x8(%ebp),%eax
     e00:	01 d0                	add    %edx,%eax
     e02:	8b 10                	mov    (%eax),%edx
     e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e07:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
     e0e:	8b 45 08             	mov    0x8(%ebp),%eax
     e11:	01 c8                	add    %ecx,%eax
     e13:	8b 00                	mov    (%eax),%eax
     e15:	83 ec 08             	sub    $0x8,%esp
     e18:	52                   	push   %edx
     e19:	50                   	push   %eax
     e1a:	e8 dd 35 00 00       	call   43fc <strcpy>
     e1f:	83 c4 10             	add    $0x10,%esp
     e22:	e9 8a 00 00 00       	jmp    eb1 <com_ins+0x25a>
		}
		else if (text[i] != NULL && text[i-1] != NULL)
     e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     e31:	8b 45 08             	mov    0x8(%ebp),%eax
     e34:	01 d0                	add    %edx,%eax
     e36:	8b 00                	mov    (%eax),%eax
     e38:	85 c0                	test   %eax,%eax
     e3a:	74 75                	je     eb1 <com_ins+0x25a>
     e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e3f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     e44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     e4b:	8b 45 08             	mov    0x8(%ebp),%eax
     e4e:	01 d0                	add    %edx,%eax
     e50:	8b 00                	mov    (%eax),%eax
     e52:	85 c0                	test   %eax,%eax
     e54:	74 5b                	je     eb1 <com_ins+0x25a>
		{
			memset(text[i], 0, MAX_LINE_LENGTH);
     e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     e60:	8b 45 08             	mov    0x8(%ebp),%eax
     e63:	01 d0                	add    %edx,%eax
     e65:	8b 00                	mov    (%eax),%eax
     e67:	83 ec 04             	sub    $0x4,%esp
     e6a:	68 00 01 00 00       	push   $0x100
     e6f:	6a 00                	push   $0x0
     e71:	50                   	push   %eax
     e72:	e8 1b 36 00 00       	call   4492 <memset>
     e77:	83 c4 10             	add    $0x10,%esp
			strcpy(text[i], text[i-1]);
     e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e7d:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     e82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     e89:	8b 45 08             	mov    0x8(%ebp),%eax
     e8c:	01 d0                	add    %edx,%eax
     e8e:	8b 10                	mov    (%eax),%edx
     e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e93:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
     e9a:	8b 45 08             	mov    0x8(%ebp),%eax
     e9d:	01 c8                	add    %ecx,%eax
     e9f:	8b 00                	mov    (%eax),%eax
     ea1:	83 ec 08             	sub    $0x8,%esp
     ea4:	52                   	push   %edx
     ea5:	50                   	push   %eax
     ea6:	e8 51 35 00 00       	call   43fc <strcpy>
     eab:	83 c4 10             	add    $0x10,%esp
     eae:	eb 01                	jmp    eb1 <com_ins+0x25a>

	int i = MAX_LINE_NUMBER - 1;
	for (; i > n-1; i--)
	{
		if (text[i-1] == NULL)
			continue;
     eb0:	90                   	nop
	if(flag){
		strcpy(part4, text[n-1]);
	}

	int i = MAX_LINE_NUMBER - 1;
	for (; i > n-1; i--)
     eb1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb8:	83 e8 01             	sub    $0x1,%eax
     ebb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     ebe:	0f 8c 93 fe ff ff    	jl     d57 <com_ins+0x100>
			strcpy(text[i], text[i-1]);
		}
	}
	// couldn't understand what this code block means
	// maybe it allocates space for text[n-1] to avoid none space of text[n-1]
	if (text[n-1] == NULL)
     ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
     ec7:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     ecc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     ed3:	8b 45 08             	mov    0x8(%ebp),%eax
     ed6:	01 d0                	add    %edx,%eax
     ed8:	8b 00                	mov    (%eax),%eax
     eda:	85 c0                	test   %eax,%eax
     edc:	0f 85 c1 00 00 00    	jne    fa3 <com_ins+0x34c>
	{
		text[n-1] = malloc(MAX_LINE_LENGTH);
     ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ee5:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     eea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     ef1:	8b 45 08             	mov    0x8(%ebp),%eax
     ef4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
     ef7:	83 ec 0c             	sub    $0xc,%esp
     efa:	68 00 01 00 00       	push   $0x100
     eff:	e8 73 3b 00 00       	call   4a77 <malloc>
     f04:	83 c4 10             	add    $0x10,%esp
     f07:	89 03                	mov    %eax,(%ebx)
		if (text[n-2][0] == '\0')
     f09:	8b 45 0c             	mov    0xc(%ebp),%eax
     f0c:	05 fe ff ff 3f       	add    $0x3ffffffe,%eax
     f11:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     f18:	8b 45 08             	mov    0x8(%ebp),%eax
     f1b:	01 d0                	add    %edx,%eax
     f1d:	8b 00                	mov    (%eax),%eax
     f1f:	0f b6 00             	movzbl (%eax),%eax
     f22:	84 c0                	test   %al,%al
     f24:	75 7d                	jne    fa3 <com_ins+0x34c>
		{
			memset(text[n-1], 0, MAX_LINE_LENGTH);
     f26:	8b 45 0c             	mov    0xc(%ebp),%eax
     f29:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     f2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     f35:	8b 45 08             	mov    0x8(%ebp),%eax
     f38:	01 d0                	add    %edx,%eax
     f3a:	8b 00                	mov    (%eax),%eax
     f3c:	83 ec 04             	sub    $0x4,%esp
     f3f:	68 00 01 00 00       	push   $0x100
     f44:	6a 00                	push   $0x0
     f46:	50                   	push   %eax
     f47:	e8 46 35 00 00       	call   4492 <memset>
     f4c:	83 c4 10             	add    $0x10,%esp
			strcpy(text[n-2], input);
     f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
     f52:	05 fe ff ff 3f       	add    $0x3ffffffe,%eax
     f57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     f5e:	8b 45 08             	mov    0x8(%ebp),%eax
     f61:	01 d0                	add    %edx,%eax
     f63:	8b 00                	mov    (%eax),%eax
     f65:	83 ec 08             	sub    $0x8,%esp
     f68:	8d 95 ec fe ff ff    	lea    -0x114(%ebp),%edx
     f6e:	52                   	push   %edx
     f6f:	50                   	push   %eax
     f70:	e8 87 34 00 00       	call   43fc <strcpy>
     f75:	83 c4 10             	add    $0x10,%esp
			changed = 1;
     f78:	c7 05 80 5e 00 00 01 	movl   $0x1,0x5e80
     f7f:	00 00 00 
			if (auto_show == 1)
     f82:	a1 5c 5e 00 00       	mov    0x5e5c,%eax
     f87:	83 f8 01             	cmp    $0x1,%eax
     f8a:	0f 85 86 01 00 00    	jne    1116 <com_ins+0x4bf>
				show_text_syntax_highlighting(text);
     f90:	83 ec 0c             	sub    $0xc,%esp
     f93:	ff 75 08             	pushl  0x8(%ebp)
     f96:	e8 f6 0d 00 00       	call   1d91 <show_text_syntax_highlighting>
     f9b:	83 c4 10             	add    $0x10,%esp
			return;
     f9e:	e9 73 01 00 00       	jmp    1116 <com_ins+0x4bf>
		}
	}
	memset(text[n-1], 0, MAX_LINE_LENGTH);
     fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa6:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     fab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     fb2:	8b 45 08             	mov    0x8(%ebp),%eax
     fb5:	01 d0                	add    %edx,%eax
     fb7:	8b 00                	mov    (%eax),%eax
     fb9:	83 ec 04             	sub    $0x4,%esp
     fbc:	68 00 01 00 00       	push   $0x100
     fc1:	6a 00                	push   $0x0
     fc3:	50                   	push   %eax
     fc4:	e8 c9 34 00 00       	call   4492 <memset>
     fc9:	83 c4 10             	add    $0x10,%esp
	strcpy(text[n-1], input);
     fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
     fcf:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
     fd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     fdb:	8b 45 08             	mov    0x8(%ebp),%eax
     fde:	01 d0                	add    %edx,%eax
     fe0:	8b 00                	mov    (%eax),%eax
     fe2:	83 ec 08             	sub    $0x8,%esp
     fe5:	8d 95 ec fe ff ff    	lea    -0x114(%ebp),%edx
     feb:	52                   	push   %edx
     fec:	50                   	push   %eax
     fed:	e8 0a 34 00 00       	call   43fc <strcpy>
     ff2:	83 c4 10             	add    $0x10,%esp
	changed = 1;
     ff5:	c7 05 80 5e 00 00 01 	movl   $0x1,0x5e80
     ffc:	00 00 00 
	
	if(flag){ // 非rollback的调用时才记录命令
     fff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1003:	0f 84 f3 00 00 00    	je     10fc <com_ins+0x4a5>
		// record the command into command_set
		char *command = malloc(MAX_LINE_LENGTH);
    1009:	83 ec 0c             	sub    $0xc,%esp
    100c:	68 00 01 00 00       	push   $0x100
    1011:	e8 61 3a 00 00       	call   4a77 <malloc>
    1016:	83 c4 10             	add    $0x10,%esp
    1019:	89 45 ec             	mov    %eax,-0x14(%ebp)
		char part1[] = "ins-";
    101c:	c7 85 e7 fe ff ff 69 	movl   $0x2d736e69,-0x119(%ebp)
    1023:	6e 73 2d 
    1026:	c6 85 eb fe ff ff 00 	movb   $0x0,-0x115(%ebp)
		char part2[10]; 
		number2string(n, part2);
    102d:	83 ec 08             	sub    $0x8,%esp
    1030:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
    1036:	50                   	push   %eax
    1037:	ff 75 0c             	pushl  0xc(%ebp)
    103a:	e8 13 fb ff ff       	call   b52 <number2string>
    103f:	83 c4 10             	add    $0x10,%esp
		char part3[] = " \0";
    1042:	0f b7 05 5b 4d 00 00 	movzwl 0x4d5b,%eax
    1049:	66 89 85 da fe ff ff 	mov    %ax,-0x126(%ebp)
    1050:	0f b6 05 5d 4d 00 00 	movzbl 0x4d5d,%eax
    1057:	88 85 dc fe ff ff    	mov    %al,-0x124(%ebp)
		strcat_n(part1, part2, strlen(part2));
    105d:	83 ec 0c             	sub    $0xc,%esp
    1060:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
    1066:	50                   	push   %eax
    1067:	e8 ff 33 00 00       	call   446b <strlen>
    106c:	83 c4 10             	add    $0x10,%esp
    106f:	83 ec 04             	sub    $0x4,%esp
    1072:	50                   	push   %eax
    1073:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
    1079:	50                   	push   %eax
    107a:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
    1080:	50                   	push   %eax
    1081:	e8 aa f7 ff ff       	call   830 <strcat_n>
    1086:	83 c4 10             	add    $0x10,%esp
		strcat_n(part1, part3, strlen(part3));
    1089:	83 ec 0c             	sub    $0xc,%esp
    108c:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
    1092:	50                   	push   %eax
    1093:	e8 d3 33 00 00       	call   446b <strlen>
    1098:	83 c4 10             	add    $0x10,%esp
    109b:	83 ec 04             	sub    $0x4,%esp
    109e:	50                   	push   %eax
    109f:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
    10a5:	50                   	push   %eax
    10a6:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
    10ac:	50                   	push   %eax
    10ad:	e8 7e f7 ff ff       	call   830 <strcat_n>
    10b2:	83 c4 10             	add    $0x10,%esp
		strcat_n(part1, part4, strlen(part4));
    10b5:	83 ec 0c             	sub    $0xc,%esp
    10b8:	ff 75 f0             	pushl  -0x10(%ebp)
    10bb:	e8 ab 33 00 00       	call   446b <strlen>
    10c0:	83 c4 10             	add    $0x10,%esp
    10c3:	83 ec 04             	sub    $0x4,%esp
    10c6:	50                   	push   %eax
    10c7:	ff 75 f0             	pushl  -0x10(%ebp)
    10ca:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
    10d0:	50                   	push   %eax
    10d1:	e8 5a f7 ff ff       	call   830 <strcat_n>
    10d6:	83 c4 10             	add    $0x10,%esp
		strcpy(command, part1);
    10d9:	83 ec 08             	sub    $0x8,%esp
    10dc:	8d 85 e7 fe ff ff    	lea    -0x119(%ebp),%eax
    10e2:	50                   	push   %eax
    10e3:	ff 75 ec             	pushl  -0x14(%ebp)
    10e6:	e8 11 33 00 00       	call   43fc <strcpy>
    10eb:	83 c4 10             	add    $0x10,%esp
		record_command(command);
    10ee:	83 ec 0c             	sub    $0xc,%esp
    10f1:	ff 75 ec             	pushl  -0x14(%ebp)
    10f4:	e8 1b 32 00 00       	call   4314 <record_command>
    10f9:	83 c4 10             	add    $0x10,%esp
	}

	if (auto_show == 1)
    10fc:	a1 5c 5e 00 00       	mov    0x5e5c,%eax
    1101:	83 f8 01             	cmp    $0x1,%eax
    1104:	75 11                	jne    1117 <com_ins+0x4c0>
		show_text_syntax_highlighting(text);
    1106:	83 ec 0c             	sub    $0xc,%esp
    1109:	ff 75 08             	pushl  0x8(%ebp)
    110c:	e8 80 0c 00 00       	call   1d91 <show_text_syntax_highlighting>
    1111:	83 c4 10             	add    $0x10,%esp
    1114:	eb 01                	jmp    1117 <com_ins+0x4c0>
			memset(text[n-1], 0, MAX_LINE_LENGTH);
			strcpy(text[n-2], input);
			changed = 1;
			if (auto_show == 1)
				show_text_syntax_highlighting(text);
			return;
    1116:	90                   	nop
		record_command(command);
	}

	if (auto_show == 1)
		show_text_syntax_highlighting(text);
}
    1117:	8d 65 f8             	lea    -0x8(%ebp),%esp
    111a:	5b                   	pop    %ebx
    111b:	5f                   	pop    %edi
    111c:	5d                   	pop    %ebp
    111d:	c3                   	ret    

0000111e <com_mod>:

//修改命令，n为用户输入的行号，从1开始
//extra:输入命令时接着的信息，代表待修改成的文本
void com_mod(char *text[], int n, char *extra, int flag)
{
    111e:	55                   	push   %ebp
    111f:	89 e5                	mov    %esp,%ebp
    1121:	57                   	push   %edi
    1122:	81 ec 24 01 00 00    	sub    $0x124,%esp
	if (n <= 0 || n > get_line_number(text) + 1)
    1128:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    112c:	7e 13                	jle    1141 <com_mod+0x23>
    112e:	ff 75 08             	pushl  0x8(%ebp)
    1131:	e8 48 f9 ff ff       	call   a7e <get_line_number>
    1136:	83 c4 04             	add    $0x4,%esp
    1139:	83 c0 01             	add    $0x1,%eax
    113c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    113f:	7d 17                	jge    1158 <com_mod+0x3a>
	{
		printf(1, ">>> \033[1m\e[41;33minvalid line number\e[0m\n");
    1141:	83 ec 08             	sub    $0x8,%esp
    1144:	68 14 4d 00 00       	push   $0x4d14
    1149:	6a 01                	push   $0x1
    114b:	e8 54 36 00 00       	call   47a4 <printf>
    1150:	83 c4 10             	add    $0x10,%esp
    1153:	e9 2a 02 00 00       	jmp    1382 <com_mod+0x264>
		return;
	}
	char input[MAX_LINE_LENGTH] = {};
    1158:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
    115e:	b8 00 00 00 00       	mov    $0x0,%eax
    1163:	b9 40 00 00 00       	mov    $0x40,%ecx
    1168:	89 d7                	mov    %edx,%edi
    116a:	f3 ab                	rep stos %eax,%es:(%edi)
	if (*extra == '\0')
    116c:	8b 45 10             	mov    0x10(%ebp),%eax
    116f:	0f b6 00             	movzbl (%eax),%eax
    1172:	84 c0                	test   %al,%al
    1174:	75 48                	jne    11be <com_mod+0xa0>
	{
		printf(1, "... \e[1;35minput content:\e[0m");
    1176:	83 ec 08             	sub    $0x8,%esp
    1179:	68 3d 4d 00 00       	push   $0x4d3d
    117e:	6a 01                	push   $0x1
    1180:	e8 1f 36 00 00       	call   47a4 <printf>
    1185:	83 c4 10             	add    $0x10,%esp
		gets(input, MAX_LINE_LENGTH);
    1188:	83 ec 08             	sub    $0x8,%esp
    118b:	68 00 01 00 00       	push   $0x100
    1190:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
    1196:	50                   	push   %eax
    1197:	e8 43 33 00 00       	call   44df <gets>
    119c:	83 c4 10             	add    $0x10,%esp
		input[strlen(input)-1] = '\0';
    119f:	83 ec 0c             	sub    $0xc,%esp
    11a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
    11a8:	50                   	push   %eax
    11a9:	e8 bd 32 00 00       	call   446b <strlen>
    11ae:	83 c4 10             	add    $0x10,%esp
    11b1:	83 e8 01             	sub    $0x1,%eax
    11b4:	c6 84 05 f0 fe ff ff 	movb   $0x0,-0x110(%ebp,%eax,1)
    11bb:	00 
    11bc:	eb 15                	jmp    11d3 <com_mod+0xb5>
	}
	else
		strcpy(input, extra);
    11be:	83 ec 08             	sub    $0x8,%esp
    11c1:	ff 75 10             	pushl  0x10(%ebp)
    11c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
    11ca:	50                   	push   %eax
    11cb:	e8 2c 32 00 00       	call   43fc <strcpy>
    11d0:	83 c4 10             	add    $0x10,%esp

	char *part4 = malloc(MAX_LINE_LENGTH); 
    11d3:	83 ec 0c             	sub    $0xc,%esp
    11d6:	68 00 01 00 00       	push   $0x100
    11db:	e8 97 38 00 00       	call   4a77 <malloc>
    11e0:	83 c4 10             	add    $0x10,%esp
    11e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(flag){
    11e6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    11ea:	74 25                	je     1211 <com_mod+0xf3>
		strcpy(part4, text[n-1]);
    11ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ef:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
    11f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    11fb:	8b 45 08             	mov    0x8(%ebp),%eax
    11fe:	01 d0                	add    %edx,%eax
    1200:	8b 00                	mov    (%eax),%eax
    1202:	83 ec 08             	sub    $0x8,%esp
    1205:	50                   	push   %eax
    1206:	ff 75 f4             	pushl  -0xc(%ebp)
    1209:	e8 ee 31 00 00       	call   43fc <strcpy>
    120e:	83 c4 10             	add    $0x10,%esp
	}

	memset(text[n-1], 0, MAX_LINE_LENGTH);
    1211:	8b 45 0c             	mov    0xc(%ebp),%eax
    1214:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
    1219:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1220:	8b 45 08             	mov    0x8(%ebp),%eax
    1223:	01 d0                	add    %edx,%eax
    1225:	8b 00                	mov    (%eax),%eax
    1227:	83 ec 04             	sub    $0x4,%esp
    122a:	68 00 01 00 00       	push   $0x100
    122f:	6a 00                	push   $0x0
    1231:	50                   	push   %eax
    1232:	e8 5b 32 00 00       	call   4492 <memset>
    1237:	83 c4 10             	add    $0x10,%esp
	strcpy(text[n-1], input);
    123a:	8b 45 0c             	mov    0xc(%ebp),%eax
    123d:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
    1242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1249:	8b 45 08             	mov    0x8(%ebp),%eax
    124c:	01 d0                	add    %edx,%eax
    124e:	8b 00                	mov    (%eax),%eax
    1250:	83 ec 08             	sub    $0x8,%esp
    1253:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
    1259:	52                   	push   %edx
    125a:	50                   	push   %eax
    125b:	e8 9c 31 00 00       	call   43fc <strcpy>
    1260:	83 c4 10             	add    $0x10,%esp
	changed = 1;
    1263:	c7 05 80 5e 00 00 01 	movl   $0x1,0x5e80
    126a:	00 00 00 

	if(flag){ // 非rollback调用才记录
    126d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1271:	0f 84 f3 00 00 00    	je     136a <com_mod+0x24c>
		// record the command into command_set
		char *command = malloc(MAX_LINE_LENGTH);
    1277:	83 ec 0c             	sub    $0xc,%esp
    127a:	68 00 01 00 00       	push   $0x100
    127f:	e8 f3 37 00 00       	call   4a77 <malloc>
    1284:	83 c4 10             	add    $0x10,%esp
    1287:	89 45 f0             	mov    %eax,-0x10(%ebp)
		char part1[] = "mod-";
    128a:	c7 85 eb fe ff ff 6d 	movl   $0x2d646f6d,-0x115(%ebp)
    1291:	6f 64 2d 
    1294:	c6 85 ef fe ff ff 00 	movb   $0x0,-0x111(%ebp)
		char part2[10]; 
		number2string(n, part2);
    129b:	83 ec 08             	sub    $0x8,%esp
    129e:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
    12a4:	50                   	push   %eax
    12a5:	ff 75 0c             	pushl  0xc(%ebp)
    12a8:	e8 a5 f8 ff ff       	call   b52 <number2string>
    12ad:	83 c4 10             	add    $0x10,%esp
		char part3[] = " \0";
    12b0:	0f b7 05 5b 4d 00 00 	movzwl 0x4d5b,%eax
    12b7:	66 89 85 de fe ff ff 	mov    %ax,-0x122(%ebp)
    12be:	0f b6 05 5d 4d 00 00 	movzbl 0x4d5d,%eax
    12c5:	88 85 e0 fe ff ff    	mov    %al,-0x120(%ebp)
		strcat_n(part1, part2, strlen(part2));
    12cb:	83 ec 0c             	sub    $0xc,%esp
    12ce:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
    12d4:	50                   	push   %eax
    12d5:	e8 91 31 00 00       	call   446b <strlen>
    12da:	83 c4 10             	add    $0x10,%esp
    12dd:	83 ec 04             	sub    $0x4,%esp
    12e0:	50                   	push   %eax
    12e1:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
    12e7:	50                   	push   %eax
    12e8:	8d 85 eb fe ff ff    	lea    -0x115(%ebp),%eax
    12ee:	50                   	push   %eax
    12ef:	e8 3c f5 ff ff       	call   830 <strcat_n>
    12f4:	83 c4 10             	add    $0x10,%esp
		strcat_n(part1, part3, strlen(part3));
    12f7:	83 ec 0c             	sub    $0xc,%esp
    12fa:	8d 85 de fe ff ff    	lea    -0x122(%ebp),%eax
    1300:	50                   	push   %eax
    1301:	e8 65 31 00 00       	call   446b <strlen>
    1306:	83 c4 10             	add    $0x10,%esp
    1309:	83 ec 04             	sub    $0x4,%esp
    130c:	50                   	push   %eax
    130d:	8d 85 de fe ff ff    	lea    -0x122(%ebp),%eax
    1313:	50                   	push   %eax
    1314:	8d 85 eb fe ff ff    	lea    -0x115(%ebp),%eax
    131a:	50                   	push   %eax
    131b:	e8 10 f5 ff ff       	call   830 <strcat_n>
    1320:	83 c4 10             	add    $0x10,%esp
		strcat_n(part1, part4, strlen(part4));
    1323:	83 ec 0c             	sub    $0xc,%esp
    1326:	ff 75 f4             	pushl  -0xc(%ebp)
    1329:	e8 3d 31 00 00       	call   446b <strlen>
    132e:	83 c4 10             	add    $0x10,%esp
    1331:	83 ec 04             	sub    $0x4,%esp
    1334:	50                   	push   %eax
    1335:	ff 75 f4             	pushl  -0xc(%ebp)
    1338:	8d 85 eb fe ff ff    	lea    -0x115(%ebp),%eax
    133e:	50                   	push   %eax
    133f:	e8 ec f4 ff ff       	call   830 <strcat_n>
    1344:	83 c4 10             	add    $0x10,%esp
		strcpy(command, part1);
    1347:	83 ec 08             	sub    $0x8,%esp
    134a:	8d 85 eb fe ff ff    	lea    -0x115(%ebp),%eax
    1350:	50                   	push   %eax
    1351:	ff 75 f0             	pushl  -0x10(%ebp)
    1354:	e8 a3 30 00 00       	call   43fc <strcpy>
    1359:	83 c4 10             	add    $0x10,%esp
		record_command(command);
    135c:	83 ec 0c             	sub    $0xc,%esp
    135f:	ff 75 f0             	pushl  -0x10(%ebp)
    1362:	e8 ad 2f 00 00       	call   4314 <record_command>
    1367:	83 c4 10             	add    $0x10,%esp
	}

	if (auto_show == 1)
    136a:	a1 5c 5e 00 00       	mov    0x5e5c,%eax
    136f:	83 f8 01             	cmp    $0x1,%eax
    1372:	75 0e                	jne    1382 <com_mod+0x264>
		show_text_syntax_highlighting(text);
    1374:	83 ec 0c             	sub    $0xc,%esp
    1377:	ff 75 08             	pushl  0x8(%ebp)
    137a:	e8 12 0a 00 00       	call   1d91 <show_text_syntax_highlighting>
    137f:	83 c4 10             	add    $0x10,%esp
}
    1382:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1385:	c9                   	leave  
    1386:	c3                   	ret    

00001387 <com_del>:

//删除命令，n为用户输入的行号，从1开始
void com_del(char *text[], int n, int flag)
{
    1387:	55                   	push   %ebp
    1388:	89 e5                	mov    %esp,%ebp
    138a:	83 ec 28             	sub    $0x28,%esp
	if (n <= 0 || n > get_line_number(text) + 1)
    138d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1391:	7e 13                	jle    13a6 <com_del+0x1f>
    1393:	ff 75 08             	pushl  0x8(%ebp)
    1396:	e8 e3 f6 ff ff       	call   a7e <get_line_number>
    139b:	83 c4 04             	add    $0x4,%esp
    139e:	83 c0 01             	add    $0x1,%eax
    13a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
    13a4:	7d 17                	jge    13bd <com_del+0x36>
	{
		//printf(1, "n: %d\n", n);
		printf(1, ">>> \033[1m\e[41;33minvalid line number\e[0m\n");
    13a6:	83 ec 08             	sub    $0x8,%esp
    13a9:	68 14 4d 00 00       	push   $0x4d14
    13ae:	6a 01                	push   $0x1
    13b0:	e8 ef 33 00 00       	call   47a4 <printf>
    13b5:	83 c4 10             	add    $0x10,%esp
		return;
    13b8:	e9 41 01 00 00       	jmp    14fe <com_del+0x177>
	}

	char *part4 = malloc(MAX_LINE_LENGTH); 
    13bd:	83 ec 0c             	sub    $0xc,%esp
    13c0:	68 00 01 00 00       	push   $0x100
    13c5:	e8 ad 36 00 00       	call   4a77 <malloc>
    13ca:	83 c4 10             	add    $0x10,%esp
    13cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(flag){
    13d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    13d4:	74 25                	je     13fb <com_del+0x74>
		strcpy(part4, text[n-1]);
    13d6:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d9:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
    13de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    13e5:	8b 45 08             	mov    0x8(%ebp),%eax
    13e8:	01 d0                	add    %edx,%eax
    13ea:	8b 00                	mov    (%eax),%eax
    13ec:	83 ec 08             	sub    $0x8,%esp
    13ef:	50                   	push   %eax
    13f0:	ff 75 f0             	pushl  -0x10(%ebp)
    13f3:	e8 04 30 00 00       	call   43fc <strcpy>
    13f8:	83 c4 10             	add    $0x10,%esp
	}

	memset(text[n-1], 0, MAX_LINE_LENGTH);
    13fb:	8b 45 0c             	mov    0xc(%ebp),%eax
    13fe:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
    1403:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    140a:	8b 45 08             	mov    0x8(%ebp),%eax
    140d:	01 d0                	add    %edx,%eax
    140f:	8b 00                	mov    (%eax),%eax
    1411:	83 ec 04             	sub    $0x4,%esp
    1414:	68 00 01 00 00       	push   $0x100
    1419:	6a 00                	push   $0x0
    141b:	50                   	push   %eax
    141c:	e8 71 30 00 00       	call   4492 <memset>
    1421:	83 c4 10             	add    $0x10,%esp
	int i = n - 1;
    1424:	8b 45 0c             	mov    0xc(%ebp),%eax
    1427:	83 e8 01             	sub    $0x1,%eax
    142a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (; text[i+1] != NULL; i++)
    142d:	eb 5d                	jmp    148c <com_del+0x105>
	{
		strcpy(text[i], text[i+1]);
    142f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1432:	83 c0 01             	add    $0x1,%eax
    1435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    143c:	8b 45 08             	mov    0x8(%ebp),%eax
    143f:	01 d0                	add    %edx,%eax
    1441:	8b 10                	mov    (%eax),%edx
    1443:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1446:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    144d:	8b 45 08             	mov    0x8(%ebp),%eax
    1450:	01 c8                	add    %ecx,%eax
    1452:	8b 00                	mov    (%eax),%eax
    1454:	83 ec 08             	sub    $0x8,%esp
    1457:	52                   	push   %edx
    1458:	50                   	push   %eax
    1459:	e8 9e 2f 00 00       	call   43fc <strcpy>
    145e:	83 c4 10             	add    $0x10,%esp
		memset(text[i+1], 0, MAX_LINE_LENGTH);
    1461:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1464:	83 c0 01             	add    $0x1,%eax
    1467:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    146e:	8b 45 08             	mov    0x8(%ebp),%eax
    1471:	01 d0                	add    %edx,%eax
    1473:	8b 00                	mov    (%eax),%eax
    1475:	83 ec 04             	sub    $0x4,%esp
    1478:	68 00 01 00 00       	push   $0x100
    147d:	6a 00                	push   $0x0
    147f:	50                   	push   %eax
    1480:	e8 0d 30 00 00       	call   4492 <memset>
    1485:	83 c4 10             	add    $0x10,%esp
		strcpy(part4, text[n-1]);
	}

	memset(text[n-1], 0, MAX_LINE_LENGTH);
	int i = n - 1;
	for (; text[i+1] != NULL; i++)
    1488:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    148c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148f:	83 c0 01             	add    $0x1,%eax
    1492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1499:	8b 45 08             	mov    0x8(%ebp),%eax
    149c:	01 d0                	add    %edx,%eax
    149e:	8b 00                	mov    (%eax),%eax
    14a0:	85 c0                	test   %eax,%eax
    14a2:	75 8b                	jne    142f <com_del+0xa8>
	{
		strcpy(text[i], text[i+1]);
		memset(text[i+1], 0, MAX_LINE_LENGTH);
	}
	if (i != 0)
    14a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14a8:	74 32                	je     14dc <com_del+0x155>
	{
		free(text[i]);
    14aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    14b4:	8b 45 08             	mov    0x8(%ebp),%eax
    14b7:	01 d0                	add    %edx,%eax
    14b9:	8b 00                	mov    (%eax),%eax
    14bb:	83 ec 0c             	sub    $0xc,%esp
    14be:	50                   	push   %eax
    14bf:	e8 71 34 00 00       	call   4935 <free>
    14c4:	83 c4 10             	add    $0x10,%esp
		text[i] = 0;
    14c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    14d1:	8b 45 08             	mov    0x8(%ebp),%eax
    14d4:	01 d0                	add    %edx,%eax
    14d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	changed = 1;
    14dc:	c7 05 80 5e 00 00 01 	movl   $0x1,0x5e80
    14e3:	00 00 00 
		strcat_n(part5, part1, strlen(part1));
		strcat_n(part5, part4, strlen(part4));
		record_command(part5);
	}

	if (auto_show == 1)
    14e6:	a1 5c 5e 00 00       	mov    0x5e5c,%eax
    14eb:	83 f8 01             	cmp    $0x1,%eax
    14ee:	75 0e                	jne    14fe <com_del+0x177>
		show_text_syntax_highlighting(text);
    14f0:	83 ec 0c             	sub    $0xc,%esp
    14f3:	ff 75 08             	pushl  0x8(%ebp)
    14f6:	e8 96 08 00 00       	call   1d91 <show_text_syntax_highlighting>
    14fb:	83 c4 10             	add    $0x10,%esp
}
    14fe:	c9                   	leave  
    14ff:	c3                   	ret    

00001500 <com_save>:

void com_save(char *text[], char *path)
{
    1500:	55                   	push   %ebp
    1501:	89 e5                	mov    %esp,%ebp
    1503:	83 ec 18             	sub    $0x18,%esp
	//删除旧有文件
	unlink(path);
    1506:	83 ec 0c             	sub    $0xc,%esp
    1509:	ff 75 0c             	pushl  0xc(%ebp)
    150c:	e8 6c 31 00 00       	call   467d <unlink>
    1511:	83 c4 10             	add    $0x10,%esp
	//新建文件并打开
	int fd = open(path, O_WRONLY|O_CREATE);
    1514:	83 ec 08             	sub    $0x8,%esp
    1517:	68 01 02 00 00       	push   $0x201
    151c:	ff 75 0c             	pushl  0xc(%ebp)
    151f:	e8 49 31 00 00       	call   466d <open>
    1524:	83 c4 10             	add    $0x10,%esp
    1527:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (fd == -1)
    152a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    152e:	75 17                	jne    1547 <com_save+0x47>
	{
		printf(1, ">>> \033[1m\e[41;33msave failed, file can't open:\e[0m\n");
    1530:	83 ec 08             	sub    $0x8,%esp
    1533:	68 60 4d 00 00       	push   $0x4d60
    1538:	6a 01                	push   $0x1
    153a:	e8 65 32 00 00       	call   47a4 <printf>
    153f:	83 c4 10             	add    $0x10,%esp
		//setProgramStatus(SHELL);
		exit();
    1542:	e8 e6 30 00 00       	call   462d <exit>
	}
	if (text[0] == NULL)
    1547:	8b 45 08             	mov    0x8(%ebp),%eax
    154a:	8b 00                	mov    (%eax),%eax
    154c:	85 c0                	test   %eax,%eax
    154e:	75 13                	jne    1563 <com_save+0x63>
	{
		close(fd);
    1550:	83 ec 0c             	sub    $0xc,%esp
    1553:	ff 75 f0             	pushl  -0x10(%ebp)
    1556:	e8 fa 30 00 00       	call   4655 <close>
    155b:	83 c4 10             	add    $0x10,%esp
		return;
    155e:	e9 c8 00 00 00       	jmp    162b <com_save+0x12b>
	}
	//写数据
	write(fd, text[0], strlen(text[0]));
    1563:	8b 45 08             	mov    0x8(%ebp),%eax
    1566:	8b 00                	mov    (%eax),%eax
    1568:	83 ec 0c             	sub    $0xc,%esp
    156b:	50                   	push   %eax
    156c:	e8 fa 2e 00 00       	call   446b <strlen>
    1571:	83 c4 10             	add    $0x10,%esp
    1574:	89 c2                	mov    %eax,%edx
    1576:	8b 45 08             	mov    0x8(%ebp),%eax
    1579:	8b 00                	mov    (%eax),%eax
    157b:	83 ec 04             	sub    $0x4,%esp
    157e:	52                   	push   %edx
    157f:	50                   	push   %eax
    1580:	ff 75 f0             	pushl  -0x10(%ebp)
    1583:	e8 c5 30 00 00       	call   464d <write>
    1588:	83 c4 10             	add    $0x10,%esp
	int i = 1;
    158b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	for (; text[i] != NULL; i++)
    1592:	eb 57                	jmp    15eb <com_save+0xeb>
	{
		printf(fd, "\n");
    1594:	83 ec 08             	sub    $0x8,%esp
    1597:	68 cb 4c 00 00       	push   $0x4ccb
    159c:	ff 75 f0             	pushl  -0x10(%ebp)
    159f:	e8 00 32 00 00       	call   47a4 <printf>
    15a4:	83 c4 10             	add    $0x10,%esp
		write(fd, text[i], strlen(text[i]));
    15a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    15b1:	8b 45 08             	mov    0x8(%ebp),%eax
    15b4:	01 d0                	add    %edx,%eax
    15b6:	8b 00                	mov    (%eax),%eax
    15b8:	83 ec 0c             	sub    $0xc,%esp
    15bb:	50                   	push   %eax
    15bc:	e8 aa 2e 00 00       	call   446b <strlen>
    15c1:	83 c4 10             	add    $0x10,%esp
    15c4:	89 c1                	mov    %eax,%ecx
    15c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    15d0:	8b 45 08             	mov    0x8(%ebp),%eax
    15d3:	01 d0                	add    %edx,%eax
    15d5:	8b 00                	mov    (%eax),%eax
    15d7:	83 ec 04             	sub    $0x4,%esp
    15da:	51                   	push   %ecx
    15db:	50                   	push   %eax
    15dc:	ff 75 f0             	pushl  -0x10(%ebp)
    15df:	e8 69 30 00 00       	call   464d <write>
    15e4:	83 c4 10             	add    $0x10,%esp
		return;
	}
	//写数据
	write(fd, text[0], strlen(text[0]));
	int i = 1;
	for (; text[i] != NULL; i++)
    15e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    15eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    15f5:	8b 45 08             	mov    0x8(%ebp),%eax
    15f8:	01 d0                	add    %edx,%eax
    15fa:	8b 00                	mov    (%eax),%eax
    15fc:	85 c0                	test   %eax,%eax
    15fe:	75 94                	jne    1594 <com_save+0x94>
	{
		printf(fd, "\n");
		write(fd, text[i], strlen(text[i]));
	}
	close(fd);
    1600:	83 ec 0c             	sub    $0xc,%esp
    1603:	ff 75 f0             	pushl  -0x10(%ebp)
    1606:	e8 4a 30 00 00       	call   4655 <close>
    160b:	83 c4 10             	add    $0x10,%esp
	printf(1, ">>> \e[1;32msaved successfully\e[0m\n");
    160e:	83 ec 08             	sub    $0x8,%esp
    1611:	68 94 4d 00 00       	push   $0x4d94
    1616:	6a 01                	push   $0x1
    1618:	e8 87 31 00 00       	call   47a4 <printf>
    161d:	83 c4 10             	add    $0x10,%esp
	changed = 0;
    1620:	c7 05 80 5e 00 00 00 	movl   $0x0,0x5e80
    1627:	00 00 00 
	return;
    162a:	90                   	nop
}
    162b:	c9                   	leave  
    162c:	c3                   	ret    

0000162d <com_exit>:

void com_exit(char *text[], char *path)
{
    162d:	55                   	push   %ebp
    162e:	89 e5                	mov    %esp,%ebp
    1630:	57                   	push   %edi
    1631:	81 ec 14 01 00 00    	sub    $0x114,%esp
	//询问是否保存
	while (changed == 1)
    1637:	e9 b5 00 00 00       	jmp    16f1 <com_exit+0xc4>
	{
		printf(1, ">>> \e[1;33msave the file?\e[0m \033[1m\e[46;33my\e[0m/\033[1m\e[41;33mn\e[0m\n");
    163c:	83 ec 08             	sub    $0x8,%esp
    163f:	68 b8 4d 00 00       	push   $0x4db8
    1644:	6a 01                	push   $0x1
    1646:	e8 59 31 00 00       	call   47a4 <printf>
    164b:	83 c4 10             	add    $0x10,%esp
		char input[MAX_LINE_LENGTH] = {};
    164e:	8d 95 f4 fe ff ff    	lea    -0x10c(%ebp),%edx
    1654:	b8 00 00 00 00       	mov    $0x0,%eax
    1659:	b9 40 00 00 00       	mov    $0x40,%ecx
    165e:	89 d7                	mov    %edx,%edi
    1660:	f3 ab                	rep stos %eax,%es:(%edi)
		gets(input, MAX_LINE_LENGTH);
    1662:	83 ec 08             	sub    $0x8,%esp
    1665:	68 00 01 00 00       	push   $0x100
    166a:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
    1670:	50                   	push   %eax
    1671:	e8 69 2e 00 00       	call   44df <gets>
    1676:	83 c4 10             	add    $0x10,%esp
		input[strlen(input)-1] = '\0';
    1679:	83 ec 0c             	sub    $0xc,%esp
    167c:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
    1682:	50                   	push   %eax
    1683:	e8 e3 2d 00 00       	call   446b <strlen>
    1688:	83 c4 10             	add    $0x10,%esp
    168b:	83 e8 01             	sub    $0x1,%eax
    168e:	c6 84 05 f4 fe ff ff 	movb   $0x0,-0x10c(%ebp,%eax,1)
    1695:	00 
		if (strcmp(input, "y") == 0)
    1696:	83 ec 08             	sub    $0x8,%esp
    1699:	68 fb 4d 00 00       	push   $0x4dfb
    169e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
    16a4:	50                   	push   %eax
    16a5:	e8 82 2d 00 00       	call   442c <strcmp>
    16aa:	83 c4 10             	add    $0x10,%esp
    16ad:	85 c0                	test   %eax,%eax
    16af:	75 13                	jne    16c4 <com_exit+0x97>
			com_save(text, path);
    16b1:	83 ec 08             	sub    $0x8,%esp
    16b4:	ff 75 0c             	pushl  0xc(%ebp)
    16b7:	ff 75 08             	pushl  0x8(%ebp)
    16ba:	e8 41 fe ff ff       	call   1500 <com_save>
    16bf:	83 c4 10             	add    $0x10,%esp
    16c2:	eb 2d                	jmp    16f1 <com_exit+0xc4>
		else if(strcmp(input, "n") == 0)
    16c4:	83 ec 08             	sub    $0x8,%esp
    16c7:	68 fd 4d 00 00       	push   $0x4dfd
    16cc:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
    16d2:	50                   	push   %eax
    16d3:	e8 54 2d 00 00       	call   442c <strcmp>
    16d8:	83 c4 10             	add    $0x10,%esp
    16db:	85 c0                	test   %eax,%eax
    16dd:	74 22                	je     1701 <com_exit+0xd4>
			break;
		else
		printf(2, ">>> \e[1;31mwrong answer?\e[0m\n");
    16df:	83 ec 08             	sub    $0x8,%esp
    16e2:	68 ff 4d 00 00       	push   $0x4dff
    16e7:	6a 02                	push   $0x2
    16e9:	e8 b6 30 00 00       	call   47a4 <printf>
    16ee:	83 c4 10             	add    $0x10,%esp
}

void com_exit(char *text[], char *path)
{
	//询问是否保存
	while (changed == 1)
    16f1:	a1 80 5e 00 00       	mov    0x5e80,%eax
    16f6:	83 f8 01             	cmp    $0x1,%eax
    16f9:	0f 84 3d ff ff ff    	je     163c <com_exit+0xf>
    16ff:	eb 01                	jmp    1702 <com_exit+0xd5>
		gets(input, MAX_LINE_LENGTH);
		input[strlen(input)-1] = '\0';
		if (strcmp(input, "y") == 0)
			com_save(text, path);
		else if(strcmp(input, "n") == 0)
			break;
    1701:	90                   	nop
		else
		printf(2, ">>> \e[1;31mwrong answer?\e[0m\n");
	}
	//释放内存
	int i = 0;
    1702:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; text[i] != NULL; i++)
    1709:	eb 36                	jmp    1741 <com_exit+0x114>
	{
		free(text[i]);
    170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    170e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1715:	8b 45 08             	mov    0x8(%ebp),%eax
    1718:	01 d0                	add    %edx,%eax
    171a:	8b 00                	mov    (%eax),%eax
    171c:	83 ec 0c             	sub    $0xc,%esp
    171f:	50                   	push   %eax
    1720:	e8 10 32 00 00       	call   4935 <free>
    1725:	83 c4 10             	add    $0x10,%esp
		text[i] = 0;
    1728:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1732:	8b 45 08             	mov    0x8(%ebp),%eax
    1735:	01 d0                	add    %edx,%eax
    1737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		else
		printf(2, ">>> \e[1;31mwrong answer?\e[0m\n");
	}
	//释放内存
	int i = 0;
	for (; text[i] != NULL; i++)
    173d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1741:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1744:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    174b:	8b 45 08             	mov    0x8(%ebp),%eax
    174e:	01 d0                	add    %edx,%eax
    1750:	8b 00                	mov    (%eax),%eax
    1752:	85 c0                	test   %eax,%eax
    1754:	75 b5                	jne    170b <com_exit+0xde>
		free(text[i]);
		text[i] = 0;
	}
	//退出
	//setProgramStatus(SHELL);
	exit();
    1756:	e8 d2 2e 00 00       	call   462d <exit>

0000175b <com_create_new_file>:
}

// create new file
void com_create_new_file(char *text[], char *path){
    175b:	55                   	push   %ebp
    175c:	89 e5                	mov    %esp,%ebp
    175e:	83 ec 18             	sub    $0x18,%esp
	int fd = open(path, O_WRONLY|O_CREATE);
    1761:	83 ec 08             	sub    $0x8,%esp
    1764:	68 01 02 00 00       	push   $0x201
    1769:	ff 75 0c             	pushl  0xc(%ebp)
    176c:	e8 fc 2e 00 00       	call   466d <open>
    1771:	83 c4 10             	add    $0x10,%esp
    1774:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(fd == -1){
    1777:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    177b:	75 17                	jne    1794 <com_create_new_file+0x39>
		printf(1, ">>> \e[1;31mcreate file failed\e[0m\n");
    177d:	83 ec 08             	sub    $0x8,%esp
    1780:	68 20 4e 00 00       	push   $0x4e20
    1785:	6a 01                	push   $0x1
    1787:	e8 18 30 00 00       	call   47a4 <printf>
    178c:	83 c4 10             	add    $0x10,%esp
		exit();
    178f:	e8 99 2e 00 00       	call   462d <exit>
	}
}
    1794:	90                   	nop
    1795:	c9                   	leave  
    1796:	c3                   	ret    

00001797 <com_display_color_demo>:

// 输出颜色demo
void com_display_color_demo(){
    1797:	55                   	push   %ebp
    1798:	89 e5                	mov    %esp,%ebp
    179a:	83 ec 08             	sub    $0x8,%esp
	printf(1, ">>> \e[1;33mcolor demo:\n\e[0m");
    179d:	83 ec 08             	sub    $0x8,%esp
    17a0:	68 43 4e 00 00       	push   $0x4e43
    17a5:	6a 01                	push   $0x1
    17a7:	e8 f8 2f 00 00       	call   47a4 <printf>
    17ac:	83 c4 10             	add    $0x10,%esp
	printf(1, "----------------+-------------------------------+-----------------------\n");
    17af:	83 ec 08             	sub    $0x8,%esp
    17b2:	68 60 4e 00 00       	push   $0x4e60
    17b7:	6a 01                	push   $0x1
    17b9:	e8 e6 2f 00 00       	call   47a4 <printf>
    17be:	83 c4 10             	add    $0x10,%esp
	printf(1, "L_BLACK: 	| \e[1;30mI am happy Shaun Fong.\e[0m	|	\e[1;30m\\e[1;30m\e[0m\n");
    17c1:	83 ec 08             	sub    $0x8,%esp
    17c4:	68 ac 4e 00 00       	push   $0x4eac
    17c9:	6a 01                	push   $0x1
    17cb:	e8 d4 2f 00 00       	call   47a4 <printf>
    17d0:	83 c4 10             	add    $0x10,%esp
	printf(1, "BLACK: 		| \e[0;30mI am happy Shaun Fong.\e[0m	|	\e[0;30m\\e[0;30m\e[0m\n");
    17d3:	83 ec 08             	sub    $0x8,%esp
    17d6:	68 f4 4e 00 00       	push   $0x4ef4
    17db:	6a 01                	push   $0x1
    17dd:	e8 c2 2f 00 00       	call   47a4 <printf>
    17e2:	83 c4 10             	add    $0x10,%esp
	printf(1, "RED: 		| \e[0;31mI am happy Shaun Fong.\e[0m	|	\e[0;31m\\e[0;31m\e[0m\n");
    17e5:	83 ec 08             	sub    $0x8,%esp
    17e8:	68 38 4f 00 00       	push   $0x4f38
    17ed:	6a 01                	push   $0x1
    17ef:	e8 b0 2f 00 00       	call   47a4 <printf>
    17f4:	83 c4 10             	add    $0x10,%esp
	printf(1, "L_RED: 		| \e[1;31mI am happy Shaun Fong.\e[0m	|	\e[1;31m\\e[1;31m\e[0m\n");
    17f7:	83 ec 08             	sub    $0x8,%esp
    17fa:	68 7c 4f 00 00       	push   $0x4f7c
    17ff:	6a 01                	push   $0x1
    1801:	e8 9e 2f 00 00       	call   47a4 <printf>
    1806:	83 c4 10             	add    $0x10,%esp
	printf(1, "GREEN: 		| \e[0;32mI am happy Shaun Fong.\e[0m	|	\e[0;32m\\e[0;32m\e[0m\n");
    1809:	83 ec 08             	sub    $0x8,%esp
    180c:	68 c0 4f 00 00       	push   $0x4fc0
    1811:	6a 01                	push   $0x1
    1813:	e8 8c 2f 00 00       	call   47a4 <printf>
    1818:	83 c4 10             	add    $0x10,%esp
	printf(1, "L_GREEN: 	| \e[1;32mI am happy Shaun Fong.\e[0m	|	\e[1;32m\\e[1;32m\e[0m\n");
    181b:	83 ec 08             	sub    $0x8,%esp
    181e:	68 04 50 00 00       	push   $0x5004
    1823:	6a 01                	push   $0x1
    1825:	e8 7a 2f 00 00       	call   47a4 <printf>
    182a:	83 c4 10             	add    $0x10,%esp
	printf(1, "YELLOW:		| \e[0;33mI am happy Shaun Fong. \e[0m	|	\e[0;33m\\e[0;33m\e[0m\n");
    182d:	83 ec 08             	sub    $0x8,%esp
    1830:	68 4c 50 00 00       	push   $0x504c
    1835:	6a 01                	push   $0x1
    1837:	e8 68 2f 00 00       	call   47a4 <printf>
    183c:	83 c4 10             	add    $0x10,%esp
	printf(1, "L_YELLOW:	| \e[1;33mI am happy Shaun Fong. \e[0m	|	\e[1;33m\\e[1;33m\e[0m\n");
    183f:	83 ec 08             	sub    $0x8,%esp
    1842:	68 94 50 00 00       	push   $0x5094
    1847:	6a 01                	push   $0x1
    1849:	e8 56 2f 00 00       	call   47a4 <printf>
    184e:	83 c4 10             	add    $0x10,%esp
	printf(1, "BLUE: 		| \e[0;34mI am happy Shaun Fong. \e[0m	|	\e[0;34m\\e[0;34m\e[0m\n");
    1851:	83 ec 08             	sub    $0x8,%esp
    1854:	68 dc 50 00 00       	push   $0x50dc
    1859:	6a 01                	push   $0x1
    185b:	e8 44 2f 00 00       	call   47a4 <printf>
    1860:	83 c4 10             	add    $0x10,%esp
	printf(1, "L_BLUE:		| \e[1;34mI am happy Shaun Fong. \e[0m	|	\e[1;34m\\e[1;34m\e[0m\n");
    1863:	83 ec 08             	sub    $0x8,%esp
    1866:	68 20 51 00 00       	push   $0x5120
    186b:	6a 01                	push   $0x1
    186d:	e8 32 2f 00 00       	call   47a4 <printf>
    1872:	83 c4 10             	add    $0x10,%esp
	printf(1, "PURPLE:		| \e[0;35mI am happy Shaun Fong. \e[0m	|	\e[0;35m\\e[0;35m\e[0m\n");
    1875:	83 ec 08             	sub    $0x8,%esp
    1878:	68 68 51 00 00       	push   $0x5168
    187d:	6a 01                	push   $0x1
    187f:	e8 20 2f 00 00       	call   47a4 <printf>
    1884:	83 c4 10             	add    $0x10,%esp
	printf(1, "L_PURPLE: 	| \e[1;35mI am happy Shaun Fong. \e[0m	|	\e[1;35m\\e[1;35m\e[0m\n");
    1887:	83 ec 08             	sub    $0x8,%esp
    188a:	68 b0 51 00 00       	push   $0x51b0
    188f:	6a 01                	push   $0x1
    1891:	e8 0e 2f 00 00       	call   47a4 <printf>
    1896:	83 c4 10             	add    $0x10,%esp
	printf(1, "CYAN: 		| \e[0;36mI am happy Shaun Fong. \e[0m	|	\e[0;36m\\e[0;36m\e[0m\n");
    1899:	83 ec 08             	sub    $0x8,%esp
    189c:	68 f8 51 00 00       	push   $0x51f8
    18a1:	6a 01                	push   $0x1
    18a3:	e8 fc 2e 00 00       	call   47a4 <printf>
    18a8:	83 c4 10             	add    $0x10,%esp
	printf(1, "L_CYAN:		| \e[1;36mI am happy Shaun Fong. \e[0m	|	\e[1;36m\\e[1;36m\e[0m\n");
    18ab:	83 ec 08             	sub    $0x8,%esp
    18ae:	68 3c 52 00 00       	push   $0x523c
    18b3:	6a 01                	push   $0x1
    18b5:	e8 ea 2e 00 00       	call   47a4 <printf>
    18ba:	83 c4 10             	add    $0x10,%esp
	printf(1, "GRAY: 		| \e[0;37mI am happy Shaun Fong. \e[0m	|	\e[0;37m\\e[0;37m\e[0m\n");
    18bd:	83 ec 08             	sub    $0x8,%esp
    18c0:	68 84 52 00 00       	push   $0x5284
    18c5:	6a 01                	push   $0x1
    18c7:	e8 d8 2e 00 00       	call   47a4 <printf>
    18cc:	83 c4 10             	add    $0x10,%esp
	printf(1, "WHITE: 		| \e[1;37mI am happy Shaun Fong. \e[0m	|	\e[1;37m\\e[1;37m\e[0m\n");
    18cf:	83 ec 08             	sub    $0x8,%esp
    18d2:	68 c8 52 00 00       	push   $0x52c8
    18d7:	6a 01                	push   $0x1
    18d9:	e8 c6 2e 00 00       	call   47a4 <printf>
    18de:	83 c4 10             	add    $0x10,%esp
	printf(1, "----------------+-------------------------------+-----------------------\n");
    18e1:	83 ec 08             	sub    $0x8,%esp
    18e4:	68 60 4e 00 00       	push   $0x4e60
    18e9:	6a 01                	push   $0x1
    18eb:	e8 b4 2e 00 00       	call   47a4 <printf>
    18f0:	83 c4 10             	add    $0x10,%esp
}
    18f3:	90                   	nop
    18f4:	c9                   	leave  
    18f5:	c3                   	ret    

000018f6 <com_help>:

void com_help(char *text[])
{
    18f6:	55                   	push   %ebp
    18f7:	89 e5                	mov    %esp,%ebp
    18f9:	83 ec 08             	sub    $0x8,%esp
	printf(1, ">>> \e[1;33minstructions for use:\n\e[0m");
    18fc:	83 ec 08             	sub    $0x8,%esp
    18ff:	68 10 53 00 00       	push   $0x5310
    1904:	6a 01                	push   $0x1
    1906:	e8 99 2e 00 00       	call   47a4 <printf>
    190b:	83 c4 10             	add    $0x10,%esp
	printf(1, "--------+--------------------------------------------------------------\n");
    190e:	83 ec 08             	sub    $0x8,%esp
    1911:	68 38 53 00 00       	push   $0x5338
    1916:	6a 01                	push   $0x1
    1918:	e8 87 2e 00 00       	call   47a4 <printf>
    191d:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mins-n:\e[0m 	| insert a line after line n\n");
    1920:	83 ec 08             	sub    $0x8,%esp
    1923:	68 84 53 00 00       	push   $0x5384
    1928:	6a 01                	push   $0x1
    192a:	e8 75 2e 00 00       	call   47a4 <printf>
    192f:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mmod-n:\e[0m 	| modify line n\n");
    1932:	83 ec 08             	sub    $0x8,%esp
    1935:	68 b8 53 00 00       	push   $0x53b8
    193a:	6a 01                	push   $0x1
    193c:	e8 63 2e 00 00       	call   47a4 <printf>
    1941:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mdel-n:\e[0m 	| delete line n\n");
    1944:	83 ec 08             	sub    $0x8,%esp
    1947:	68 dc 53 00 00       	push   $0x53dc
    194c:	6a 01                	push   $0x1
    194e:	e8 51 2e 00 00       	call   47a4 <printf>
    1953:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mins:\e[0m 	| insert a line after the last line\n");
    1956:	83 ec 08             	sub    $0x8,%esp
    1959:	68 00 54 00 00       	push   $0x5400
    195e:	6a 01                	push   $0x1
    1960:	e8 3f 2e 00 00       	call   47a4 <printf>
    1965:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mmod:\e[0m 	| modify the last line\n");
    1968:	83 ec 08             	sub    $0x8,%esp
    196b:	68 38 54 00 00       	push   $0x5438
    1970:	6a 01                	push   $0x1
    1972:	e8 2d 2e 00 00       	call   47a4 <printf>
    1977:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mdel:\e[0m 	| delete the last line\n");
    197a:	83 ec 08             	sub    $0x8,%esp
    197d:	68 64 54 00 00       	push   $0x5464
    1982:	6a 01                	push   $0x1
    1984:	e8 1b 2e 00 00       	call   47a4 <printf>
    1989:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mshow:\e[0m 	| enable show current contents after executing a command.\n");
    198c:	83 ec 08             	sub    $0x8,%esp
    198f:	68 90 54 00 00       	push   $0x5490
    1994:	6a 01                	push   $0x1
    1996:	e8 09 2e 00 00       	call   47a4 <printf>
    199b:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mhide:\e[0m 	| disable show current contents after executing a command.\n");
    199e:	83 ec 08             	sub    $0x8,%esp
    19a1:	68 e0 54 00 00       	push   $0x54e0
    19a6:	6a 01                	push   $0x1
    19a8:	e8 f7 2d 00 00       	call   47a4 <printf>
    19ad:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32msave:\e[0m 	| save the file\n");
    19b0:	83 ec 08             	sub    $0x8,%esp
    19b3:	68 30 55 00 00       	push   $0x5530
    19b8:	6a 01                	push   $0x1
    19ba:	e8 e5 2d 00 00       	call   47a4 <printf>
    19bf:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mexit:\e[0m 	| exit editor\n");
    19c2:	83 ec 08             	sub    $0x8,%esp
    19c5:	68 54 55 00 00       	push   $0x5554
    19ca:	6a 01                	push   $0x1
    19cc:	e8 d3 2d 00 00       	call   47a4 <printf>
    19d1:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mhelp:\e[0m	| help info\n");
    19d4:	83 ec 08             	sub    $0x8,%esp
    19d7:	68 75 55 00 00       	push   $0x5575
    19dc:	6a 01                	push   $0x1
    19de:	e8 c1 2d 00 00       	call   47a4 <printf>
    19e3:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mdemo:\e[0m	| color demo\n");
    19e6:	83 ec 08             	sub    $0x8,%esp
    19e9:	68 94 55 00 00       	push   $0x5594
    19ee:	6a 01                	push   $0x1
    19f0:	e8 af 2d 00 00       	call   47a4 <printf>
    19f5:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32minit:\e[0m	| initial file\n");
    19f8:	83 ec 08             	sub    $0x8,%esp
    19fb:	68 b4 55 00 00       	push   $0x55b4
    1a00:	6a 01                	push   $0x1
    1a02:	e8 9d 2d 00 00       	call   47a4 <printf>
    1a07:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mdisp:\e[0m	| display with highlighting\n");
    1a0a:	83 ec 08             	sub    $0x8,%esp
    1a0d:	68 d8 55 00 00       	push   $0x55d8
    1a12:	6a 01                	push   $0x1
    1a14:	e8 8b 2d 00 00       	call   47a4 <printf>
    1a19:	83 c4 10             	add    $0x10,%esp
	printf(1, "\e[1;32mrb:\e[0m	| rollback the file\n");
    1a1c:	83 ec 08             	sub    $0x8,%esp
    1a1f:	68 08 56 00 00       	push   $0x5608
    1a24:	6a 01                	push   $0x1
    1a26:	e8 79 2d 00 00       	call   47a4 <printf>
    1a2b:	83 c4 10             	add    $0x10,%esp
	printf(1, "--------+--------------------------------------------------------------\n");
    1a2e:	83 ec 08             	sub    $0x8,%esp
    1a31:	68 38 53 00 00       	push   $0x5338
    1a36:	6a 01                	push   $0x1
    1a38:	e8 67 2d 00 00       	call   47a4 <printf>
    1a3d:	83 c4 10             	add    $0x10,%esp
}
    1a40:	90                   	nop
    1a41:	c9                   	leave  
    1a42:	c3                   	ret    

00001a43 <com_init_file>:

// 预留数据
void com_init_file(char *text[], char *path){
    1a43:	55                   	push   %ebp
    1a44:	89 e5                	mov    %esp,%ebp
    1a46:	57                   	push   %edi
    1a47:	53                   	push   %ebx
    1a48:	81 ec 10 04 00 00    	sub    $0x410,%esp
	char *buf[MAX_LINE_NUMBER] = {};
    1a4e:	8d 95 f0 fb ff ff    	lea    -0x410(%ebp),%edx
    1a54:	b8 00 00 00 00       	mov    $0x0,%eax
    1a59:	b9 00 01 00 00       	mov    $0x100,%ecx
    1a5e:	89 d7                	mov    %edx,%edi
    1a60:	f3 ab                	rep stos %eax,%es:(%edi)
	for(int i = 0; i < MAX_LINE_NUMBER; i++){
    1a62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1a69:	eb 20                	jmp    1a8b <com_init_file+0x48>
		buf[i] = malloc(MAX_LINE_LENGTH);
    1a6b:	83 ec 0c             	sub    $0xc,%esp
    1a6e:	68 00 01 00 00       	push   $0x100
    1a73:	e8 ff 2f 00 00       	call   4a77 <malloc>
    1a78:	83 c4 10             	add    $0x10,%esp
    1a7b:	89 c2                	mov    %eax,%edx
    1a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a80:	89 94 85 f0 fb ff ff 	mov    %edx,-0x410(%ebp,%eax,4)
}

// 预留数据
void com_init_file(char *text[], char *path){
	char *buf[MAX_LINE_NUMBER] = {};
	for(int i = 0; i < MAX_LINE_NUMBER; i++){
    1a87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1a8b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
    1a92:	7e d7                	jle    1a6b <com_init_file+0x28>
		buf[i] = malloc(MAX_LINE_LENGTH);
	}
	strcpy(buf[0], "// Create a NULL-terminated string by reading the provided file");
    1a94:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
    1a9a:	83 ec 08             	sub    $0x8,%esp
    1a9d:	68 2c 56 00 00       	push   $0x562c
    1aa2:	50                   	push   %eax
    1aa3:	e8 54 29 00 00       	call   43fc <strcpy>
    1aa8:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[1], "static char* readShaderSource(const char* shaderFile)");
    1aab:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
    1ab1:	83 ec 08             	sub    $0x8,%esp
    1ab4:	68 6c 56 00 00       	push   $0x566c
    1ab9:	50                   	push   %eax
    1aba:	e8 3d 29 00 00       	call   43fc <strcpy>
    1abf:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[2], "{");
    1ac2:	8b 85 f8 fb ff ff    	mov    -0x408(%ebp),%eax
    1ac8:	83 ec 08             	sub    $0x8,%esp
    1acb:	68 a2 56 00 00       	push   $0x56a2
    1ad0:	50                   	push   %eax
    1ad1:	e8 26 29 00 00       	call   43fc <strcpy>
    1ad6:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[3], "	int flag = 24;");
    1ad9:	8b 85 fc fb ff ff    	mov    -0x404(%ebp),%eax
    1adf:	83 ec 08             	sub    $0x8,%esp
    1ae2:	68 a4 56 00 00       	push   $0x56a4
    1ae7:	50                   	push   %eax
    1ae8:	e8 0f 29 00 00       	call   43fc <strcpy>
    1aed:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[4], "	double ways = 100.43;");
    1af0:	8b 85 00 fc ff ff    	mov    -0x400(%ebp),%eax
    1af6:	83 ec 08             	sub    $0x8,%esp
    1af9:	68 b4 56 00 00       	push   $0x56b4
    1afe:	50                   	push   %eax
    1aff:	e8 f8 28 00 00       	call   43fc <strcpy>
    1b04:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[5], "	if ( fp == NULL ) {");
    1b07:	8b 85 04 fc ff ff    	mov    -0x3fc(%ebp),%eax
    1b0d:	83 ec 08             	sub    $0x8,%esp
    1b10:	68 cb 56 00 00       	push   $0x56cb
    1b15:	50                   	push   %eax
    1b16:	e8 e1 28 00 00       	call   43fc <strcpy>
    1b1b:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[6], "		return NULL;");
    1b1e:	8b 85 08 fc ff ff    	mov    -0x3f8(%ebp),%eax
    1b24:	83 ec 08             	sub    $0x8,%esp
    1b27:	68 e0 56 00 00       	push   $0x56e0
    1b2c:	50                   	push   %eax
    1b2d:	e8 ca 28 00 00       	call   43fc <strcpy>
    1b32:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[7], "	}");
    1b35:	8b 85 0c fc ff ff    	mov    -0x3f4(%ebp),%eax
    1b3b:	83 ec 08             	sub    $0x8,%esp
    1b3e:	68 ef 56 00 00       	push   $0x56ef
    1b43:	50                   	push   %eax
    1b44:	e8 b3 28 00 00       	call   43fc <strcpy>
    1b49:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[8], "	fseek(fp, 0L, SEEK_END);	//search something");
    1b4c:	8b 85 10 fc ff ff    	mov    -0x3f0(%ebp),%eax
    1b52:	83 ec 08             	sub    $0x8,%esp
    1b55:	68 f4 56 00 00       	push   $0x56f4
    1b5a:	50                   	push   %eax
    1b5b:	e8 9c 28 00 00       	call   43fc <strcpy>
    1b60:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[9], "	long size = ftell(fp);");
    1b63:	8b 85 14 fc ff ff    	mov    -0x3ec(%ebp),%eax
    1b69:	83 ec 08             	sub    $0x8,%esp
    1b6c:	68 21 57 00 00       	push   $0x5721
    1b71:	50                   	push   %eax
    1b72:	e8 85 28 00 00       	call   43fc <strcpy>
    1b77:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[10], "	fseek(fp, 0L, SEEK_SET);");
    1b7a:	8b 85 18 fc ff ff    	mov    -0x3e8(%ebp),%eax
    1b80:	83 ec 08             	sub    $0x8,%esp
    1b83:	68 39 57 00 00       	push   $0x5739
    1b88:	50                   	push   %eax
    1b89:	e8 6e 28 00 00       	call   43fc <strcpy>
    1b8e:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[11], "	char* buf = new char[size + 1];");
    1b91:	8b 85 1c fc ff ff    	mov    -0x3e4(%ebp),%eax
    1b97:	83 ec 08             	sub    $0x8,%esp
    1b9a:	68 54 57 00 00       	push   $0x5754
    1b9f:	50                   	push   %eax
    1ba0:	e8 57 28 00 00       	call   43fc <strcpy>
    1ba5:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[12], "	memset(buf, 0, size + 1);	//Initiate every bit of buf as 0");
    1ba8:	8b 85 20 fc ff ff    	mov    -0x3e0(%ebp),%eax
    1bae:	83 ec 08             	sub    $0x8,%esp
    1bb1:	68 78 57 00 00       	push   $0x5778
    1bb6:	50                   	push   %eax
    1bb7:	e8 40 28 00 00       	call   43fc <strcpy>
    1bbc:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[13], "	fread(buf, 1, size, fp);");
    1bbf:	8b 85 24 fc ff ff    	mov    -0x3dc(%ebp),%eax
    1bc5:	83 ec 08             	sub    $0x8,%esp
    1bc8:	68 b4 57 00 00       	push   $0x57b4
    1bcd:	50                   	push   %eax
    1bce:	e8 29 28 00 00       	call   43fc <strcpy>
    1bd3:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[14], "	buf[size] = '\\0';");
    1bd6:	8b 85 28 fc ff ff    	mov    -0x3d8(%ebp),%eax
    1bdc:	83 ec 08             	sub    $0x8,%esp
    1bdf:	68 ce 57 00 00       	push   $0x57ce
    1be4:	50                   	push   %eax
    1be5:	e8 12 28 00 00       	call   43fc <strcpy>
    1bea:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[15], "	fclose(fp);			// close 'fp' stream.");
    1bed:	8b 85 2c fc ff ff    	mov    -0x3d4(%ebp),%eax
    1bf3:	83 ec 08             	sub    $0x8,%esp
    1bf6:	68 e4 57 00 00       	push   $0x57e4
    1bfb:	50                   	push   %eax
    1bfc:	e8 fb 27 00 00       	call   43fc <strcpy>
    1c01:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[16], "	return buf;");
    1c04:	8b 85 30 fc ff ff    	mov    -0x3d0(%ebp),%eax
    1c0a:	83 ec 08             	sub    $0x8,%esp
    1c0d:	68 09 58 00 00       	push   $0x5809
    1c12:	50                   	push   %eax
    1c13:	e8 e4 27 00 00       	call   43fc <strcpy>
    1c18:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[17], "	while (flag != 0){");
    1c1b:	8b 85 34 fc ff ff    	mov    -0x3cc(%ebp),%eax
    1c21:	83 ec 08             	sub    $0x8,%esp
    1c24:	68 16 58 00 00       	push   $0x5816
    1c29:	50                   	push   %eax
    1c2a:	e8 cd 27 00 00       	call   43fc <strcpy>
    1c2f:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[18], "		ways = ways + ways * 12;");
    1c32:	8b 85 38 fc ff ff    	mov    -0x3c8(%ebp),%eax
    1c38:	83 ec 08             	sub    $0x8,%esp
    1c3b:	68 2a 58 00 00       	push   $0x582a
    1c40:	50                   	push   %eax
    1c41:	e8 b6 27 00 00       	call   43fc <strcpy>
    1c46:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[19], "	}");
    1c49:	8b 85 3c fc ff ff    	mov    -0x3c4(%ebp),%eax
    1c4f:	83 ec 08             	sub    $0x8,%esp
    1c52:	68 ef 56 00 00       	push   $0x56ef
    1c57:	50                   	push   %eax
    1c58:	e8 9f 27 00 00       	call   43fc <strcpy>
    1c5d:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[20], "	for (int a = 10; a >= 0; a--){");
    1c60:	8b 85 40 fc ff ff    	mov    -0x3c0(%ebp),%eax
    1c66:	83 ec 08             	sub    $0x8,%esp
    1c69:	68 48 58 00 00       	push   $0x5848
    1c6e:	50                   	push   %eax
    1c6f:	e8 88 27 00 00       	call   43fc <strcpy>
    1c74:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[21], "		float tmp_value = 20.5;");
    1c77:	8b 85 44 fc ff ff    	mov    -0x3bc(%ebp),%eax
    1c7d:	83 ec 08             	sub    $0x8,%esp
    1c80:	68 68 58 00 00       	push   $0x5868
    1c85:	50                   	push   %eax
    1c86:	e8 71 27 00 00       	call   43fc <strcpy>
    1c8b:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[22], "		printf(\"the real value of variable tmp_value is:%f\", tmp_value);");
    1c8e:	8b 85 48 fc ff ff    	mov    -0x3b8(%ebp),%eax
    1c94:	83 ec 08             	sub    $0x8,%esp
    1c97:	68 84 58 00 00       	push   $0x5884
    1c9c:	50                   	push   %eax
    1c9d:	e8 5a 27 00 00       	call   43fc <strcpy>
    1ca2:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[23], "		continue;");
    1ca5:	8b 85 4c fc ff ff    	mov    -0x3b4(%ebp),%eax
    1cab:	83 ec 08             	sub    $0x8,%esp
    1cae:	68 c7 58 00 00       	push   $0x58c7
    1cb3:	50                   	push   %eax
    1cb4:	e8 43 27 00 00       	call   43fc <strcpy>
    1cb9:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[24], "	}");
    1cbc:	8b 85 50 fc ff ff    	mov    -0x3b0(%ebp),%eax
    1cc2:	83 ec 08             	sub    $0x8,%esp
    1cc5:	68 ef 56 00 00       	push   $0x56ef
    1cca:	50                   	push   %eax
    1ccb:	e8 2c 27 00 00       	call   43fc <strcpy>
    1cd0:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[25], "}");
    1cd3:	8b 85 54 fc ff ff    	mov    -0x3ac(%ebp),%eax
    1cd9:	83 ec 08             	sub    $0x8,%esp
    1cdc:	68 d3 58 00 00       	push   $0x58d3
    1ce1:	50                   	push   %eax
    1ce2:	e8 15 27 00 00       	call   43fc <strcpy>
    1ce7:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[26], "// demo | made by Shaun Fong");
    1cea:	8b 85 58 fc ff ff    	mov    -0x3a8(%ebp),%eax
    1cf0:	83 ec 08             	sub    $0x8,%esp
    1cf3:	68 d5 58 00 00       	push   $0x58d5
    1cf8:	50                   	push   %eax
    1cf9:	e8 fe 26 00 00       	call   43fc <strcpy>
    1cfe:	83 c4 10             	add    $0x10,%esp

	// 将数据覆盖进text的空间中
	for(int i = 0; i <= 26; i++){
    1d01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1d08:	eb 4e                	jmp    1d58 <com_init_file+0x315>
		text[i] = malloc(MAX_LINE_LENGTH);
    1d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1d14:	8b 45 08             	mov    0x8(%ebp),%eax
    1d17:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
    1d1a:	83 ec 0c             	sub    $0xc,%esp
    1d1d:	68 00 01 00 00       	push   $0x100
    1d22:	e8 50 2d 00 00       	call   4a77 <malloc>
    1d27:	83 c4 10             	add    $0x10,%esp
    1d2a:	89 03                	mov    %eax,(%ebx)
		strcpy(text[i], buf[i]);
    1d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d2f:	8b 94 85 f0 fb ff ff 	mov    -0x410(%ebp,%eax,4),%edx
    1d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d39:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    1d40:	8b 45 08             	mov    0x8(%ebp),%eax
    1d43:	01 c8                	add    %ecx,%eax
    1d45:	8b 00                	mov    (%eax),%eax
    1d47:	83 ec 08             	sub    $0x8,%esp
    1d4a:	52                   	push   %edx
    1d4b:	50                   	push   %eax
    1d4c:	e8 ab 26 00 00       	call   43fc <strcpy>
    1d51:	83 c4 10             	add    $0x10,%esp
	strcpy(buf[24], "	}");
	strcpy(buf[25], "}");
	strcpy(buf[26], "// demo | made by Shaun Fong");

	// 将数据覆盖进text的空间中
	for(int i = 0; i <= 26; i++){
    1d54:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1d58:	83 7d f0 1a          	cmpl   $0x1a,-0x10(%ebp)
    1d5c:	7e ac                	jle    1d0a <com_init_file+0x2c7>
		text[i] = malloc(MAX_LINE_LENGTH);
		strcpy(text[i], buf[i]);
	}

	line_number = get_line_number(text);
    1d5e:	83 ec 0c             	sub    $0xc,%esp
    1d61:	ff 75 08             	pushl  0x8(%ebp)
    1d64:	e8 15 ed ff ff       	call   a7e <get_line_number>
    1d69:	83 c4 10             	add    $0x10,%esp
    1d6c:	a3 84 5e 00 00       	mov    %eax,0x5e84

	show_text_syntax_highlighting(text);
    1d71:	83 ec 0c             	sub    $0xc,%esp
    1d74:	ff 75 08             	pushl  0x8(%ebp)
    1d77:	e8 15 00 00 00       	call   1d91 <show_text_syntax_highlighting>
    1d7c:	83 c4 10             	add    $0x10,%esp

	changed = 1;
    1d7f:	c7 05 80 5e 00 00 01 	movl   $0x1,0x5e80
    1d86:	00 00 00 
}
    1d89:	90                   	nop
    1d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1d8d:	5b                   	pop    %ebx
    1d8e:	5f                   	pop    %edi
    1d8f:	5d                   	pop    %ebp
    1d90:	c3                   	ret    

00001d91 <show_text_syntax_highlighting>:

// 语法高亮
void show_text_syntax_highlighting(char *text[]){
    1d91:	55                   	push   %ebp
    1d92:	89 e5                	mov    %esp,%ebp
    1d94:	56                   	push   %esi
    1d95:	53                   	push   %ebx
    1d96:	83 ec 30             	sub    $0x30,%esp
	printf(1, ">>> \033[1m\e[45;33mthe contents of the file are:\e[0m\n");
    1d99:	83 ec 08             	sub    $0x8,%esp
    1d9c:	68 98 4c 00 00       	push   $0x4c98
    1da1:	6a 01                	push   $0x1
    1da3:	e8 fc 29 00 00       	call   47a4 <printf>
    1da8:	83 c4 10             	add    $0x10,%esp
	printf(1, "\n");
    1dab:	83 ec 08             	sub    $0x8,%esp
    1dae:	68 cb 4c 00 00       	push   $0x4ccb
    1db3:	6a 01                	push   $0x1
    1db5:	e8 ea 29 00 00       	call   47a4 <printf>
    1dba:	83 c4 10             	add    $0x10,%esp
	int j = 0;
    1dbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (; text[j] != NULL; j++){
    1dc4:	e9 47 23 00 00       	jmp    4110 <show_text_syntax_highlighting+0x237f>
		printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m", (j+1)/100, ((j+1)%100)/10, (j+1)%10);
    1dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1dcc:	8d 58 01             	lea    0x1(%eax),%ebx
    1dcf:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1dd4:	89 d8                	mov    %ebx,%eax
    1dd6:	f7 ea                	imul   %edx
    1dd8:	c1 fa 02             	sar    $0x2,%edx
    1ddb:	89 d8                	mov    %ebx,%eax
    1ddd:	c1 f8 1f             	sar    $0x1f,%eax
    1de0:	89 d1                	mov    %edx,%ecx
    1de2:	29 c1                	sub    %eax,%ecx
    1de4:	89 c8                	mov    %ecx,%eax
    1de6:	c1 e0 02             	shl    $0x2,%eax
    1de9:	01 c8                	add    %ecx,%eax
    1deb:	01 c0                	add    %eax,%eax
    1ded:	89 d9                	mov    %ebx,%ecx
    1def:	29 c1                	sub    %eax,%ecx
    1df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1df4:	8d 70 01             	lea    0x1(%eax),%esi
    1df7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    1dfc:	89 f0                	mov    %esi,%eax
    1dfe:	f7 ea                	imul   %edx
    1e00:	c1 fa 05             	sar    $0x5,%edx
    1e03:	89 f0                	mov    %esi,%eax
    1e05:	c1 f8 1f             	sar    $0x1f,%eax
    1e08:	89 d3                	mov    %edx,%ebx
    1e0a:	29 c3                	sub    %eax,%ebx
    1e0c:	6b c3 64             	imul   $0x64,%ebx,%eax
    1e0f:	29 c6                	sub    %eax,%esi
    1e11:	89 f3                	mov    %esi,%ebx
    1e13:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1e18:	89 d8                	mov    %ebx,%eax
    1e1a:	f7 ea                	imul   %edx
    1e1c:	c1 fa 02             	sar    $0x2,%edx
    1e1f:	89 d8                	mov    %ebx,%eax
    1e21:	c1 f8 1f             	sar    $0x1f,%eax
    1e24:	89 d6                	mov    %edx,%esi
    1e26:	29 c6                	sub    %eax,%esi
    1e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e2b:	8d 58 01             	lea    0x1(%eax),%ebx
    1e2e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    1e33:	89 d8                	mov    %ebx,%eax
    1e35:	f7 ea                	imul   %edx
    1e37:	c1 fa 05             	sar    $0x5,%edx
    1e3a:	89 d8                	mov    %ebx,%eax
    1e3c:	c1 f8 1f             	sar    $0x1f,%eax
    1e3f:	29 c2                	sub    %eax,%edx
    1e41:	89 d0                	mov    %edx,%eax
    1e43:	83 ec 0c             	sub    $0xc,%esp
    1e46:	51                   	push   %ecx
    1e47:	56                   	push   %esi
    1e48:	50                   	push   %eax
    1e49:	68 f2 58 00 00       	push   $0x58f2
    1e4e:	6a 01                	push   $0x1
    1e50:	e8 4f 29 00 00       	call   47a4 <printf>
    1e55:	83 c4 20             	add    $0x20,%esp
		
		// 寻找第一个非空字符
		int pos = 0;
    1e58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(int a = 0; a < MAX_LINE_LENGTH; a++){
    1e5f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1e66:	eb 29                	jmp    1e91 <show_text_syntax_highlighting+0x100>
			if(text[j][a] != ' '){
    1e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1e72:	8b 45 08             	mov    0x8(%ebp),%eax
    1e75:	01 d0                	add    %edx,%eax
    1e77:	8b 10                	mov    (%eax),%edx
    1e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1e7c:	01 d0                	add    %edx,%eax
    1e7e:	0f b6 00             	movzbl (%eax),%eax
    1e81:	3c 20                	cmp    $0x20,%al
    1e83:	74 08                	je     1e8d <show_text_syntax_highlighting+0xfc>
				pos = a;
    1e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
    1e8b:	eb 0d                	jmp    1e9a <show_text_syntax_highlighting+0x109>
	for (; text[j] != NULL; j++){
		printf(1, "\e[1;30m%d%d%d\e[0m\e[0;32m|\e[0m", (j+1)/100, ((j+1)%100)/10, (j+1)%10);
		
		// 寻找第一个非空字符
		int pos = 0;
		for(int a = 0; a < MAX_LINE_LENGTH; a++){
    1e8d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    1e91:	81 7d ec ff 00 00 00 	cmpl   $0xff,-0x14(%ebp)
    1e98:	7e ce                	jle    1e68 <show_text_syntax_highlighting+0xd7>
				pos = a;
				break;
			}
		}

		if(strcmp(text[j], "\n") == 0){
    1e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1ea4:	8b 45 08             	mov    0x8(%ebp),%eax
    1ea7:	01 d0                	add    %edx,%eax
    1ea9:	8b 00                	mov    (%eax),%eax
    1eab:	83 ec 08             	sub    $0x8,%esp
    1eae:	68 cb 4c 00 00       	push   $0x4ccb
    1eb3:	50                   	push   %eax
    1eb4:	e8 73 25 00 00       	call   442c <strcmp>
    1eb9:	83 c4 10             	add    $0x10,%esp
    1ebc:	85 c0                	test   %eax,%eax
    1ebe:	75 17                	jne    1ed7 <show_text_syntax_highlighting+0x146>
			printf(1, "\n");
    1ec0:	83 ec 08             	sub    $0x8,%esp
    1ec3:	68 cb 4c 00 00       	push   $0x4ccb
    1ec8:	6a 01                	push   $0x1
    1eca:	e8 d5 28 00 00       	call   47a4 <printf>
    1ecf:	83 c4 10             	add    $0x10,%esp
    1ed2:	e9 35 22 00 00       	jmp    410c <show_text_syntax_highlighting+0x237b>
		}
		else if(text[j][pos] == '/' && text[j][pos+1] == '/'){
    1ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1eda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1ee1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ee4:	01 d0                	add    %edx,%eax
    1ee6:	8b 10                	mov    (%eax),%edx
    1ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1eeb:	01 d0                	add    %edx,%eax
    1eed:	0f b6 00             	movzbl (%eax),%eax
    1ef0:	3c 2f                	cmp    $0x2f,%al
    1ef2:	75 49                	jne    1f3d <show_text_syntax_highlighting+0x1ac>
    1ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ef7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1efe:	8b 45 08             	mov    0x8(%ebp),%eax
    1f01:	01 d0                	add    %edx,%eax
    1f03:	8b 00                	mov    (%eax),%eax
    1f05:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1f08:	83 c2 01             	add    $0x1,%edx
    1f0b:	01 d0                	add    %edx,%eax
    1f0d:	0f b6 00             	movzbl (%eax),%eax
    1f10:	3c 2f                	cmp    $0x2f,%al
    1f12:	75 29                	jne    1f3d <show_text_syntax_highlighting+0x1ac>
			printf(1, "\e[1;32m%s\n\e[0m", text[j]);
    1f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1f1e:	8b 45 08             	mov    0x8(%ebp),%eax
    1f21:	01 d0                	add    %edx,%eax
    1f23:	8b 00                	mov    (%eax),%eax
    1f25:	83 ec 04             	sub    $0x4,%esp
    1f28:	50                   	push   %eax
    1f29:	68 10 59 00 00       	push   $0x5910
    1f2e:	6a 01                	push   $0x1
    1f30:	e8 6f 28 00 00       	call   47a4 <printf>
    1f35:	83 c4 10             	add    $0x10,%esp
    1f38:	e9 cf 21 00 00       	jmp    410c <show_text_syntax_highlighting+0x237b>
		}
		else{
			int mark = 0;
    1f3d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
			int flag_annotation = 0;
    1f44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			while(mark < MAX_LINE_LENGTH && text[j][mark] != NULL){
    1f4b:	e9 80 21 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				// do something with 'mark' and print all the statements 
				// by the way of one letter by one letter
				// judge annotation
				if(flag_annotation){
    1f50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1f54:	74 3a                	je     1f90 <show_text_syntax_highlighting+0x1ff>
					printf(1, "\e[1;32m%c\e[0m", text[j][mark++]);
    1f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1f60:	8b 45 08             	mov    0x8(%ebp),%eax
    1f63:	01 d0                	add    %edx,%eax
    1f65:	8b 08                	mov    (%eax),%ecx
    1f67:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1f6a:	8d 50 01             	lea    0x1(%eax),%edx
    1f6d:	89 55 e8             	mov    %edx,-0x18(%ebp)
    1f70:	01 c8                	add    %ecx,%eax
    1f72:	0f b6 00             	movzbl (%eax),%eax
    1f75:	0f be c0             	movsbl %al,%eax
    1f78:	83 ec 04             	sub    $0x4,%esp
    1f7b:	50                   	push   %eax
    1f7c:	68 1f 59 00 00       	push   $0x591f
    1f81:	6a 01                	push   $0x1
    1f83:	e8 1c 28 00 00       	call   47a4 <printf>
    1f88:	83 c4 10             	add    $0x10,%esp
					//mark++;
					continue;
    1f8b:	e9 40 21 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}

				// numbers
				if(text[j][mark] >= '0' && text[j][mark] <= '9'){
    1f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f93:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1f9a:	8b 45 08             	mov    0x8(%ebp),%eax
    1f9d:	01 d0                	add    %edx,%eax
    1f9f:	8b 10                	mov    (%eax),%edx
    1fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1fa4:	01 d0                	add    %edx,%eax
    1fa6:	0f b6 00             	movzbl (%eax),%eax
    1fa9:	3c 2f                	cmp    $0x2f,%al
    1fab:	7e 55                	jle    2002 <show_text_syntax_highlighting+0x271>
    1fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1fb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1fb7:	8b 45 08             	mov    0x8(%ebp),%eax
    1fba:	01 d0                	add    %edx,%eax
    1fbc:	8b 10                	mov    (%eax),%edx
    1fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1fc1:	01 d0                	add    %edx,%eax
    1fc3:	0f b6 00             	movzbl (%eax),%eax
    1fc6:	3c 39                	cmp    $0x39,%al
    1fc8:	7f 38                	jg     2002 <show_text_syntax_highlighting+0x271>
					printf(1, "\033[0;33m%c\033[0m", text[j][mark]);
    1fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1fcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1fd4:	8b 45 08             	mov    0x8(%ebp),%eax
    1fd7:	01 d0                	add    %edx,%eax
    1fd9:	8b 10                	mov    (%eax),%edx
    1fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1fde:	01 d0                	add    %edx,%eax
    1fe0:	0f b6 00             	movzbl (%eax),%eax
    1fe3:	0f be c0             	movsbl %al,%eax
    1fe6:	83 ec 04             	sub    $0x4,%esp
    1fe9:	50                   	push   %eax
    1fea:	68 2d 59 00 00       	push   $0x592d
    1fef:	6a 01                	push   $0x1
    1ff1:	e8 ae 27 00 00       	call   47a4 <printf>
    1ff6:	83 c4 10             	add    $0x10,%esp
					mark++;
    1ff9:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    1ffd:	e9 ce 20 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// printf
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'p' && text[j][mark+1] == 'r' 
    2002:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2005:	83 c0 05             	add    $0x5,%eax
    2008:	3d ff 00 00 00       	cmp    $0xff,%eax
    200d:	0f 8f 07 02 00 00    	jg     221a <show_text_syntax_highlighting+0x489>
    2013:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2016:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    201d:	8b 45 08             	mov    0x8(%ebp),%eax
    2020:	01 d0                	add    %edx,%eax
    2022:	8b 10                	mov    (%eax),%edx
    2024:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2027:	01 d0                	add    %edx,%eax
    2029:	0f b6 00             	movzbl (%eax),%eax
    202c:	3c 70                	cmp    $0x70,%al
    202e:	0f 85 e6 01 00 00    	jne    221a <show_text_syntax_highlighting+0x489>
    2034:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2037:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    203e:	8b 45 08             	mov    0x8(%ebp),%eax
    2041:	01 d0                	add    %edx,%eax
    2043:	8b 00                	mov    (%eax),%eax
    2045:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2048:	83 c2 01             	add    $0x1,%edx
    204b:	01 d0                	add    %edx,%eax
    204d:	0f b6 00             	movzbl (%eax),%eax
    2050:	3c 72                	cmp    $0x72,%al
    2052:	0f 85 c2 01 00 00    	jne    221a <show_text_syntax_highlighting+0x489>
					&& text[j][mark+2] == 'i' && text[j][mark+3] == 'n' && text[j][mark+4] == 't' 
    2058:	8b 45 f4             	mov    -0xc(%ebp),%eax
    205b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2062:	8b 45 08             	mov    0x8(%ebp),%eax
    2065:	01 d0                	add    %edx,%eax
    2067:	8b 00                	mov    (%eax),%eax
    2069:	8b 55 e8             	mov    -0x18(%ebp),%edx
    206c:	83 c2 02             	add    $0x2,%edx
    206f:	01 d0                	add    %edx,%eax
    2071:	0f b6 00             	movzbl (%eax),%eax
    2074:	3c 69                	cmp    $0x69,%al
    2076:	0f 85 9e 01 00 00    	jne    221a <show_text_syntax_highlighting+0x489>
    207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    207f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2086:	8b 45 08             	mov    0x8(%ebp),%eax
    2089:	01 d0                	add    %edx,%eax
    208b:	8b 00                	mov    (%eax),%eax
    208d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2090:	83 c2 03             	add    $0x3,%edx
    2093:	01 d0                	add    %edx,%eax
    2095:	0f b6 00             	movzbl (%eax),%eax
    2098:	3c 6e                	cmp    $0x6e,%al
    209a:	0f 85 7a 01 00 00    	jne    221a <show_text_syntax_highlighting+0x489>
    20a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    20aa:	8b 45 08             	mov    0x8(%ebp),%eax
    20ad:	01 d0                	add    %edx,%eax
    20af:	8b 00                	mov    (%eax),%eax
    20b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
    20b4:	83 c2 04             	add    $0x4,%edx
    20b7:	01 d0                	add    %edx,%eax
    20b9:	0f b6 00             	movzbl (%eax),%eax
    20bc:	3c 74                	cmp    $0x74,%al
    20be:	0f 85 56 01 00 00    	jne    221a <show_text_syntax_highlighting+0x489>
					&& text[j][mark+5] == 'f'){
    20c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    20ce:	8b 45 08             	mov    0x8(%ebp),%eax
    20d1:	01 d0                	add    %edx,%eax
    20d3:	8b 00                	mov    (%eax),%eax
    20d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    20d8:	83 c2 05             	add    $0x5,%edx
    20db:	01 d0                	add    %edx,%eax
    20dd:	0f b6 00             	movzbl (%eax),%eax
    20e0:	3c 66                	cmp    $0x66,%al
    20e2:	0f 85 32 01 00 00    	jne    221a <show_text_syntax_highlighting+0x489>
					printf(1, "\e[1;36m%c\e[0m", text[j][mark]);
    20e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    20f2:	8b 45 08             	mov    0x8(%ebp),%eax
    20f5:	01 d0                	add    %edx,%eax
    20f7:	8b 10                	mov    (%eax),%edx
    20f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    20fc:	01 d0                	add    %edx,%eax
    20fe:	0f b6 00             	movzbl (%eax),%eax
    2101:	0f be c0             	movsbl %al,%eax
    2104:	83 ec 04             	sub    $0x4,%esp
    2107:	50                   	push   %eax
    2108:	68 3b 59 00 00       	push   $0x593b
    210d:	6a 01                	push   $0x1
    210f:	e8 90 26 00 00       	call   47a4 <printf>
    2114:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+1]);
    2117:	8b 45 f4             	mov    -0xc(%ebp),%eax
    211a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2121:	8b 45 08             	mov    0x8(%ebp),%eax
    2124:	01 d0                	add    %edx,%eax
    2126:	8b 00                	mov    (%eax),%eax
    2128:	8b 55 e8             	mov    -0x18(%ebp),%edx
    212b:	83 c2 01             	add    $0x1,%edx
    212e:	01 d0                	add    %edx,%eax
    2130:	0f b6 00             	movzbl (%eax),%eax
    2133:	0f be c0             	movsbl %al,%eax
    2136:	83 ec 04             	sub    $0x4,%esp
    2139:	50                   	push   %eax
    213a:	68 3b 59 00 00       	push   $0x593b
    213f:	6a 01                	push   $0x1
    2141:	e8 5e 26 00 00       	call   47a4 <printf>
    2146:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+2]);
    2149:	8b 45 f4             	mov    -0xc(%ebp),%eax
    214c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2153:	8b 45 08             	mov    0x8(%ebp),%eax
    2156:	01 d0                	add    %edx,%eax
    2158:	8b 00                	mov    (%eax),%eax
    215a:	8b 55 e8             	mov    -0x18(%ebp),%edx
    215d:	83 c2 02             	add    $0x2,%edx
    2160:	01 d0                	add    %edx,%eax
    2162:	0f b6 00             	movzbl (%eax),%eax
    2165:	0f be c0             	movsbl %al,%eax
    2168:	83 ec 04             	sub    $0x4,%esp
    216b:	50                   	push   %eax
    216c:	68 3b 59 00 00       	push   $0x593b
    2171:	6a 01                	push   $0x1
    2173:	e8 2c 26 00 00       	call   47a4 <printf>
    2178:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+3]);
    217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    217e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2185:	8b 45 08             	mov    0x8(%ebp),%eax
    2188:	01 d0                	add    %edx,%eax
    218a:	8b 00                	mov    (%eax),%eax
    218c:	8b 55 e8             	mov    -0x18(%ebp),%edx
    218f:	83 c2 03             	add    $0x3,%edx
    2192:	01 d0                	add    %edx,%eax
    2194:	0f b6 00             	movzbl (%eax),%eax
    2197:	0f be c0             	movsbl %al,%eax
    219a:	83 ec 04             	sub    $0x4,%esp
    219d:	50                   	push   %eax
    219e:	68 3b 59 00 00       	push   $0x593b
    21a3:	6a 01                	push   $0x1
    21a5:	e8 fa 25 00 00       	call   47a4 <printf>
    21aa:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+4]);
    21ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    21b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    21b7:	8b 45 08             	mov    0x8(%ebp),%eax
    21ba:	01 d0                	add    %edx,%eax
    21bc:	8b 00                	mov    (%eax),%eax
    21be:	8b 55 e8             	mov    -0x18(%ebp),%edx
    21c1:	83 c2 04             	add    $0x4,%edx
    21c4:	01 d0                	add    %edx,%eax
    21c6:	0f b6 00             	movzbl (%eax),%eax
    21c9:	0f be c0             	movsbl %al,%eax
    21cc:	83 ec 04             	sub    $0x4,%esp
    21cf:	50                   	push   %eax
    21d0:	68 3b 59 00 00       	push   $0x593b
    21d5:	6a 01                	push   $0x1
    21d7:	e8 c8 25 00 00       	call   47a4 <printf>
    21dc:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+5]);
    21df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    21e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    21e9:	8b 45 08             	mov    0x8(%ebp),%eax
    21ec:	01 d0                	add    %edx,%eax
    21ee:	8b 00                	mov    (%eax),%eax
    21f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
    21f3:	83 c2 05             	add    $0x5,%edx
    21f6:	01 d0                	add    %edx,%eax
    21f8:	0f b6 00             	movzbl (%eax),%eax
    21fb:	0f be c0             	movsbl %al,%eax
    21fe:	83 ec 04             	sub    $0x4,%esp
    2201:	50                   	push   %eax
    2202:	68 3b 59 00 00       	push   $0x593b
    2207:	6a 01                	push   $0x1
    2209:	e8 96 25 00 00       	call   47a4 <printf>
    220e:	83 c4 10             	add    $0x10,%esp
					mark = mark + 6;
    2211:	83 45 e8 06          	addl   $0x6,-0x18(%ebp)
    2215:	e9 b6 1e 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// int
				else if((mark+2)<MAX_LINE_LENGTH && text[j][mark] == 'i' && text[j][mark+1] == 'n' 
    221a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    221d:	83 c0 02             	add    $0x2,%eax
    2220:	3d ff 00 00 00       	cmp    $0xff,%eax
    2225:	0f 8f 05 01 00 00    	jg     2330 <show_text_syntax_highlighting+0x59f>
    222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    222e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2235:	8b 45 08             	mov    0x8(%ebp),%eax
    2238:	01 d0                	add    %edx,%eax
    223a:	8b 10                	mov    (%eax),%edx
    223c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    223f:	01 d0                	add    %edx,%eax
    2241:	0f b6 00             	movzbl (%eax),%eax
    2244:	3c 69                	cmp    $0x69,%al
    2246:	0f 85 e4 00 00 00    	jne    2330 <show_text_syntax_highlighting+0x59f>
    224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    224f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2256:	8b 45 08             	mov    0x8(%ebp),%eax
    2259:	01 d0                	add    %edx,%eax
    225b:	8b 00                	mov    (%eax),%eax
    225d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2260:	83 c2 01             	add    $0x1,%edx
    2263:	01 d0                	add    %edx,%eax
    2265:	0f b6 00             	movzbl (%eax),%eax
    2268:	3c 6e                	cmp    $0x6e,%al
    226a:	0f 85 c0 00 00 00    	jne    2330 <show_text_syntax_highlighting+0x59f>
					&& text[j][mark+2] == 't'){
    2270:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    227a:	8b 45 08             	mov    0x8(%ebp),%eax
    227d:	01 d0                	add    %edx,%eax
    227f:	8b 00                	mov    (%eax),%eax
    2281:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2284:	83 c2 02             	add    $0x2,%edx
    2287:	01 d0                	add    %edx,%eax
    2289:	0f b6 00             	movzbl (%eax),%eax
    228c:	3c 74                	cmp    $0x74,%al
    228e:	0f 85 9c 00 00 00    	jne    2330 <show_text_syntax_highlighting+0x59f>
					// highlighting 'int' string
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    2294:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2297:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    229e:	8b 45 08             	mov    0x8(%ebp),%eax
    22a1:	01 d0                	add    %edx,%eax
    22a3:	8b 10                	mov    (%eax),%edx
    22a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    22a8:	01 d0                	add    %edx,%eax
    22aa:	0f b6 00             	movzbl (%eax),%eax
    22ad:	0f be c0             	movsbl %al,%eax
    22b0:	83 ec 04             	sub    $0x4,%esp
    22b3:	50                   	push   %eax
    22b4:	68 49 59 00 00       	push   $0x5949
    22b9:	6a 01                	push   $0x1
    22bb:	e8 e4 24 00 00       	call   47a4 <printf>
    22c0:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    22c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    22cd:	8b 45 08             	mov    0x8(%ebp),%eax
    22d0:	01 d0                	add    %edx,%eax
    22d2:	8b 00                	mov    (%eax),%eax
    22d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
    22d7:	83 c2 01             	add    $0x1,%edx
    22da:	01 d0                	add    %edx,%eax
    22dc:	0f b6 00             	movzbl (%eax),%eax
    22df:	0f be c0             	movsbl %al,%eax
    22e2:	83 ec 04             	sub    $0x4,%esp
    22e5:	50                   	push   %eax
    22e6:	68 49 59 00 00       	push   $0x5949
    22eb:	6a 01                	push   $0x1
    22ed:	e8 b2 24 00 00       	call   47a4 <printf>
    22f2:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    22f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    22ff:	8b 45 08             	mov    0x8(%ebp),%eax
    2302:	01 d0                	add    %edx,%eax
    2304:	8b 00                	mov    (%eax),%eax
    2306:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2309:	83 c2 02             	add    $0x2,%edx
    230c:	01 d0                	add    %edx,%eax
    230e:	0f b6 00             	movzbl (%eax),%eax
    2311:	0f be c0             	movsbl %al,%eax
    2314:	83 ec 04             	sub    $0x4,%esp
    2317:	50                   	push   %eax
    2318:	68 49 59 00 00       	push   $0x5949
    231d:	6a 01                	push   $0x1
    231f:	e8 80 24 00 00       	call   47a4 <printf>
    2324:	83 c4 10             	add    $0x10,%esp
					mark = mark + 3;
    2327:	83 45 e8 03          	addl   $0x3,-0x18(%ebp)
    232b:	e9 a0 1d 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// float
				else if((mark+4)<MAX_LINE_LENGTH && text[j][mark] == 'f' && text[j][mark+1] == 'l' && text[j][mark+2] == 'o'
    2330:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2333:	83 c0 04             	add    $0x4,%eax
    2336:	3d ff 00 00 00       	cmp    $0xff,%eax
    233b:	0f 8f b1 01 00 00    	jg     24f2 <show_text_syntax_highlighting+0x761>
    2341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2344:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    234b:	8b 45 08             	mov    0x8(%ebp),%eax
    234e:	01 d0                	add    %edx,%eax
    2350:	8b 10                	mov    (%eax),%edx
    2352:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2355:	01 d0                	add    %edx,%eax
    2357:	0f b6 00             	movzbl (%eax),%eax
    235a:	3c 66                	cmp    $0x66,%al
    235c:	0f 85 90 01 00 00    	jne    24f2 <show_text_syntax_highlighting+0x761>
    2362:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2365:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    236c:	8b 45 08             	mov    0x8(%ebp),%eax
    236f:	01 d0                	add    %edx,%eax
    2371:	8b 00                	mov    (%eax),%eax
    2373:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2376:	83 c2 01             	add    $0x1,%edx
    2379:	01 d0                	add    %edx,%eax
    237b:	0f b6 00             	movzbl (%eax),%eax
    237e:	3c 6c                	cmp    $0x6c,%al
    2380:	0f 85 6c 01 00 00    	jne    24f2 <show_text_syntax_highlighting+0x761>
    2386:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2389:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2390:	8b 45 08             	mov    0x8(%ebp),%eax
    2393:	01 d0                	add    %edx,%eax
    2395:	8b 00                	mov    (%eax),%eax
    2397:	8b 55 e8             	mov    -0x18(%ebp),%edx
    239a:	83 c2 02             	add    $0x2,%edx
    239d:	01 d0                	add    %edx,%eax
    239f:	0f b6 00             	movzbl (%eax),%eax
    23a2:	3c 6f                	cmp    $0x6f,%al
    23a4:	0f 85 48 01 00 00    	jne    24f2 <show_text_syntax_highlighting+0x761>
					&& text[j][mark+3] == 'a' && text[j][mark+4] == 't'){
    23aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    23b4:	8b 45 08             	mov    0x8(%ebp),%eax
    23b7:	01 d0                	add    %edx,%eax
    23b9:	8b 00                	mov    (%eax),%eax
    23bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
    23be:	83 c2 03             	add    $0x3,%edx
    23c1:	01 d0                	add    %edx,%eax
    23c3:	0f b6 00             	movzbl (%eax),%eax
    23c6:	3c 61                	cmp    $0x61,%al
    23c8:	0f 85 24 01 00 00    	jne    24f2 <show_text_syntax_highlighting+0x761>
    23ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    23d8:	8b 45 08             	mov    0x8(%ebp),%eax
    23db:	01 d0                	add    %edx,%eax
    23dd:	8b 00                	mov    (%eax),%eax
    23df:	8b 55 e8             	mov    -0x18(%ebp),%edx
    23e2:	83 c2 04             	add    $0x4,%edx
    23e5:	01 d0                	add    %edx,%eax
    23e7:	0f b6 00             	movzbl (%eax),%eax
    23ea:	3c 74                	cmp    $0x74,%al
    23ec:	0f 85 00 01 00 00    	jne    24f2 <show_text_syntax_highlighting+0x761>
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    23f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    23fc:	8b 45 08             	mov    0x8(%ebp),%eax
    23ff:	01 d0                	add    %edx,%eax
    2401:	8b 10                	mov    (%eax),%edx
    2403:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2406:	01 d0                	add    %edx,%eax
    2408:	0f b6 00             	movzbl (%eax),%eax
    240b:	0f be c0             	movsbl %al,%eax
    240e:	83 ec 04             	sub    $0x4,%esp
    2411:	50                   	push   %eax
    2412:	68 49 59 00 00       	push   $0x5949
    2417:	6a 01                	push   $0x1
    2419:	e8 86 23 00 00       	call   47a4 <printf>
    241e:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    2421:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    242b:	8b 45 08             	mov    0x8(%ebp),%eax
    242e:	01 d0                	add    %edx,%eax
    2430:	8b 00                	mov    (%eax),%eax
    2432:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2435:	83 c2 01             	add    $0x1,%edx
    2438:	01 d0                	add    %edx,%eax
    243a:	0f b6 00             	movzbl (%eax),%eax
    243d:	0f be c0             	movsbl %al,%eax
    2440:	83 ec 04             	sub    $0x4,%esp
    2443:	50                   	push   %eax
    2444:	68 49 59 00 00       	push   $0x5949
    2449:	6a 01                	push   $0x1
    244b:	e8 54 23 00 00       	call   47a4 <printf>
    2450:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    2453:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    245d:	8b 45 08             	mov    0x8(%ebp),%eax
    2460:	01 d0                	add    %edx,%eax
    2462:	8b 00                	mov    (%eax),%eax
    2464:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2467:	83 c2 02             	add    $0x2,%edx
    246a:	01 d0                	add    %edx,%eax
    246c:	0f b6 00             	movzbl (%eax),%eax
    246f:	0f be c0             	movsbl %al,%eax
    2472:	83 ec 04             	sub    $0x4,%esp
    2475:	50                   	push   %eax
    2476:	68 49 59 00 00       	push   $0x5949
    247b:	6a 01                	push   $0x1
    247d:	e8 22 23 00 00       	call   47a4 <printf>
    2482:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
    2485:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    248f:	8b 45 08             	mov    0x8(%ebp),%eax
    2492:	01 d0                	add    %edx,%eax
    2494:	8b 00                	mov    (%eax),%eax
    2496:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2499:	83 c2 03             	add    $0x3,%edx
    249c:	01 d0                	add    %edx,%eax
    249e:	0f b6 00             	movzbl (%eax),%eax
    24a1:	0f be c0             	movsbl %al,%eax
    24a4:	83 ec 04             	sub    $0x4,%esp
    24a7:	50                   	push   %eax
    24a8:	68 49 59 00 00       	push   $0x5949
    24ad:	6a 01                	push   $0x1
    24af:	e8 f0 22 00 00       	call   47a4 <printf>
    24b4:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
    24b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    24c1:	8b 45 08             	mov    0x8(%ebp),%eax
    24c4:	01 d0                	add    %edx,%eax
    24c6:	8b 00                	mov    (%eax),%eax
    24c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
    24cb:	83 c2 04             	add    $0x4,%edx
    24ce:	01 d0                	add    %edx,%eax
    24d0:	0f b6 00             	movzbl (%eax),%eax
    24d3:	0f be c0             	movsbl %al,%eax
    24d6:	83 ec 04             	sub    $0x4,%esp
    24d9:	50                   	push   %eax
    24da:	68 49 59 00 00       	push   $0x5949
    24df:	6a 01                	push   $0x1
    24e1:	e8 be 22 00 00       	call   47a4 <printf>
    24e6:	83 c4 10             	add    $0x10,%esp
					mark = mark + 5;
    24e9:	83 45 e8 05          	addl   $0x5,-0x18(%ebp)
    24ed:	e9 de 1b 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// double
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'd' && text[j][mark+1] == 'o' && text[j][mark+2] == 'u'
    24f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    24f5:	83 c0 05             	add    $0x5,%eax
    24f8:	3d ff 00 00 00       	cmp    $0xff,%eax
    24fd:	0f 8f 07 02 00 00    	jg     270a <show_text_syntax_highlighting+0x979>
    2503:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2506:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    250d:	8b 45 08             	mov    0x8(%ebp),%eax
    2510:	01 d0                	add    %edx,%eax
    2512:	8b 10                	mov    (%eax),%edx
    2514:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2517:	01 d0                	add    %edx,%eax
    2519:	0f b6 00             	movzbl (%eax),%eax
    251c:	3c 64                	cmp    $0x64,%al
    251e:	0f 85 e6 01 00 00    	jne    270a <show_text_syntax_highlighting+0x979>
    2524:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2527:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    252e:	8b 45 08             	mov    0x8(%ebp),%eax
    2531:	01 d0                	add    %edx,%eax
    2533:	8b 00                	mov    (%eax),%eax
    2535:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2538:	83 c2 01             	add    $0x1,%edx
    253b:	01 d0                	add    %edx,%eax
    253d:	0f b6 00             	movzbl (%eax),%eax
    2540:	3c 6f                	cmp    $0x6f,%al
    2542:	0f 85 c2 01 00 00    	jne    270a <show_text_syntax_highlighting+0x979>
    2548:	8b 45 f4             	mov    -0xc(%ebp),%eax
    254b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2552:	8b 45 08             	mov    0x8(%ebp),%eax
    2555:	01 d0                	add    %edx,%eax
    2557:	8b 00                	mov    (%eax),%eax
    2559:	8b 55 e8             	mov    -0x18(%ebp),%edx
    255c:	83 c2 02             	add    $0x2,%edx
    255f:	01 d0                	add    %edx,%eax
    2561:	0f b6 00             	movzbl (%eax),%eax
    2564:	3c 75                	cmp    $0x75,%al
    2566:	0f 85 9e 01 00 00    	jne    270a <show_text_syntax_highlighting+0x979>
					&& text[j][mark+3] == 'b' && text[j][mark+4] == 'l' && text[j][mark+5] == 'e'){
    256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    256f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2576:	8b 45 08             	mov    0x8(%ebp),%eax
    2579:	01 d0                	add    %edx,%eax
    257b:	8b 00                	mov    (%eax),%eax
    257d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2580:	83 c2 03             	add    $0x3,%edx
    2583:	01 d0                	add    %edx,%eax
    2585:	0f b6 00             	movzbl (%eax),%eax
    2588:	3c 62                	cmp    $0x62,%al
    258a:	0f 85 7a 01 00 00    	jne    270a <show_text_syntax_highlighting+0x979>
    2590:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    259a:	8b 45 08             	mov    0x8(%ebp),%eax
    259d:	01 d0                	add    %edx,%eax
    259f:	8b 00                	mov    (%eax),%eax
    25a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
    25a4:	83 c2 04             	add    $0x4,%edx
    25a7:	01 d0                	add    %edx,%eax
    25a9:	0f b6 00             	movzbl (%eax),%eax
    25ac:	3c 6c                	cmp    $0x6c,%al
    25ae:	0f 85 56 01 00 00    	jne    270a <show_text_syntax_highlighting+0x979>
    25b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    25be:	8b 45 08             	mov    0x8(%ebp),%eax
    25c1:	01 d0                	add    %edx,%eax
    25c3:	8b 00                	mov    (%eax),%eax
    25c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    25c8:	83 c2 05             	add    $0x5,%edx
    25cb:	01 d0                	add    %edx,%eax
    25cd:	0f b6 00             	movzbl (%eax),%eax
    25d0:	3c 65                	cmp    $0x65,%al
    25d2:	0f 85 32 01 00 00    	jne    270a <show_text_syntax_highlighting+0x979>
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    25d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    25db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    25e2:	8b 45 08             	mov    0x8(%ebp),%eax
    25e5:	01 d0                	add    %edx,%eax
    25e7:	8b 10                	mov    (%eax),%edx
    25e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    25ec:	01 d0                	add    %edx,%eax
    25ee:	0f b6 00             	movzbl (%eax),%eax
    25f1:	0f be c0             	movsbl %al,%eax
    25f4:	83 ec 04             	sub    $0x4,%esp
    25f7:	50                   	push   %eax
    25f8:	68 49 59 00 00       	push   $0x5949
    25fd:	6a 01                	push   $0x1
    25ff:	e8 a0 21 00 00       	call   47a4 <printf>
    2604:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    2607:	8b 45 f4             	mov    -0xc(%ebp),%eax
    260a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2611:	8b 45 08             	mov    0x8(%ebp),%eax
    2614:	01 d0                	add    %edx,%eax
    2616:	8b 00                	mov    (%eax),%eax
    2618:	8b 55 e8             	mov    -0x18(%ebp),%edx
    261b:	83 c2 01             	add    $0x1,%edx
    261e:	01 d0                	add    %edx,%eax
    2620:	0f b6 00             	movzbl (%eax),%eax
    2623:	0f be c0             	movsbl %al,%eax
    2626:	83 ec 04             	sub    $0x4,%esp
    2629:	50                   	push   %eax
    262a:	68 49 59 00 00       	push   $0x5949
    262f:	6a 01                	push   $0x1
    2631:	e8 6e 21 00 00       	call   47a4 <printf>
    2636:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    2639:	8b 45 f4             	mov    -0xc(%ebp),%eax
    263c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2643:	8b 45 08             	mov    0x8(%ebp),%eax
    2646:	01 d0                	add    %edx,%eax
    2648:	8b 00                	mov    (%eax),%eax
    264a:	8b 55 e8             	mov    -0x18(%ebp),%edx
    264d:	83 c2 02             	add    $0x2,%edx
    2650:	01 d0                	add    %edx,%eax
    2652:	0f b6 00             	movzbl (%eax),%eax
    2655:	0f be c0             	movsbl %al,%eax
    2658:	83 ec 04             	sub    $0x4,%esp
    265b:	50                   	push   %eax
    265c:	68 49 59 00 00       	push   $0x5949
    2661:	6a 01                	push   $0x1
    2663:	e8 3c 21 00 00       	call   47a4 <printf>
    2668:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
    266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    266e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2675:	8b 45 08             	mov    0x8(%ebp),%eax
    2678:	01 d0                	add    %edx,%eax
    267a:	8b 00                	mov    (%eax),%eax
    267c:	8b 55 e8             	mov    -0x18(%ebp),%edx
    267f:	83 c2 03             	add    $0x3,%edx
    2682:	01 d0                	add    %edx,%eax
    2684:	0f b6 00             	movzbl (%eax),%eax
    2687:	0f be c0             	movsbl %al,%eax
    268a:	83 ec 04             	sub    $0x4,%esp
    268d:	50                   	push   %eax
    268e:	68 49 59 00 00       	push   $0x5949
    2693:	6a 01                	push   $0x1
    2695:	e8 0a 21 00 00       	call   47a4 <printf>
    269a:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
    269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    26a7:	8b 45 08             	mov    0x8(%ebp),%eax
    26aa:	01 d0                	add    %edx,%eax
    26ac:	8b 00                	mov    (%eax),%eax
    26ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
    26b1:	83 c2 04             	add    $0x4,%edx
    26b4:	01 d0                	add    %edx,%eax
    26b6:	0f b6 00             	movzbl (%eax),%eax
    26b9:	0f be c0             	movsbl %al,%eax
    26bc:	83 ec 04             	sub    $0x4,%esp
    26bf:	50                   	push   %eax
    26c0:	68 49 59 00 00       	push   $0x5949
    26c5:	6a 01                	push   $0x1
    26c7:	e8 d8 20 00 00       	call   47a4 <printf>
    26cc:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+5]);
    26cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    26d9:	8b 45 08             	mov    0x8(%ebp),%eax
    26dc:	01 d0                	add    %edx,%eax
    26de:	8b 00                	mov    (%eax),%eax
    26e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
    26e3:	83 c2 05             	add    $0x5,%edx
    26e6:	01 d0                	add    %edx,%eax
    26e8:	0f b6 00             	movzbl (%eax),%eax
    26eb:	0f be c0             	movsbl %al,%eax
    26ee:	83 ec 04             	sub    $0x4,%esp
    26f1:	50                   	push   %eax
    26f2:	68 49 59 00 00       	push   $0x5949
    26f7:	6a 01                	push   $0x1
    26f9:	e8 a6 20 00 00       	call   47a4 <printf>
    26fe:	83 c4 10             	add    $0x10,%esp
					mark = mark + 6;
    2701:	83 45 e8 06          	addl   $0x6,-0x18(%ebp)
    2705:	e9 c6 19 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// char
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'c' && text[j][mark+1] == 'h' && text[j][mark+2] == 'a'
    270a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    270d:	83 c0 03             	add    $0x3,%eax
    2710:	3d ff 00 00 00       	cmp    $0xff,%eax
    2715:	0f 8f 5b 01 00 00    	jg     2876 <show_text_syntax_highlighting+0xae5>
    271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    271e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2725:	8b 45 08             	mov    0x8(%ebp),%eax
    2728:	01 d0                	add    %edx,%eax
    272a:	8b 10                	mov    (%eax),%edx
    272c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    272f:	01 d0                	add    %edx,%eax
    2731:	0f b6 00             	movzbl (%eax),%eax
    2734:	3c 63                	cmp    $0x63,%al
    2736:	0f 85 3a 01 00 00    	jne    2876 <show_text_syntax_highlighting+0xae5>
    273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    273f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2746:	8b 45 08             	mov    0x8(%ebp),%eax
    2749:	01 d0                	add    %edx,%eax
    274b:	8b 00                	mov    (%eax),%eax
    274d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2750:	83 c2 01             	add    $0x1,%edx
    2753:	01 d0                	add    %edx,%eax
    2755:	0f b6 00             	movzbl (%eax),%eax
    2758:	3c 68                	cmp    $0x68,%al
    275a:	0f 85 16 01 00 00    	jne    2876 <show_text_syntax_highlighting+0xae5>
    2760:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2763:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    276a:	8b 45 08             	mov    0x8(%ebp),%eax
    276d:	01 d0                	add    %edx,%eax
    276f:	8b 00                	mov    (%eax),%eax
    2771:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2774:	83 c2 02             	add    $0x2,%edx
    2777:	01 d0                	add    %edx,%eax
    2779:	0f b6 00             	movzbl (%eax),%eax
    277c:	3c 61                	cmp    $0x61,%al
    277e:	0f 85 f2 00 00 00    	jne    2876 <show_text_syntax_highlighting+0xae5>
					&& text[j][mark+3] == 'r'){
    2784:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2787:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    278e:	8b 45 08             	mov    0x8(%ebp),%eax
    2791:	01 d0                	add    %edx,%eax
    2793:	8b 00                	mov    (%eax),%eax
    2795:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2798:	83 c2 03             	add    $0x3,%edx
    279b:	01 d0                	add    %edx,%eax
    279d:	0f b6 00             	movzbl (%eax),%eax
    27a0:	3c 72                	cmp    $0x72,%al
    27a2:	0f 85 ce 00 00 00    	jne    2876 <show_text_syntax_highlighting+0xae5>
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    27a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    27ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    27b2:	8b 45 08             	mov    0x8(%ebp),%eax
    27b5:	01 d0                	add    %edx,%eax
    27b7:	8b 10                	mov    (%eax),%edx
    27b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    27bc:	01 d0                	add    %edx,%eax
    27be:	0f b6 00             	movzbl (%eax),%eax
    27c1:	0f be c0             	movsbl %al,%eax
    27c4:	83 ec 04             	sub    $0x4,%esp
    27c7:	50                   	push   %eax
    27c8:	68 49 59 00 00       	push   $0x5949
    27cd:	6a 01                	push   $0x1
    27cf:	e8 d0 1f 00 00       	call   47a4 <printf>
    27d4:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    27d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    27da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    27e1:	8b 45 08             	mov    0x8(%ebp),%eax
    27e4:	01 d0                	add    %edx,%eax
    27e6:	8b 00                	mov    (%eax),%eax
    27e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
    27eb:	83 c2 01             	add    $0x1,%edx
    27ee:	01 d0                	add    %edx,%eax
    27f0:	0f b6 00             	movzbl (%eax),%eax
    27f3:	0f be c0             	movsbl %al,%eax
    27f6:	83 ec 04             	sub    $0x4,%esp
    27f9:	50                   	push   %eax
    27fa:	68 49 59 00 00       	push   $0x5949
    27ff:	6a 01                	push   $0x1
    2801:	e8 9e 1f 00 00       	call   47a4 <printf>
    2806:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    2809:	8b 45 f4             	mov    -0xc(%ebp),%eax
    280c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2813:	8b 45 08             	mov    0x8(%ebp),%eax
    2816:	01 d0                	add    %edx,%eax
    2818:	8b 00                	mov    (%eax),%eax
    281a:	8b 55 e8             	mov    -0x18(%ebp),%edx
    281d:	83 c2 02             	add    $0x2,%edx
    2820:	01 d0                	add    %edx,%eax
    2822:	0f b6 00             	movzbl (%eax),%eax
    2825:	0f be c0             	movsbl %al,%eax
    2828:	83 ec 04             	sub    $0x4,%esp
    282b:	50                   	push   %eax
    282c:	68 49 59 00 00       	push   $0x5949
    2831:	6a 01                	push   $0x1
    2833:	e8 6c 1f 00 00       	call   47a4 <printf>
    2838:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
    283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    283e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2845:	8b 45 08             	mov    0x8(%ebp),%eax
    2848:	01 d0                	add    %edx,%eax
    284a:	8b 00                	mov    (%eax),%eax
    284c:	8b 55 e8             	mov    -0x18(%ebp),%edx
    284f:	83 c2 03             	add    $0x3,%edx
    2852:	01 d0                	add    %edx,%eax
    2854:	0f b6 00             	movzbl (%eax),%eax
    2857:	0f be c0             	movsbl %al,%eax
    285a:	83 ec 04             	sub    $0x4,%esp
    285d:	50                   	push   %eax
    285e:	68 49 59 00 00       	push   $0x5949
    2863:	6a 01                	push   $0x1
    2865:	e8 3a 1f 00 00       	call   47a4 <printf>
    286a:	83 c4 10             	add    $0x10,%esp
					mark = mark + 4;
    286d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2871:	e9 5a 18 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// if
				else if((mark+1)<MAX_LINE_LENGTH && text[j][mark] == 'i' && text[j][mark+1] == 'f'){
    2876:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2879:	83 c0 01             	add    $0x1,%eax
    287c:	3d ff 00 00 00       	cmp    $0xff,%eax
    2881:	0f 8f ab 00 00 00    	jg     2932 <show_text_syntax_highlighting+0xba1>
    2887:	8b 45 f4             	mov    -0xc(%ebp),%eax
    288a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2891:	8b 45 08             	mov    0x8(%ebp),%eax
    2894:	01 d0                	add    %edx,%eax
    2896:	8b 10                	mov    (%eax),%edx
    2898:	8b 45 e8             	mov    -0x18(%ebp),%eax
    289b:	01 d0                	add    %edx,%eax
    289d:	0f b6 00             	movzbl (%eax),%eax
    28a0:	3c 69                	cmp    $0x69,%al
    28a2:	0f 85 8a 00 00 00    	jne    2932 <show_text_syntax_highlighting+0xba1>
    28a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    28b2:	8b 45 08             	mov    0x8(%ebp),%eax
    28b5:	01 d0                	add    %edx,%eax
    28b7:	8b 00                	mov    (%eax),%eax
    28b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
    28bc:	83 c2 01             	add    $0x1,%edx
    28bf:	01 d0                	add    %edx,%eax
    28c1:	0f b6 00             	movzbl (%eax),%eax
    28c4:	3c 66                	cmp    $0x66,%al
    28c6:	75 6a                	jne    2932 <show_text_syntax_highlighting+0xba1>
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    28c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    28d2:	8b 45 08             	mov    0x8(%ebp),%eax
    28d5:	01 d0                	add    %edx,%eax
    28d7:	8b 10                	mov    (%eax),%edx
    28d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    28dc:	01 d0                	add    %edx,%eax
    28de:	0f b6 00             	movzbl (%eax),%eax
    28e1:	0f be c0             	movsbl %al,%eax
    28e4:	83 ec 04             	sub    $0x4,%esp
    28e7:	50                   	push   %eax
    28e8:	68 57 59 00 00       	push   $0x5957
    28ed:	6a 01                	push   $0x1
    28ef:	e8 b0 1e 00 00       	call   47a4 <printf>
    28f4:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
    28f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2901:	8b 45 08             	mov    0x8(%ebp),%eax
    2904:	01 d0                	add    %edx,%eax
    2906:	8b 00                	mov    (%eax),%eax
    2908:	8b 55 e8             	mov    -0x18(%ebp),%edx
    290b:	83 c2 01             	add    $0x1,%edx
    290e:	01 d0                	add    %edx,%eax
    2910:	0f b6 00             	movzbl (%eax),%eax
    2913:	0f be c0             	movsbl %al,%eax
    2916:	83 ec 04             	sub    $0x4,%esp
    2919:	50                   	push   %eax
    291a:	68 57 59 00 00       	push   $0x5957
    291f:	6a 01                	push   $0x1
    2921:	e8 7e 1e 00 00       	call   47a4 <printf>
    2926:	83 c4 10             	add    $0x10,%esp
					mark = mark + 2;
    2929:	83 45 e8 02          	addl   $0x2,-0x18(%ebp)
    292d:	e9 9e 17 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// else
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'e' && text[j][mark+1] == 'l' && text[j][mark+2] == 's'
    2932:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2935:	83 c0 03             	add    $0x3,%eax
    2938:	3d ff 00 00 00       	cmp    $0xff,%eax
    293d:	0f 8f 5b 01 00 00    	jg     2a9e <show_text_syntax_highlighting+0xd0d>
    2943:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2946:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    294d:	8b 45 08             	mov    0x8(%ebp),%eax
    2950:	01 d0                	add    %edx,%eax
    2952:	8b 10                	mov    (%eax),%edx
    2954:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2957:	01 d0                	add    %edx,%eax
    2959:	0f b6 00             	movzbl (%eax),%eax
    295c:	3c 65                	cmp    $0x65,%al
    295e:	0f 85 3a 01 00 00    	jne    2a9e <show_text_syntax_highlighting+0xd0d>
    2964:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2967:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    296e:	8b 45 08             	mov    0x8(%ebp),%eax
    2971:	01 d0                	add    %edx,%eax
    2973:	8b 00                	mov    (%eax),%eax
    2975:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2978:	83 c2 01             	add    $0x1,%edx
    297b:	01 d0                	add    %edx,%eax
    297d:	0f b6 00             	movzbl (%eax),%eax
    2980:	3c 6c                	cmp    $0x6c,%al
    2982:	0f 85 16 01 00 00    	jne    2a9e <show_text_syntax_highlighting+0xd0d>
    2988:	8b 45 f4             	mov    -0xc(%ebp),%eax
    298b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2992:	8b 45 08             	mov    0x8(%ebp),%eax
    2995:	01 d0                	add    %edx,%eax
    2997:	8b 00                	mov    (%eax),%eax
    2999:	8b 55 e8             	mov    -0x18(%ebp),%edx
    299c:	83 c2 02             	add    $0x2,%edx
    299f:	01 d0                	add    %edx,%eax
    29a1:	0f b6 00             	movzbl (%eax),%eax
    29a4:	3c 73                	cmp    $0x73,%al
    29a6:	0f 85 f2 00 00 00    	jne    2a9e <show_text_syntax_highlighting+0xd0d>
					&& text[j][mark+3] == 'e'){
    29ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    29b6:	8b 45 08             	mov    0x8(%ebp),%eax
    29b9:	01 d0                	add    %edx,%eax
    29bb:	8b 00                	mov    (%eax),%eax
    29bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
    29c0:	83 c2 03             	add    $0x3,%edx
    29c3:	01 d0                	add    %edx,%eax
    29c5:	0f b6 00             	movzbl (%eax),%eax
    29c8:	3c 65                	cmp    $0x65,%al
    29ca:	0f 85 ce 00 00 00    	jne    2a9e <show_text_syntax_highlighting+0xd0d>
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    29d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    29d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    29da:	8b 45 08             	mov    0x8(%ebp),%eax
    29dd:	01 d0                	add    %edx,%eax
    29df:	8b 10                	mov    (%eax),%edx
    29e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    29e4:	01 d0                	add    %edx,%eax
    29e6:	0f b6 00             	movzbl (%eax),%eax
    29e9:	0f be c0             	movsbl %al,%eax
    29ec:	83 ec 04             	sub    $0x4,%esp
    29ef:	50                   	push   %eax
    29f0:	68 57 59 00 00       	push   $0x5957
    29f5:	6a 01                	push   $0x1
    29f7:	e8 a8 1d 00 00       	call   47a4 <printf>
    29fc:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
    29ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2a09:	8b 45 08             	mov    0x8(%ebp),%eax
    2a0c:	01 d0                	add    %edx,%eax
    2a0e:	8b 00                	mov    (%eax),%eax
    2a10:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2a13:	83 c2 01             	add    $0x1,%edx
    2a16:	01 d0                	add    %edx,%eax
    2a18:	0f b6 00             	movzbl (%eax),%eax
    2a1b:	0f be c0             	movsbl %al,%eax
    2a1e:	83 ec 04             	sub    $0x4,%esp
    2a21:	50                   	push   %eax
    2a22:	68 57 59 00 00       	push   $0x5957
    2a27:	6a 01                	push   $0x1
    2a29:	e8 76 1d 00 00       	call   47a4 <printf>
    2a2e:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
    2a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a34:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2a3b:	8b 45 08             	mov    0x8(%ebp),%eax
    2a3e:	01 d0                	add    %edx,%eax
    2a40:	8b 00                	mov    (%eax),%eax
    2a42:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2a45:	83 c2 02             	add    $0x2,%edx
    2a48:	01 d0                	add    %edx,%eax
    2a4a:	0f b6 00             	movzbl (%eax),%eax
    2a4d:	0f be c0             	movsbl %al,%eax
    2a50:	83 ec 04             	sub    $0x4,%esp
    2a53:	50                   	push   %eax
    2a54:	68 57 59 00 00       	push   $0x5957
    2a59:	6a 01                	push   $0x1
    2a5b:	e8 44 1d 00 00       	call   47a4 <printf>
    2a60:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
    2a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2a6d:	8b 45 08             	mov    0x8(%ebp),%eax
    2a70:	01 d0                	add    %edx,%eax
    2a72:	8b 00                	mov    (%eax),%eax
    2a74:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2a77:	83 c2 03             	add    $0x3,%edx
    2a7a:	01 d0                	add    %edx,%eax
    2a7c:	0f b6 00             	movzbl (%eax),%eax
    2a7f:	0f be c0             	movsbl %al,%eax
    2a82:	83 ec 04             	sub    $0x4,%esp
    2a85:	50                   	push   %eax
    2a86:	68 57 59 00 00       	push   $0x5957
    2a8b:	6a 01                	push   $0x1
    2a8d:	e8 12 1d 00 00       	call   47a4 <printf>
    2a92:	83 c4 10             	add    $0x10,%esp
					mark = mark + 4;
    2a95:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2a99:	e9 32 16 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// else if
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'e' && text[j][mark+1] == 'l' && text[j][mark+2] == 's'
    2a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2aa1:	83 c0 05             	add    $0x5,%eax
    2aa4:	3d ff 00 00 00       	cmp    $0xff,%eax
    2aa9:	0f 8f 5d 02 00 00    	jg     2d0c <show_text_syntax_highlighting+0xf7b>
    2aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ab2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2ab9:	8b 45 08             	mov    0x8(%ebp),%eax
    2abc:	01 d0                	add    %edx,%eax
    2abe:	8b 10                	mov    (%eax),%edx
    2ac0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2ac3:	01 d0                	add    %edx,%eax
    2ac5:	0f b6 00             	movzbl (%eax),%eax
    2ac8:	3c 65                	cmp    $0x65,%al
    2aca:	0f 85 3c 02 00 00    	jne    2d0c <show_text_syntax_highlighting+0xf7b>
    2ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ad3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2ada:	8b 45 08             	mov    0x8(%ebp),%eax
    2add:	01 d0                	add    %edx,%eax
    2adf:	8b 00                	mov    (%eax),%eax
    2ae1:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2ae4:	83 c2 01             	add    $0x1,%edx
    2ae7:	01 d0                	add    %edx,%eax
    2ae9:	0f b6 00             	movzbl (%eax),%eax
    2aec:	3c 6c                	cmp    $0x6c,%al
    2aee:	0f 85 18 02 00 00    	jne    2d0c <show_text_syntax_highlighting+0xf7b>
    2af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2af7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2afe:	8b 45 08             	mov    0x8(%ebp),%eax
    2b01:	01 d0                	add    %edx,%eax
    2b03:	8b 00                	mov    (%eax),%eax
    2b05:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2b08:	83 c2 02             	add    $0x2,%edx
    2b0b:	01 d0                	add    %edx,%eax
    2b0d:	0f b6 00             	movzbl (%eax),%eax
    2b10:	3c 73                	cmp    $0x73,%al
    2b12:	0f 85 f4 01 00 00    	jne    2d0c <show_text_syntax_highlighting+0xf7b>
					&& text[j][mark+3] == 'e' && text[j][mark+4] == ' ' && text[j][mark+5] == 'i' && text[j][mark+6] == 'f'){
    2b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2b1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2b22:	8b 45 08             	mov    0x8(%ebp),%eax
    2b25:	01 d0                	add    %edx,%eax
    2b27:	8b 00                	mov    (%eax),%eax
    2b29:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2b2c:	83 c2 03             	add    $0x3,%edx
    2b2f:	01 d0                	add    %edx,%eax
    2b31:	0f b6 00             	movzbl (%eax),%eax
    2b34:	3c 65                	cmp    $0x65,%al
    2b36:	0f 85 d0 01 00 00    	jne    2d0c <show_text_syntax_highlighting+0xf7b>
    2b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2b3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2b46:	8b 45 08             	mov    0x8(%ebp),%eax
    2b49:	01 d0                	add    %edx,%eax
    2b4b:	8b 00                	mov    (%eax),%eax
    2b4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2b50:	83 c2 04             	add    $0x4,%edx
    2b53:	01 d0                	add    %edx,%eax
    2b55:	0f b6 00             	movzbl (%eax),%eax
    2b58:	3c 20                	cmp    $0x20,%al
    2b5a:	0f 85 ac 01 00 00    	jne    2d0c <show_text_syntax_highlighting+0xf7b>
    2b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2b63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2b6a:	8b 45 08             	mov    0x8(%ebp),%eax
    2b6d:	01 d0                	add    %edx,%eax
    2b6f:	8b 00                	mov    (%eax),%eax
    2b71:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2b74:	83 c2 05             	add    $0x5,%edx
    2b77:	01 d0                	add    %edx,%eax
    2b79:	0f b6 00             	movzbl (%eax),%eax
    2b7c:	3c 69                	cmp    $0x69,%al
    2b7e:	0f 85 88 01 00 00    	jne    2d0c <show_text_syntax_highlighting+0xf7b>
    2b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2b87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2b8e:	8b 45 08             	mov    0x8(%ebp),%eax
    2b91:	01 d0                	add    %edx,%eax
    2b93:	8b 00                	mov    (%eax),%eax
    2b95:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2b98:	83 c2 06             	add    $0x6,%edx
    2b9b:	01 d0                	add    %edx,%eax
    2b9d:	0f b6 00             	movzbl (%eax),%eax
    2ba0:	3c 66                	cmp    $0x66,%al
    2ba2:	0f 85 64 01 00 00    	jne    2d0c <show_text_syntax_highlighting+0xf7b>
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    2ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2bab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2bb2:	8b 45 08             	mov    0x8(%ebp),%eax
    2bb5:	01 d0                	add    %edx,%eax
    2bb7:	8b 10                	mov    (%eax),%edx
    2bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2bbc:	01 d0                	add    %edx,%eax
    2bbe:	0f b6 00             	movzbl (%eax),%eax
    2bc1:	0f be c0             	movsbl %al,%eax
    2bc4:	83 ec 04             	sub    $0x4,%esp
    2bc7:	50                   	push   %eax
    2bc8:	68 57 59 00 00       	push   $0x5957
    2bcd:	6a 01                	push   $0x1
    2bcf:	e8 d0 1b 00 00       	call   47a4 <printf>
    2bd4:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
    2bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2bda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2be1:	8b 45 08             	mov    0x8(%ebp),%eax
    2be4:	01 d0                	add    %edx,%eax
    2be6:	8b 00                	mov    (%eax),%eax
    2be8:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2beb:	83 c2 01             	add    $0x1,%edx
    2bee:	01 d0                	add    %edx,%eax
    2bf0:	0f b6 00             	movzbl (%eax),%eax
    2bf3:	0f be c0             	movsbl %al,%eax
    2bf6:	83 ec 04             	sub    $0x4,%esp
    2bf9:	50                   	push   %eax
    2bfa:	68 57 59 00 00       	push   $0x5957
    2bff:	6a 01                	push   $0x1
    2c01:	e8 9e 1b 00 00       	call   47a4 <printf>
    2c06:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
    2c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c0c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2c13:	8b 45 08             	mov    0x8(%ebp),%eax
    2c16:	01 d0                	add    %edx,%eax
    2c18:	8b 00                	mov    (%eax),%eax
    2c1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2c1d:	83 c2 02             	add    $0x2,%edx
    2c20:	01 d0                	add    %edx,%eax
    2c22:	0f b6 00             	movzbl (%eax),%eax
    2c25:	0f be c0             	movsbl %al,%eax
    2c28:	83 ec 04             	sub    $0x4,%esp
    2c2b:	50                   	push   %eax
    2c2c:	68 57 59 00 00       	push   $0x5957
    2c31:	6a 01                	push   $0x1
    2c33:	e8 6c 1b 00 00       	call   47a4 <printf>
    2c38:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
    2c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2c45:	8b 45 08             	mov    0x8(%ebp),%eax
    2c48:	01 d0                	add    %edx,%eax
    2c4a:	8b 00                	mov    (%eax),%eax
    2c4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2c4f:	83 c2 03             	add    $0x3,%edx
    2c52:	01 d0                	add    %edx,%eax
    2c54:	0f b6 00             	movzbl (%eax),%eax
    2c57:	0f be c0             	movsbl %al,%eax
    2c5a:	83 ec 04             	sub    $0x4,%esp
    2c5d:	50                   	push   %eax
    2c5e:	68 57 59 00 00       	push   $0x5957
    2c63:	6a 01                	push   $0x1
    2c65:	e8 3a 1b 00 00       	call   47a4 <printf>
    2c6a:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+4]);
    2c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2c77:	8b 45 08             	mov    0x8(%ebp),%eax
    2c7a:	01 d0                	add    %edx,%eax
    2c7c:	8b 00                	mov    (%eax),%eax
    2c7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2c81:	83 c2 04             	add    $0x4,%edx
    2c84:	01 d0                	add    %edx,%eax
    2c86:	0f b6 00             	movzbl (%eax),%eax
    2c89:	0f be c0             	movsbl %al,%eax
    2c8c:	83 ec 04             	sub    $0x4,%esp
    2c8f:	50                   	push   %eax
    2c90:	68 57 59 00 00       	push   $0x5957
    2c95:	6a 01                	push   $0x1
    2c97:	e8 08 1b 00 00       	call   47a4 <printf>
    2c9c:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+5]);
    2c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ca2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2ca9:	8b 45 08             	mov    0x8(%ebp),%eax
    2cac:	01 d0                	add    %edx,%eax
    2cae:	8b 00                	mov    (%eax),%eax
    2cb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2cb3:	83 c2 05             	add    $0x5,%edx
    2cb6:	01 d0                	add    %edx,%eax
    2cb8:	0f b6 00             	movzbl (%eax),%eax
    2cbb:	0f be c0             	movsbl %al,%eax
    2cbe:	83 ec 04             	sub    $0x4,%esp
    2cc1:	50                   	push   %eax
    2cc2:	68 57 59 00 00       	push   $0x5957
    2cc7:	6a 01                	push   $0x1
    2cc9:	e8 d6 1a 00 00       	call   47a4 <printf>
    2cce:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+6]);
    2cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2cd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2cdb:	8b 45 08             	mov    0x8(%ebp),%eax
    2cde:	01 d0                	add    %edx,%eax
    2ce0:	8b 00                	mov    (%eax),%eax
    2ce2:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2ce5:	83 c2 06             	add    $0x6,%edx
    2ce8:	01 d0                	add    %edx,%eax
    2cea:	0f b6 00             	movzbl (%eax),%eax
    2ced:	0f be c0             	movsbl %al,%eax
    2cf0:	83 ec 04             	sub    $0x4,%esp
    2cf3:	50                   	push   %eax
    2cf4:	68 57 59 00 00       	push   $0x5957
    2cf9:	6a 01                	push   $0x1
    2cfb:	e8 a4 1a 00 00       	call   47a4 <printf>
    2d00:	83 c4 10             	add    $0x10,%esp
					mark = mark + 7;
    2d03:	83 45 e8 07          	addl   $0x7,-0x18(%ebp)
    2d07:	e9 c4 13 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// for
				else if((mark+2)<MAX_LINE_LENGTH && text[j][mark] == 'f' && text[j][mark+1] == 'o' && text[j][mark+2] == 'r'){
    2d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2d0f:	83 c0 02             	add    $0x2,%eax
    2d12:	3d ff 00 00 00       	cmp    $0xff,%eax
    2d17:	0f 8f 05 01 00 00    	jg     2e22 <show_text_syntax_highlighting+0x1091>
    2d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2d27:	8b 45 08             	mov    0x8(%ebp),%eax
    2d2a:	01 d0                	add    %edx,%eax
    2d2c:	8b 10                	mov    (%eax),%edx
    2d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2d31:	01 d0                	add    %edx,%eax
    2d33:	0f b6 00             	movzbl (%eax),%eax
    2d36:	3c 66                	cmp    $0x66,%al
    2d38:	0f 85 e4 00 00 00    	jne    2e22 <show_text_syntax_highlighting+0x1091>
    2d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2d48:	8b 45 08             	mov    0x8(%ebp),%eax
    2d4b:	01 d0                	add    %edx,%eax
    2d4d:	8b 00                	mov    (%eax),%eax
    2d4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2d52:	83 c2 01             	add    $0x1,%edx
    2d55:	01 d0                	add    %edx,%eax
    2d57:	0f b6 00             	movzbl (%eax),%eax
    2d5a:	3c 6f                	cmp    $0x6f,%al
    2d5c:	0f 85 c0 00 00 00    	jne    2e22 <show_text_syntax_highlighting+0x1091>
    2d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2d6c:	8b 45 08             	mov    0x8(%ebp),%eax
    2d6f:	01 d0                	add    %edx,%eax
    2d71:	8b 00                	mov    (%eax),%eax
    2d73:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2d76:	83 c2 02             	add    $0x2,%edx
    2d79:	01 d0                	add    %edx,%eax
    2d7b:	0f b6 00             	movzbl (%eax),%eax
    2d7e:	3c 72                	cmp    $0x72,%al
    2d80:	0f 85 9c 00 00 00    	jne    2e22 <show_text_syntax_highlighting+0x1091>
					// highlighting 'int' string
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    2d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2d89:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2d90:	8b 45 08             	mov    0x8(%ebp),%eax
    2d93:	01 d0                	add    %edx,%eax
    2d95:	8b 10                	mov    (%eax),%edx
    2d97:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2d9a:	01 d0                	add    %edx,%eax
    2d9c:	0f b6 00             	movzbl (%eax),%eax
    2d9f:	0f be c0             	movsbl %al,%eax
    2da2:	83 ec 04             	sub    $0x4,%esp
    2da5:	50                   	push   %eax
    2da6:	68 57 59 00 00       	push   $0x5957
    2dab:	6a 01                	push   $0x1
    2dad:	e8 f2 19 00 00       	call   47a4 <printf>
    2db2:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
    2db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2db8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2dbf:	8b 45 08             	mov    0x8(%ebp),%eax
    2dc2:	01 d0                	add    %edx,%eax
    2dc4:	8b 00                	mov    (%eax),%eax
    2dc6:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2dc9:	83 c2 01             	add    $0x1,%edx
    2dcc:	01 d0                	add    %edx,%eax
    2dce:	0f b6 00             	movzbl (%eax),%eax
    2dd1:	0f be c0             	movsbl %al,%eax
    2dd4:	83 ec 04             	sub    $0x4,%esp
    2dd7:	50                   	push   %eax
    2dd8:	68 57 59 00 00       	push   $0x5957
    2ddd:	6a 01                	push   $0x1
    2ddf:	e8 c0 19 00 00       	call   47a4 <printf>
    2de4:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
    2de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2dea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2df1:	8b 45 08             	mov    0x8(%ebp),%eax
    2df4:	01 d0                	add    %edx,%eax
    2df6:	8b 00                	mov    (%eax),%eax
    2df8:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2dfb:	83 c2 02             	add    $0x2,%edx
    2dfe:	01 d0                	add    %edx,%eax
    2e00:	0f b6 00             	movzbl (%eax),%eax
    2e03:	0f be c0             	movsbl %al,%eax
    2e06:	83 ec 04             	sub    $0x4,%esp
    2e09:	50                   	push   %eax
    2e0a:	68 57 59 00 00       	push   $0x5957
    2e0f:	6a 01                	push   $0x1
    2e11:	e8 8e 19 00 00       	call   47a4 <printf>
    2e16:	83 c4 10             	add    $0x10,%esp
					mark = mark + 3;
    2e19:	83 45 e8 03          	addl   $0x3,-0x18(%ebp)
    2e1d:	e9 ae 12 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// while
				else if((mark+4)<MAX_LINE_LENGTH && text[j][mark] == 'w' && text[j][mark+1] == 'h' && text[j][mark+2] == 'i'
    2e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e25:	83 c0 04             	add    $0x4,%eax
    2e28:	3d ff 00 00 00       	cmp    $0xff,%eax
    2e2d:	0f 8f b1 01 00 00    	jg     2fe4 <show_text_syntax_highlighting+0x1253>
    2e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2e3d:	8b 45 08             	mov    0x8(%ebp),%eax
    2e40:	01 d0                	add    %edx,%eax
    2e42:	8b 10                	mov    (%eax),%edx
    2e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e47:	01 d0                	add    %edx,%eax
    2e49:	0f b6 00             	movzbl (%eax),%eax
    2e4c:	3c 77                	cmp    $0x77,%al
    2e4e:	0f 85 90 01 00 00    	jne    2fe4 <show_text_syntax_highlighting+0x1253>
    2e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2e5e:	8b 45 08             	mov    0x8(%ebp),%eax
    2e61:	01 d0                	add    %edx,%eax
    2e63:	8b 00                	mov    (%eax),%eax
    2e65:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2e68:	83 c2 01             	add    $0x1,%edx
    2e6b:	01 d0                	add    %edx,%eax
    2e6d:	0f b6 00             	movzbl (%eax),%eax
    2e70:	3c 68                	cmp    $0x68,%al
    2e72:	0f 85 6c 01 00 00    	jne    2fe4 <show_text_syntax_highlighting+0x1253>
    2e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e7b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2e82:	8b 45 08             	mov    0x8(%ebp),%eax
    2e85:	01 d0                	add    %edx,%eax
    2e87:	8b 00                	mov    (%eax),%eax
    2e89:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2e8c:	83 c2 02             	add    $0x2,%edx
    2e8f:	01 d0                	add    %edx,%eax
    2e91:	0f b6 00             	movzbl (%eax),%eax
    2e94:	3c 69                	cmp    $0x69,%al
    2e96:	0f 85 48 01 00 00    	jne    2fe4 <show_text_syntax_highlighting+0x1253>
					&& text[j][mark+3] == 'l' && text[j][mark+4] == 'e'){
    2e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2ea6:	8b 45 08             	mov    0x8(%ebp),%eax
    2ea9:	01 d0                	add    %edx,%eax
    2eab:	8b 00                	mov    (%eax),%eax
    2ead:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2eb0:	83 c2 03             	add    $0x3,%edx
    2eb3:	01 d0                	add    %edx,%eax
    2eb5:	0f b6 00             	movzbl (%eax),%eax
    2eb8:	3c 6c                	cmp    $0x6c,%al
    2eba:	0f 85 24 01 00 00    	jne    2fe4 <show_text_syntax_highlighting+0x1253>
    2ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ec3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2eca:	8b 45 08             	mov    0x8(%ebp),%eax
    2ecd:	01 d0                	add    %edx,%eax
    2ecf:	8b 00                	mov    (%eax),%eax
    2ed1:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2ed4:	83 c2 04             	add    $0x4,%edx
    2ed7:	01 d0                	add    %edx,%eax
    2ed9:	0f b6 00             	movzbl (%eax),%eax
    2edc:	3c 65                	cmp    $0x65,%al
    2ede:	0f 85 00 01 00 00    	jne    2fe4 <show_text_syntax_highlighting+0x1253>
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    2ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2eee:	8b 45 08             	mov    0x8(%ebp),%eax
    2ef1:	01 d0                	add    %edx,%eax
    2ef3:	8b 10                	mov    (%eax),%edx
    2ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2ef8:	01 d0                	add    %edx,%eax
    2efa:	0f b6 00             	movzbl (%eax),%eax
    2efd:	0f be c0             	movsbl %al,%eax
    2f00:	83 ec 04             	sub    $0x4,%esp
    2f03:	50                   	push   %eax
    2f04:	68 57 59 00 00       	push   $0x5957
    2f09:	6a 01                	push   $0x1
    2f0b:	e8 94 18 00 00       	call   47a4 <printf>
    2f10:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
    2f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2f1d:	8b 45 08             	mov    0x8(%ebp),%eax
    2f20:	01 d0                	add    %edx,%eax
    2f22:	8b 00                	mov    (%eax),%eax
    2f24:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2f27:	83 c2 01             	add    $0x1,%edx
    2f2a:	01 d0                	add    %edx,%eax
    2f2c:	0f b6 00             	movzbl (%eax),%eax
    2f2f:	0f be c0             	movsbl %al,%eax
    2f32:	83 ec 04             	sub    $0x4,%esp
    2f35:	50                   	push   %eax
    2f36:	68 57 59 00 00       	push   $0x5957
    2f3b:	6a 01                	push   $0x1
    2f3d:	e8 62 18 00 00       	call   47a4 <printf>
    2f42:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
    2f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2f4f:	8b 45 08             	mov    0x8(%ebp),%eax
    2f52:	01 d0                	add    %edx,%eax
    2f54:	8b 00                	mov    (%eax),%eax
    2f56:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2f59:	83 c2 02             	add    $0x2,%edx
    2f5c:	01 d0                	add    %edx,%eax
    2f5e:	0f b6 00             	movzbl (%eax),%eax
    2f61:	0f be c0             	movsbl %al,%eax
    2f64:	83 ec 04             	sub    $0x4,%esp
    2f67:	50                   	push   %eax
    2f68:	68 57 59 00 00       	push   $0x5957
    2f6d:	6a 01                	push   $0x1
    2f6f:	e8 30 18 00 00       	call   47a4 <printf>
    2f74:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
    2f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2f81:	8b 45 08             	mov    0x8(%ebp),%eax
    2f84:	01 d0                	add    %edx,%eax
    2f86:	8b 00                	mov    (%eax),%eax
    2f88:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2f8b:	83 c2 03             	add    $0x3,%edx
    2f8e:	01 d0                	add    %edx,%eax
    2f90:	0f b6 00             	movzbl (%eax),%eax
    2f93:	0f be c0             	movsbl %al,%eax
    2f96:	83 ec 04             	sub    $0x4,%esp
    2f99:	50                   	push   %eax
    2f9a:	68 57 59 00 00       	push   $0x5957
    2f9f:	6a 01                	push   $0x1
    2fa1:	e8 fe 17 00 00       	call   47a4 <printf>
    2fa6:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+4]);
    2fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2fac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2fb3:	8b 45 08             	mov    0x8(%ebp),%eax
    2fb6:	01 d0                	add    %edx,%eax
    2fb8:	8b 00                	mov    (%eax),%eax
    2fba:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2fbd:	83 c2 04             	add    $0x4,%edx
    2fc0:	01 d0                	add    %edx,%eax
    2fc2:	0f b6 00             	movzbl (%eax),%eax
    2fc5:	0f be c0             	movsbl %al,%eax
    2fc8:	83 ec 04             	sub    $0x4,%esp
    2fcb:	50                   	push   %eax
    2fcc:	68 57 59 00 00       	push   $0x5957
    2fd1:	6a 01                	push   $0x1
    2fd3:	e8 cc 17 00 00       	call   47a4 <printf>
    2fd8:	83 c4 10             	add    $0x10,%esp
					mark = mark + 5;
    2fdb:	83 45 e8 05          	addl   $0x5,-0x18(%ebp)
    2fdf:	e9 ec 10 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// long
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'l' && text[j][mark+1] == 'o' && text[j][mark+2] == 'n'
    2fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2fe7:	83 c0 03             	add    $0x3,%eax
    2fea:	3d ff 00 00 00       	cmp    $0xff,%eax
    2fef:	0f 8f 5b 01 00 00    	jg     3150 <show_text_syntax_highlighting+0x13bf>
    2ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ff8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    2fff:	8b 45 08             	mov    0x8(%ebp),%eax
    3002:	01 d0                	add    %edx,%eax
    3004:	8b 10                	mov    (%eax),%edx
    3006:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3009:	01 d0                	add    %edx,%eax
    300b:	0f b6 00             	movzbl (%eax),%eax
    300e:	3c 6c                	cmp    $0x6c,%al
    3010:	0f 85 3a 01 00 00    	jne    3150 <show_text_syntax_highlighting+0x13bf>
    3016:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3020:	8b 45 08             	mov    0x8(%ebp),%eax
    3023:	01 d0                	add    %edx,%eax
    3025:	8b 00                	mov    (%eax),%eax
    3027:	8b 55 e8             	mov    -0x18(%ebp),%edx
    302a:	83 c2 01             	add    $0x1,%edx
    302d:	01 d0                	add    %edx,%eax
    302f:	0f b6 00             	movzbl (%eax),%eax
    3032:	3c 6f                	cmp    $0x6f,%al
    3034:	0f 85 16 01 00 00    	jne    3150 <show_text_syntax_highlighting+0x13bf>
    303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    303d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3044:	8b 45 08             	mov    0x8(%ebp),%eax
    3047:	01 d0                	add    %edx,%eax
    3049:	8b 00                	mov    (%eax),%eax
    304b:	8b 55 e8             	mov    -0x18(%ebp),%edx
    304e:	83 c2 02             	add    $0x2,%edx
    3051:	01 d0                	add    %edx,%eax
    3053:	0f b6 00             	movzbl (%eax),%eax
    3056:	3c 6e                	cmp    $0x6e,%al
    3058:	0f 85 f2 00 00 00    	jne    3150 <show_text_syntax_highlighting+0x13bf>
					&& text[j][mark+3] == 'g'){
    305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3061:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3068:	8b 45 08             	mov    0x8(%ebp),%eax
    306b:	01 d0                	add    %edx,%eax
    306d:	8b 00                	mov    (%eax),%eax
    306f:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3072:	83 c2 03             	add    $0x3,%edx
    3075:	01 d0                	add    %edx,%eax
    3077:	0f b6 00             	movzbl (%eax),%eax
    307a:	3c 67                	cmp    $0x67,%al
    307c:	0f 85 ce 00 00 00    	jne    3150 <show_text_syntax_highlighting+0x13bf>
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    3082:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3085:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    308c:	8b 45 08             	mov    0x8(%ebp),%eax
    308f:	01 d0                	add    %edx,%eax
    3091:	8b 10                	mov    (%eax),%edx
    3093:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3096:	01 d0                	add    %edx,%eax
    3098:	0f b6 00             	movzbl (%eax),%eax
    309b:	0f be c0             	movsbl %al,%eax
    309e:	83 ec 04             	sub    $0x4,%esp
    30a1:	50                   	push   %eax
    30a2:	68 49 59 00 00       	push   $0x5949
    30a7:	6a 01                	push   $0x1
    30a9:	e8 f6 16 00 00       	call   47a4 <printf>
    30ae:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    30b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    30b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    30bb:	8b 45 08             	mov    0x8(%ebp),%eax
    30be:	01 d0                	add    %edx,%eax
    30c0:	8b 00                	mov    (%eax),%eax
    30c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
    30c5:	83 c2 01             	add    $0x1,%edx
    30c8:	01 d0                	add    %edx,%eax
    30ca:	0f b6 00             	movzbl (%eax),%eax
    30cd:	0f be c0             	movsbl %al,%eax
    30d0:	83 ec 04             	sub    $0x4,%esp
    30d3:	50                   	push   %eax
    30d4:	68 49 59 00 00       	push   $0x5949
    30d9:	6a 01                	push   $0x1
    30db:	e8 c4 16 00 00       	call   47a4 <printf>
    30e0:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    30e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    30e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    30ed:	8b 45 08             	mov    0x8(%ebp),%eax
    30f0:	01 d0                	add    %edx,%eax
    30f2:	8b 00                	mov    (%eax),%eax
    30f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
    30f7:	83 c2 02             	add    $0x2,%edx
    30fa:	01 d0                	add    %edx,%eax
    30fc:	0f b6 00             	movzbl (%eax),%eax
    30ff:	0f be c0             	movsbl %al,%eax
    3102:	83 ec 04             	sub    $0x4,%esp
    3105:	50                   	push   %eax
    3106:	68 49 59 00 00       	push   $0x5949
    310b:	6a 01                	push   $0x1
    310d:	e8 92 16 00 00       	call   47a4 <printf>
    3112:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
    3115:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3118:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    311f:	8b 45 08             	mov    0x8(%ebp),%eax
    3122:	01 d0                	add    %edx,%eax
    3124:	8b 00                	mov    (%eax),%eax
    3126:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3129:	83 c2 03             	add    $0x3,%edx
    312c:	01 d0                	add    %edx,%eax
    312e:	0f b6 00             	movzbl (%eax),%eax
    3131:	0f be c0             	movsbl %al,%eax
    3134:	83 ec 04             	sub    $0x4,%esp
    3137:	50                   	push   %eax
    3138:	68 49 59 00 00       	push   $0x5949
    313d:	6a 01                	push   $0x1
    313f:	e8 60 16 00 00       	call   47a4 <printf>
    3144:	83 c4 10             	add    $0x10,%esp
					mark = mark + 4;
    3147:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    314b:	e9 80 0f 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// {}[]()
				else if(text[j][mark] == '{' || text[j][mark] == '}' || text[j][mark] == '[' || text[j][mark] == ']'
    3150:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3153:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    315a:	8b 45 08             	mov    0x8(%ebp),%eax
    315d:	01 d0                	add    %edx,%eax
    315f:	8b 10                	mov    (%eax),%edx
    3161:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3164:	01 d0                	add    %edx,%eax
    3166:	0f b6 00             	movzbl (%eax),%eax
    3169:	3c 7b                	cmp    $0x7b,%al
    316b:	0f 84 91 00 00 00    	je     3202 <show_text_syntax_highlighting+0x1471>
    3171:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    317b:	8b 45 08             	mov    0x8(%ebp),%eax
    317e:	01 d0                	add    %edx,%eax
    3180:	8b 10                	mov    (%eax),%edx
    3182:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3185:	01 d0                	add    %edx,%eax
    3187:	0f b6 00             	movzbl (%eax),%eax
    318a:	3c 7d                	cmp    $0x7d,%al
    318c:	74 74                	je     3202 <show_text_syntax_highlighting+0x1471>
    318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3191:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3198:	8b 45 08             	mov    0x8(%ebp),%eax
    319b:	01 d0                	add    %edx,%eax
    319d:	8b 10                	mov    (%eax),%edx
    319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31a2:	01 d0                	add    %edx,%eax
    31a4:	0f b6 00             	movzbl (%eax),%eax
    31a7:	3c 5b                	cmp    $0x5b,%al
    31a9:	74 57                	je     3202 <show_text_syntax_highlighting+0x1471>
    31ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    31b5:	8b 45 08             	mov    0x8(%ebp),%eax
    31b8:	01 d0                	add    %edx,%eax
    31ba:	8b 10                	mov    (%eax),%edx
    31bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31bf:	01 d0                	add    %edx,%eax
    31c1:	0f b6 00             	movzbl (%eax),%eax
    31c4:	3c 5d                	cmp    $0x5d,%al
    31c6:	74 3a                	je     3202 <show_text_syntax_highlighting+0x1471>
					|| text[j][mark] == '(' || text[j][mark] == ')'){
    31c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    31d2:	8b 45 08             	mov    0x8(%ebp),%eax
    31d5:	01 d0                	add    %edx,%eax
    31d7:	8b 10                	mov    (%eax),%edx
    31d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31dc:	01 d0                	add    %edx,%eax
    31de:	0f b6 00             	movzbl (%eax),%eax
    31e1:	3c 28                	cmp    $0x28,%al
    31e3:	74 1d                	je     3202 <show_text_syntax_highlighting+0x1471>
    31e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    31ef:	8b 45 08             	mov    0x8(%ebp),%eax
    31f2:	01 d0                	add    %edx,%eax
    31f4:	8b 10                	mov    (%eax),%edx
    31f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    31f9:	01 d0                	add    %edx,%eax
    31fb:	0f b6 00             	movzbl (%eax),%eax
    31fe:	3c 29                	cmp    $0x29,%al
    3200:	75 38                	jne    323a <show_text_syntax_highlighting+0x14a9>
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    3202:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3205:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    320c:	8b 45 08             	mov    0x8(%ebp),%eax
    320f:	01 d0                	add    %edx,%eax
    3211:	8b 10                	mov    (%eax),%edx
    3213:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3216:	01 d0                	add    %edx,%eax
    3218:	0f b6 00             	movzbl (%eax),%eax
    321b:	0f be c0             	movsbl %al,%eax
    321e:	83 ec 04             	sub    $0x4,%esp
    3221:	50                   	push   %eax
    3222:	68 57 59 00 00       	push   $0x5957
    3227:	6a 01                	push   $0x1
    3229:	e8 76 15 00 00       	call   47a4 <printf>
    322e:	83 c4 10             	add    $0x10,%esp
					mark++;
    3231:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    3235:	e9 96 0e 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// static
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 's' && text[j][mark+1] == 't' && text[j][mark+2] == 'a'
    323a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    323d:	83 c0 05             	add    $0x5,%eax
    3240:	3d ff 00 00 00       	cmp    $0xff,%eax
    3245:	0f 8f 07 02 00 00    	jg     3452 <show_text_syntax_highlighting+0x16c1>
    324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    324e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3255:	8b 45 08             	mov    0x8(%ebp),%eax
    3258:	01 d0                	add    %edx,%eax
    325a:	8b 10                	mov    (%eax),%edx
    325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    325f:	01 d0                	add    %edx,%eax
    3261:	0f b6 00             	movzbl (%eax),%eax
    3264:	3c 73                	cmp    $0x73,%al
    3266:	0f 85 e6 01 00 00    	jne    3452 <show_text_syntax_highlighting+0x16c1>
    326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    326f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3276:	8b 45 08             	mov    0x8(%ebp),%eax
    3279:	01 d0                	add    %edx,%eax
    327b:	8b 00                	mov    (%eax),%eax
    327d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3280:	83 c2 01             	add    $0x1,%edx
    3283:	01 d0                	add    %edx,%eax
    3285:	0f b6 00             	movzbl (%eax),%eax
    3288:	3c 74                	cmp    $0x74,%al
    328a:	0f 85 c2 01 00 00    	jne    3452 <show_text_syntax_highlighting+0x16c1>
    3290:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3293:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    329a:	8b 45 08             	mov    0x8(%ebp),%eax
    329d:	01 d0                	add    %edx,%eax
    329f:	8b 00                	mov    (%eax),%eax
    32a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
    32a4:	83 c2 02             	add    $0x2,%edx
    32a7:	01 d0                	add    %edx,%eax
    32a9:	0f b6 00             	movzbl (%eax),%eax
    32ac:	3c 61                	cmp    $0x61,%al
    32ae:	0f 85 9e 01 00 00    	jne    3452 <show_text_syntax_highlighting+0x16c1>
					&& text[j][mark+3] == 't' && text[j][mark+4] == 'i' && text[j][mark+5] == 'c'){
    32b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    32be:	8b 45 08             	mov    0x8(%ebp),%eax
    32c1:	01 d0                	add    %edx,%eax
    32c3:	8b 00                	mov    (%eax),%eax
    32c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    32c8:	83 c2 03             	add    $0x3,%edx
    32cb:	01 d0                	add    %edx,%eax
    32cd:	0f b6 00             	movzbl (%eax),%eax
    32d0:	3c 74                	cmp    $0x74,%al
    32d2:	0f 85 7a 01 00 00    	jne    3452 <show_text_syntax_highlighting+0x16c1>
    32d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    32e2:	8b 45 08             	mov    0x8(%ebp),%eax
    32e5:	01 d0                	add    %edx,%eax
    32e7:	8b 00                	mov    (%eax),%eax
    32e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
    32ec:	83 c2 04             	add    $0x4,%edx
    32ef:	01 d0                	add    %edx,%eax
    32f1:	0f b6 00             	movzbl (%eax),%eax
    32f4:	3c 69                	cmp    $0x69,%al
    32f6:	0f 85 56 01 00 00    	jne    3452 <show_text_syntax_highlighting+0x16c1>
    32fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3306:	8b 45 08             	mov    0x8(%ebp),%eax
    3309:	01 d0                	add    %edx,%eax
    330b:	8b 00                	mov    (%eax),%eax
    330d:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3310:	83 c2 05             	add    $0x5,%edx
    3313:	01 d0                	add    %edx,%eax
    3315:	0f b6 00             	movzbl (%eax),%eax
    3318:	3c 63                	cmp    $0x63,%al
    331a:	0f 85 32 01 00 00    	jne    3452 <show_text_syntax_highlighting+0x16c1>
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    3320:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    332a:	8b 45 08             	mov    0x8(%ebp),%eax
    332d:	01 d0                	add    %edx,%eax
    332f:	8b 10                	mov    (%eax),%edx
    3331:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3334:	01 d0                	add    %edx,%eax
    3336:	0f b6 00             	movzbl (%eax),%eax
    3339:	0f be c0             	movsbl %al,%eax
    333c:	83 ec 04             	sub    $0x4,%esp
    333f:	50                   	push   %eax
    3340:	68 49 59 00 00       	push   $0x5949
    3345:	6a 01                	push   $0x1
    3347:	e8 58 14 00 00       	call   47a4 <printf>
    334c:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3352:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3359:	8b 45 08             	mov    0x8(%ebp),%eax
    335c:	01 d0                	add    %edx,%eax
    335e:	8b 00                	mov    (%eax),%eax
    3360:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3363:	83 c2 01             	add    $0x1,%edx
    3366:	01 d0                	add    %edx,%eax
    3368:	0f b6 00             	movzbl (%eax),%eax
    336b:	0f be c0             	movsbl %al,%eax
    336e:	83 ec 04             	sub    $0x4,%esp
    3371:	50                   	push   %eax
    3372:	68 49 59 00 00       	push   $0x5949
    3377:	6a 01                	push   $0x1
    3379:	e8 26 14 00 00       	call   47a4 <printf>
    337e:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    3381:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    338b:	8b 45 08             	mov    0x8(%ebp),%eax
    338e:	01 d0                	add    %edx,%eax
    3390:	8b 00                	mov    (%eax),%eax
    3392:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3395:	83 c2 02             	add    $0x2,%edx
    3398:	01 d0                	add    %edx,%eax
    339a:	0f b6 00             	movzbl (%eax),%eax
    339d:	0f be c0             	movsbl %al,%eax
    33a0:	83 ec 04             	sub    $0x4,%esp
    33a3:	50                   	push   %eax
    33a4:	68 49 59 00 00       	push   $0x5949
    33a9:	6a 01                	push   $0x1
    33ab:	e8 f4 13 00 00       	call   47a4 <printf>
    33b0:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
    33b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    33bd:	8b 45 08             	mov    0x8(%ebp),%eax
    33c0:	01 d0                	add    %edx,%eax
    33c2:	8b 00                	mov    (%eax),%eax
    33c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
    33c7:	83 c2 03             	add    $0x3,%edx
    33ca:	01 d0                	add    %edx,%eax
    33cc:	0f b6 00             	movzbl (%eax),%eax
    33cf:	0f be c0             	movsbl %al,%eax
    33d2:	83 ec 04             	sub    $0x4,%esp
    33d5:	50                   	push   %eax
    33d6:	68 49 59 00 00       	push   $0x5949
    33db:	6a 01                	push   $0x1
    33dd:	e8 c2 13 00 00       	call   47a4 <printf>
    33e2:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
    33e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    33ef:	8b 45 08             	mov    0x8(%ebp),%eax
    33f2:	01 d0                	add    %edx,%eax
    33f4:	8b 00                	mov    (%eax),%eax
    33f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
    33f9:	83 c2 04             	add    $0x4,%edx
    33fc:	01 d0                	add    %edx,%eax
    33fe:	0f b6 00             	movzbl (%eax),%eax
    3401:	0f be c0             	movsbl %al,%eax
    3404:	83 ec 04             	sub    $0x4,%esp
    3407:	50                   	push   %eax
    3408:	68 49 59 00 00       	push   $0x5949
    340d:	6a 01                	push   $0x1
    340f:	e8 90 13 00 00       	call   47a4 <printf>
    3414:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+5]);
    3417:	8b 45 f4             	mov    -0xc(%ebp),%eax
    341a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3421:	8b 45 08             	mov    0x8(%ebp),%eax
    3424:	01 d0                	add    %edx,%eax
    3426:	8b 00                	mov    (%eax),%eax
    3428:	8b 55 e8             	mov    -0x18(%ebp),%edx
    342b:	83 c2 05             	add    $0x5,%edx
    342e:	01 d0                	add    %edx,%eax
    3430:	0f b6 00             	movzbl (%eax),%eax
    3433:	0f be c0             	movsbl %al,%eax
    3436:	83 ec 04             	sub    $0x4,%esp
    3439:	50                   	push   %eax
    343a:	68 49 59 00 00       	push   $0x5949
    343f:	6a 01                	push   $0x1
    3441:	e8 5e 13 00 00       	call   47a4 <printf>
    3446:	83 c4 10             	add    $0x10,%esp
					mark = mark + 6;
    3449:	83 45 e8 06          	addl   $0x6,-0x18(%ebp)
    344d:	e9 7e 0c 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// const
				else if((mark+4)<MAX_LINE_LENGTH && text[j][mark] == 'c' && text[j][mark+1] == 'o' && text[j][mark+2] == 'n'
    3452:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3455:	83 c0 04             	add    $0x4,%eax
    3458:	3d ff 00 00 00       	cmp    $0xff,%eax
    345d:	0f 8f b1 01 00 00    	jg     3614 <show_text_syntax_highlighting+0x1883>
    3463:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3466:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    346d:	8b 45 08             	mov    0x8(%ebp),%eax
    3470:	01 d0                	add    %edx,%eax
    3472:	8b 10                	mov    (%eax),%edx
    3474:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3477:	01 d0                	add    %edx,%eax
    3479:	0f b6 00             	movzbl (%eax),%eax
    347c:	3c 63                	cmp    $0x63,%al
    347e:	0f 85 90 01 00 00    	jne    3614 <show_text_syntax_highlighting+0x1883>
    3484:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3487:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    348e:	8b 45 08             	mov    0x8(%ebp),%eax
    3491:	01 d0                	add    %edx,%eax
    3493:	8b 00                	mov    (%eax),%eax
    3495:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3498:	83 c2 01             	add    $0x1,%edx
    349b:	01 d0                	add    %edx,%eax
    349d:	0f b6 00             	movzbl (%eax),%eax
    34a0:	3c 6f                	cmp    $0x6f,%al
    34a2:	0f 85 6c 01 00 00    	jne    3614 <show_text_syntax_highlighting+0x1883>
    34a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    34b2:	8b 45 08             	mov    0x8(%ebp),%eax
    34b5:	01 d0                	add    %edx,%eax
    34b7:	8b 00                	mov    (%eax),%eax
    34b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
    34bc:	83 c2 02             	add    $0x2,%edx
    34bf:	01 d0                	add    %edx,%eax
    34c1:	0f b6 00             	movzbl (%eax),%eax
    34c4:	3c 6e                	cmp    $0x6e,%al
    34c6:	0f 85 48 01 00 00    	jne    3614 <show_text_syntax_highlighting+0x1883>
					&& text[j][mark+3] == 's' && text[j][mark+4] == 't'){
    34cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    34d6:	8b 45 08             	mov    0x8(%ebp),%eax
    34d9:	01 d0                	add    %edx,%eax
    34db:	8b 00                	mov    (%eax),%eax
    34dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
    34e0:	83 c2 03             	add    $0x3,%edx
    34e3:	01 d0                	add    %edx,%eax
    34e5:	0f b6 00             	movzbl (%eax),%eax
    34e8:	3c 73                	cmp    $0x73,%al
    34ea:	0f 85 24 01 00 00    	jne    3614 <show_text_syntax_highlighting+0x1883>
    34f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    34f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    34fa:	8b 45 08             	mov    0x8(%ebp),%eax
    34fd:	01 d0                	add    %edx,%eax
    34ff:	8b 00                	mov    (%eax),%eax
    3501:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3504:	83 c2 04             	add    $0x4,%edx
    3507:	01 d0                	add    %edx,%eax
    3509:	0f b6 00             	movzbl (%eax),%eax
    350c:	3c 74                	cmp    $0x74,%al
    350e:	0f 85 00 01 00 00    	jne    3614 <show_text_syntax_highlighting+0x1883>
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    3514:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    351e:	8b 45 08             	mov    0x8(%ebp),%eax
    3521:	01 d0                	add    %edx,%eax
    3523:	8b 10                	mov    (%eax),%edx
    3525:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3528:	01 d0                	add    %edx,%eax
    352a:	0f b6 00             	movzbl (%eax),%eax
    352d:	0f be c0             	movsbl %al,%eax
    3530:	83 ec 04             	sub    $0x4,%esp
    3533:	50                   	push   %eax
    3534:	68 49 59 00 00       	push   $0x5949
    3539:	6a 01                	push   $0x1
    353b:	e8 64 12 00 00       	call   47a4 <printf>
    3540:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    3543:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3546:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    354d:	8b 45 08             	mov    0x8(%ebp),%eax
    3550:	01 d0                	add    %edx,%eax
    3552:	8b 00                	mov    (%eax),%eax
    3554:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3557:	83 c2 01             	add    $0x1,%edx
    355a:	01 d0                	add    %edx,%eax
    355c:	0f b6 00             	movzbl (%eax),%eax
    355f:	0f be c0             	movsbl %al,%eax
    3562:	83 ec 04             	sub    $0x4,%esp
    3565:	50                   	push   %eax
    3566:	68 49 59 00 00       	push   $0x5949
    356b:	6a 01                	push   $0x1
    356d:	e8 32 12 00 00       	call   47a4 <printf>
    3572:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    3575:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3578:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    357f:	8b 45 08             	mov    0x8(%ebp),%eax
    3582:	01 d0                	add    %edx,%eax
    3584:	8b 00                	mov    (%eax),%eax
    3586:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3589:	83 c2 02             	add    $0x2,%edx
    358c:	01 d0                	add    %edx,%eax
    358e:	0f b6 00             	movzbl (%eax),%eax
    3591:	0f be c0             	movsbl %al,%eax
    3594:	83 ec 04             	sub    $0x4,%esp
    3597:	50                   	push   %eax
    3598:	68 49 59 00 00       	push   $0x5949
    359d:	6a 01                	push   $0x1
    359f:	e8 00 12 00 00       	call   47a4 <printf>
    35a4:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
    35a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    35aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    35b1:	8b 45 08             	mov    0x8(%ebp),%eax
    35b4:	01 d0                	add    %edx,%eax
    35b6:	8b 00                	mov    (%eax),%eax
    35b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
    35bb:	83 c2 03             	add    $0x3,%edx
    35be:	01 d0                	add    %edx,%eax
    35c0:	0f b6 00             	movzbl (%eax),%eax
    35c3:	0f be c0             	movsbl %al,%eax
    35c6:	83 ec 04             	sub    $0x4,%esp
    35c9:	50                   	push   %eax
    35ca:	68 49 59 00 00       	push   $0x5949
    35cf:	6a 01                	push   $0x1
    35d1:	e8 ce 11 00 00       	call   47a4 <printf>
    35d6:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
    35d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    35dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    35e3:	8b 45 08             	mov    0x8(%ebp),%eax
    35e6:	01 d0                	add    %edx,%eax
    35e8:	8b 00                	mov    (%eax),%eax
    35ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
    35ed:	83 c2 04             	add    $0x4,%edx
    35f0:	01 d0                	add    %edx,%eax
    35f2:	0f b6 00             	movzbl (%eax),%eax
    35f5:	0f be c0             	movsbl %al,%eax
    35f8:	83 ec 04             	sub    $0x4,%esp
    35fb:	50                   	push   %eax
    35fc:	68 49 59 00 00       	push   $0x5949
    3601:	6a 01                	push   $0x1
    3603:	e8 9c 11 00 00       	call   47a4 <printf>
    3608:	83 c4 10             	add    $0x10,%esp
					mark = mark + 5;
    360b:	83 45 e8 05          	addl   $0x5,-0x18(%ebp)
    360f:	e9 bc 0a 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// memset
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'm' && text[j][mark+1] == 'e' && text[j][mark+2] == 'm'
    3614:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3617:	83 c0 05             	add    $0x5,%eax
    361a:	3d ff 00 00 00       	cmp    $0xff,%eax
    361f:	0f 8f 07 02 00 00    	jg     382c <show_text_syntax_highlighting+0x1a9b>
    3625:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    362f:	8b 45 08             	mov    0x8(%ebp),%eax
    3632:	01 d0                	add    %edx,%eax
    3634:	8b 10                	mov    (%eax),%edx
    3636:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3639:	01 d0                	add    %edx,%eax
    363b:	0f b6 00             	movzbl (%eax),%eax
    363e:	3c 6d                	cmp    $0x6d,%al
    3640:	0f 85 e6 01 00 00    	jne    382c <show_text_syntax_highlighting+0x1a9b>
    3646:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3649:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3650:	8b 45 08             	mov    0x8(%ebp),%eax
    3653:	01 d0                	add    %edx,%eax
    3655:	8b 00                	mov    (%eax),%eax
    3657:	8b 55 e8             	mov    -0x18(%ebp),%edx
    365a:	83 c2 01             	add    $0x1,%edx
    365d:	01 d0                	add    %edx,%eax
    365f:	0f b6 00             	movzbl (%eax),%eax
    3662:	3c 65                	cmp    $0x65,%al
    3664:	0f 85 c2 01 00 00    	jne    382c <show_text_syntax_highlighting+0x1a9b>
    366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    366d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3674:	8b 45 08             	mov    0x8(%ebp),%eax
    3677:	01 d0                	add    %edx,%eax
    3679:	8b 00                	mov    (%eax),%eax
    367b:	8b 55 e8             	mov    -0x18(%ebp),%edx
    367e:	83 c2 02             	add    $0x2,%edx
    3681:	01 d0                	add    %edx,%eax
    3683:	0f b6 00             	movzbl (%eax),%eax
    3686:	3c 6d                	cmp    $0x6d,%al
    3688:	0f 85 9e 01 00 00    	jne    382c <show_text_syntax_highlighting+0x1a9b>
					&& text[j][mark+3] == 's' && text[j][mark+4] == 'e' && text[j][mark+5] == 't'){
    368e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3691:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3698:	8b 45 08             	mov    0x8(%ebp),%eax
    369b:	01 d0                	add    %edx,%eax
    369d:	8b 00                	mov    (%eax),%eax
    369f:	8b 55 e8             	mov    -0x18(%ebp),%edx
    36a2:	83 c2 03             	add    $0x3,%edx
    36a5:	01 d0                	add    %edx,%eax
    36a7:	0f b6 00             	movzbl (%eax),%eax
    36aa:	3c 73                	cmp    $0x73,%al
    36ac:	0f 85 7a 01 00 00    	jne    382c <show_text_syntax_highlighting+0x1a9b>
    36b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    36bc:	8b 45 08             	mov    0x8(%ebp),%eax
    36bf:	01 d0                	add    %edx,%eax
    36c1:	8b 00                	mov    (%eax),%eax
    36c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
    36c6:	83 c2 04             	add    $0x4,%edx
    36c9:	01 d0                	add    %edx,%eax
    36cb:	0f b6 00             	movzbl (%eax),%eax
    36ce:	3c 65                	cmp    $0x65,%al
    36d0:	0f 85 56 01 00 00    	jne    382c <show_text_syntax_highlighting+0x1a9b>
    36d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    36e0:	8b 45 08             	mov    0x8(%ebp),%eax
    36e3:	01 d0                	add    %edx,%eax
    36e5:	8b 00                	mov    (%eax),%eax
    36e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
    36ea:	83 c2 05             	add    $0x5,%edx
    36ed:	01 d0                	add    %edx,%eax
    36ef:	0f b6 00             	movzbl (%eax),%eax
    36f2:	3c 74                	cmp    $0x74,%al
    36f4:	0f 85 32 01 00 00    	jne    382c <show_text_syntax_highlighting+0x1a9b>
					printf(1, "\e[1;36m%c\e[0m", text[j][mark]);
    36fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3704:	8b 45 08             	mov    0x8(%ebp),%eax
    3707:	01 d0                	add    %edx,%eax
    3709:	8b 10                	mov    (%eax),%edx
    370b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    370e:	01 d0                	add    %edx,%eax
    3710:	0f b6 00             	movzbl (%eax),%eax
    3713:	0f be c0             	movsbl %al,%eax
    3716:	83 ec 04             	sub    $0x4,%esp
    3719:	50                   	push   %eax
    371a:	68 3b 59 00 00       	push   $0x593b
    371f:	6a 01                	push   $0x1
    3721:	e8 7e 10 00 00       	call   47a4 <printf>
    3726:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+1]);
    3729:	8b 45 f4             	mov    -0xc(%ebp),%eax
    372c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3733:	8b 45 08             	mov    0x8(%ebp),%eax
    3736:	01 d0                	add    %edx,%eax
    3738:	8b 00                	mov    (%eax),%eax
    373a:	8b 55 e8             	mov    -0x18(%ebp),%edx
    373d:	83 c2 01             	add    $0x1,%edx
    3740:	01 d0                	add    %edx,%eax
    3742:	0f b6 00             	movzbl (%eax),%eax
    3745:	0f be c0             	movsbl %al,%eax
    3748:	83 ec 04             	sub    $0x4,%esp
    374b:	50                   	push   %eax
    374c:	68 3b 59 00 00       	push   $0x593b
    3751:	6a 01                	push   $0x1
    3753:	e8 4c 10 00 00       	call   47a4 <printf>
    3758:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+2]);
    375b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    375e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3765:	8b 45 08             	mov    0x8(%ebp),%eax
    3768:	01 d0                	add    %edx,%eax
    376a:	8b 00                	mov    (%eax),%eax
    376c:	8b 55 e8             	mov    -0x18(%ebp),%edx
    376f:	83 c2 02             	add    $0x2,%edx
    3772:	01 d0                	add    %edx,%eax
    3774:	0f b6 00             	movzbl (%eax),%eax
    3777:	0f be c0             	movsbl %al,%eax
    377a:	83 ec 04             	sub    $0x4,%esp
    377d:	50                   	push   %eax
    377e:	68 3b 59 00 00       	push   $0x593b
    3783:	6a 01                	push   $0x1
    3785:	e8 1a 10 00 00       	call   47a4 <printf>
    378a:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+3]);
    378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3790:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3797:	8b 45 08             	mov    0x8(%ebp),%eax
    379a:	01 d0                	add    %edx,%eax
    379c:	8b 00                	mov    (%eax),%eax
    379e:	8b 55 e8             	mov    -0x18(%ebp),%edx
    37a1:	83 c2 03             	add    $0x3,%edx
    37a4:	01 d0                	add    %edx,%eax
    37a6:	0f b6 00             	movzbl (%eax),%eax
    37a9:	0f be c0             	movsbl %al,%eax
    37ac:	83 ec 04             	sub    $0x4,%esp
    37af:	50                   	push   %eax
    37b0:	68 3b 59 00 00       	push   $0x593b
    37b5:	6a 01                	push   $0x1
    37b7:	e8 e8 0f 00 00       	call   47a4 <printf>
    37bc:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+4]);
    37bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    37c9:	8b 45 08             	mov    0x8(%ebp),%eax
    37cc:	01 d0                	add    %edx,%eax
    37ce:	8b 00                	mov    (%eax),%eax
    37d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
    37d3:	83 c2 04             	add    $0x4,%edx
    37d6:	01 d0                	add    %edx,%eax
    37d8:	0f b6 00             	movzbl (%eax),%eax
    37db:	0f be c0             	movsbl %al,%eax
    37de:	83 ec 04             	sub    $0x4,%esp
    37e1:	50                   	push   %eax
    37e2:	68 3b 59 00 00       	push   $0x593b
    37e7:	6a 01                	push   $0x1
    37e9:	e8 b6 0f 00 00       	call   47a4 <printf>
    37ee:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;36m%c\e[0m", text[j][mark+5]);
    37f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    37f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    37fb:	8b 45 08             	mov    0x8(%ebp),%eax
    37fe:	01 d0                	add    %edx,%eax
    3800:	8b 00                	mov    (%eax),%eax
    3802:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3805:	83 c2 05             	add    $0x5,%edx
    3808:	01 d0                	add    %edx,%eax
    380a:	0f b6 00             	movzbl (%eax),%eax
    380d:	0f be c0             	movsbl %al,%eax
    3810:	83 ec 04             	sub    $0x4,%esp
    3813:	50                   	push   %eax
    3814:	68 3b 59 00 00       	push   $0x593b
    3819:	6a 01                	push   $0x1
    381b:	e8 84 0f 00 00       	call   47a4 <printf>
    3820:	83 c4 10             	add    $0x10,%esp
					mark = mark + 6;
    3823:	83 45 e8 06          	addl   $0x6,-0x18(%ebp)
    3827:	e9 a4 08 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// //
				else if((mark+1)<MAX_LINE_LENGTH && text[j][mark] == '/' && text[j][mark] == '/'){
    382c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    382f:	83 c0 01             	add    $0x1,%eax
    3832:	3d ff 00 00 00       	cmp    $0xff,%eax
    3837:	0f 8f af 00 00 00    	jg     38ec <show_text_syntax_highlighting+0x1b5b>
    383d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3840:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3847:	8b 45 08             	mov    0x8(%ebp),%eax
    384a:	01 d0                	add    %edx,%eax
    384c:	8b 10                	mov    (%eax),%edx
    384e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3851:	01 d0                	add    %edx,%eax
    3853:	0f b6 00             	movzbl (%eax),%eax
    3856:	3c 2f                	cmp    $0x2f,%al
    3858:	0f 85 8e 00 00 00    	jne    38ec <show_text_syntax_highlighting+0x1b5b>
    385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3861:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3868:	8b 45 08             	mov    0x8(%ebp),%eax
    386b:	01 d0                	add    %edx,%eax
    386d:	8b 10                	mov    (%eax),%edx
    386f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3872:	01 d0                	add    %edx,%eax
    3874:	0f b6 00             	movzbl (%eax),%eax
    3877:	3c 2f                	cmp    $0x2f,%al
    3879:	75 71                	jne    38ec <show_text_syntax_highlighting+0x1b5b>
					printf(1, "\e[1;32m%c\e[0m", text[j][mark]);
    387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    387e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3885:	8b 45 08             	mov    0x8(%ebp),%eax
    3888:	01 d0                	add    %edx,%eax
    388a:	8b 10                	mov    (%eax),%edx
    388c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    388f:	01 d0                	add    %edx,%eax
    3891:	0f b6 00             	movzbl (%eax),%eax
    3894:	0f be c0             	movsbl %al,%eax
    3897:	83 ec 04             	sub    $0x4,%esp
    389a:	50                   	push   %eax
    389b:	68 1f 59 00 00       	push   $0x591f
    38a0:	6a 01                	push   $0x1
    38a2:	e8 fd 0e 00 00       	call   47a4 <printf>
    38a7:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;32m%c\e[0m", text[j][mark+1]);
    38aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    38ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    38b4:	8b 45 08             	mov    0x8(%ebp),%eax
    38b7:	01 d0                	add    %edx,%eax
    38b9:	8b 00                	mov    (%eax),%eax
    38bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
    38be:	83 c2 01             	add    $0x1,%edx
    38c1:	01 d0                	add    %edx,%eax
    38c3:	0f b6 00             	movzbl (%eax),%eax
    38c6:	0f be c0             	movsbl %al,%eax
    38c9:	83 ec 04             	sub    $0x4,%esp
    38cc:	50                   	push   %eax
    38cd:	68 1f 59 00 00       	push   $0x591f
    38d2:	6a 01                	push   $0x1
    38d4:	e8 cb 0e 00 00       	call   47a4 <printf>
    38d9:	83 c4 10             	add    $0x10,%esp
					mark = mark + 2;
    38dc:	83 45 e8 02          	addl   $0x2,-0x18(%ebp)
					flag_annotation = 1;
    38e0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    38e7:	e9 e4 07 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// NULL
				else if((mark+3)<MAX_LINE_LENGTH && text[j][mark] == 'N' && text[j][mark+1] == 'U' && text[j][mark+2] == 'L'
    38ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
    38ef:	83 c0 03             	add    $0x3,%eax
    38f2:	3d ff 00 00 00       	cmp    $0xff,%eax
    38f7:	0f 8f 5b 01 00 00    	jg     3a58 <show_text_syntax_highlighting+0x1cc7>
    38fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3900:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3907:	8b 45 08             	mov    0x8(%ebp),%eax
    390a:	01 d0                	add    %edx,%eax
    390c:	8b 10                	mov    (%eax),%edx
    390e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3911:	01 d0                	add    %edx,%eax
    3913:	0f b6 00             	movzbl (%eax),%eax
    3916:	3c 4e                	cmp    $0x4e,%al
    3918:	0f 85 3a 01 00 00    	jne    3a58 <show_text_syntax_highlighting+0x1cc7>
    391e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3921:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3928:	8b 45 08             	mov    0x8(%ebp),%eax
    392b:	01 d0                	add    %edx,%eax
    392d:	8b 00                	mov    (%eax),%eax
    392f:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3932:	83 c2 01             	add    $0x1,%edx
    3935:	01 d0                	add    %edx,%eax
    3937:	0f b6 00             	movzbl (%eax),%eax
    393a:	3c 55                	cmp    $0x55,%al
    393c:	0f 85 16 01 00 00    	jne    3a58 <show_text_syntax_highlighting+0x1cc7>
    3942:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3945:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    394c:	8b 45 08             	mov    0x8(%ebp),%eax
    394f:	01 d0                	add    %edx,%eax
    3951:	8b 00                	mov    (%eax),%eax
    3953:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3956:	83 c2 02             	add    $0x2,%edx
    3959:	01 d0                	add    %edx,%eax
    395b:	0f b6 00             	movzbl (%eax),%eax
    395e:	3c 4c                	cmp    $0x4c,%al
    3960:	0f 85 f2 00 00 00    	jne    3a58 <show_text_syntax_highlighting+0x1cc7>
					&& text[j][mark+3] == 'L'){
    3966:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3970:	8b 45 08             	mov    0x8(%ebp),%eax
    3973:	01 d0                	add    %edx,%eax
    3975:	8b 00                	mov    (%eax),%eax
    3977:	8b 55 e8             	mov    -0x18(%ebp),%edx
    397a:	83 c2 03             	add    $0x3,%edx
    397d:	01 d0                	add    %edx,%eax
    397f:	0f b6 00             	movzbl (%eax),%eax
    3982:	3c 4c                	cmp    $0x4c,%al
    3984:	0f 85 ce 00 00 00    	jne    3a58 <show_text_syntax_highlighting+0x1cc7>
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    398d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3994:	8b 45 08             	mov    0x8(%ebp),%eax
    3997:	01 d0                	add    %edx,%eax
    3999:	8b 10                	mov    (%eax),%edx
    399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    399e:	01 d0                	add    %edx,%eax
    39a0:	0f b6 00             	movzbl (%eax),%eax
    39a3:	0f be c0             	movsbl %al,%eax
    39a6:	83 ec 04             	sub    $0x4,%esp
    39a9:	50                   	push   %eax
    39aa:	68 57 59 00 00       	push   $0x5957
    39af:	6a 01                	push   $0x1
    39b1:	e8 ee 0d 00 00       	call   47a4 <printf>
    39b6:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
    39b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    39bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    39c3:	8b 45 08             	mov    0x8(%ebp),%eax
    39c6:	01 d0                	add    %edx,%eax
    39c8:	8b 00                	mov    (%eax),%eax
    39ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
    39cd:	83 c2 01             	add    $0x1,%edx
    39d0:	01 d0                	add    %edx,%eax
    39d2:	0f b6 00             	movzbl (%eax),%eax
    39d5:	0f be c0             	movsbl %al,%eax
    39d8:	83 ec 04             	sub    $0x4,%esp
    39db:	50                   	push   %eax
    39dc:	68 57 59 00 00       	push   $0x5957
    39e1:	6a 01                	push   $0x1
    39e3:	e8 bc 0d 00 00       	call   47a4 <printf>
    39e8:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
    39eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    39ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    39f5:	8b 45 08             	mov    0x8(%ebp),%eax
    39f8:	01 d0                	add    %edx,%eax
    39fa:	8b 00                	mov    (%eax),%eax
    39fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
    39ff:	83 c2 02             	add    $0x2,%edx
    3a02:	01 d0                	add    %edx,%eax
    3a04:	0f b6 00             	movzbl (%eax),%eax
    3a07:	0f be c0             	movsbl %al,%eax
    3a0a:	83 ec 04             	sub    $0x4,%esp
    3a0d:	50                   	push   %eax
    3a0e:	68 57 59 00 00       	push   $0x5957
    3a13:	6a 01                	push   $0x1
    3a15:	e8 8a 0d 00 00       	call   47a4 <printf>
    3a1a:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
    3a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a27:	8b 45 08             	mov    0x8(%ebp),%eax
    3a2a:	01 d0                	add    %edx,%eax
    3a2c:	8b 00                	mov    (%eax),%eax
    3a2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3a31:	83 c2 03             	add    $0x3,%edx
    3a34:	01 d0                	add    %edx,%eax
    3a36:	0f b6 00             	movzbl (%eax),%eax
    3a39:	0f be c0             	movsbl %al,%eax
    3a3c:	83 ec 04             	sub    $0x4,%esp
    3a3f:	50                   	push   %eax
    3a40:	68 57 59 00 00       	push   $0x5957
    3a45:	6a 01                	push   $0x1
    3a47:	e8 58 0d 00 00       	call   47a4 <printf>
    3a4c:	83 c4 10             	add    $0x10,%esp
					mark = mark + 4;
    3a4f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3a53:	e9 78 06 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// character string
				else if(text[j][mark] == '"'){
    3a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a62:	8b 45 08             	mov    0x8(%ebp),%eax
    3a65:	01 d0                	add    %edx,%eax
    3a67:	8b 10                	mov    (%eax),%edx
    3a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3a6c:	01 d0                	add    %edx,%eax
    3a6e:	0f b6 00             	movzbl (%eax),%eax
    3a71:	3c 22                	cmp    $0x22,%al
    3a73:	0f 85 95 00 00 00    	jne    3b0e <show_text_syntax_highlighting+0x1d7d>
					int tmp_pos = mark+1;
    3a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3a7c:	83 c0 01             	add    $0x1,%eax
    3a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
					int end = -1;
    3a82:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
					while(tmp_pos < MAX_LINE_LENGTH){
    3a89:	eb 29                	jmp    3ab4 <show_text_syntax_highlighting+0x1d23>
						if(text[j][tmp_pos] == '"'){
    3a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a95:	8b 45 08             	mov    0x8(%ebp),%eax
    3a98:	01 d0                	add    %edx,%eax
    3a9a:	8b 10                	mov    (%eax),%edx
    3a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3a9f:	01 d0                	add    %edx,%eax
    3aa1:	0f b6 00             	movzbl (%eax),%eax
    3aa4:	3c 22                	cmp    $0x22,%al
    3aa6:	75 08                	jne    3ab0 <show_text_syntax_highlighting+0x1d1f>
							end = tmp_pos;
    3aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3aab:	89 45 dc             	mov    %eax,-0x24(%ebp)
							break;
    3aae:	eb 0d                	jmp    3abd <show_text_syntax_highlighting+0x1d2c>
						}
						else{
							tmp_pos++;
    3ab0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
				}
				// character string
				else if(text[j][mark] == '"'){
					int tmp_pos = mark+1;
					int end = -1;
					while(tmp_pos < MAX_LINE_LENGTH){
    3ab4:	81 7d e0 ff 00 00 00 	cmpl   $0xff,-0x20(%ebp)
    3abb:	7e ce                	jle    3a8b <show_text_syntax_highlighting+0x1cfa>
						}
						else{
							tmp_pos++;
						}
					}
					for(int inter = mark; inter <= end; inter++){
    3abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ac0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    3ac3:	eb 33                	jmp    3af8 <show_text_syntax_highlighting+0x1d67>
						printf(1, "\e[1;33m%c\e[0m", text[j][inter]);
    3ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3acf:	8b 45 08             	mov    0x8(%ebp),%eax
    3ad2:	01 d0                	add    %edx,%eax
    3ad4:	8b 10                	mov    (%eax),%edx
    3ad6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3ad9:	01 d0                	add    %edx,%eax
    3adb:	0f b6 00             	movzbl (%eax),%eax
    3ade:	0f be c0             	movsbl %al,%eax
    3ae1:	83 ec 04             	sub    $0x4,%esp
    3ae4:	50                   	push   %eax
    3ae5:	68 65 59 00 00       	push   $0x5965
    3aea:	6a 01                	push   $0x1
    3aec:	e8 b3 0c 00 00       	call   47a4 <printf>
    3af1:	83 c4 10             	add    $0x10,%esp
						}
						else{
							tmp_pos++;
						}
					}
					for(int inter = mark; inter <= end; inter++){
    3af4:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
    3af8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    3afb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
    3afe:	7e c5                	jle    3ac5 <show_text_syntax_highlighting+0x1d34>
						printf(1, "\e[1;33m%c\e[0m", text[j][inter]);
					}
					mark = end + 1;
    3b00:	8b 45 dc             	mov    -0x24(%ebp),%eax
    3b03:	83 c0 01             	add    $0x1,%eax
    3b06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    3b09:	e9 c2 05 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// single character
				else if(text[j][mark] == '\''){
    3b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b11:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3b18:	8b 45 08             	mov    0x8(%ebp),%eax
    3b1b:	01 d0                	add    %edx,%eax
    3b1d:	8b 10                	mov    (%eax),%edx
    3b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3b22:	01 d0                	add    %edx,%eax
    3b24:	0f b6 00             	movzbl (%eax),%eax
    3b27:	3c 27                	cmp    $0x27,%al
    3b29:	0f 85 95 00 00 00    	jne    3bc4 <show_text_syntax_highlighting+0x1e33>
					int tmp_pos = mark+1;
    3b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3b32:	83 c0 01             	add    $0x1,%eax
    3b35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					int end = -1;
    3b38:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
					while(tmp_pos < MAX_LINE_LENGTH){
    3b3f:	eb 29                	jmp    3b6a <show_text_syntax_highlighting+0x1dd9>
						if(text[j][tmp_pos] == '\''){
    3b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3b4b:	8b 45 08             	mov    0x8(%ebp),%eax
    3b4e:	01 d0                	add    %edx,%eax
    3b50:	8b 10                	mov    (%eax),%edx
    3b52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3b55:	01 d0                	add    %edx,%eax
    3b57:	0f b6 00             	movzbl (%eax),%eax
    3b5a:	3c 27                	cmp    $0x27,%al
    3b5c:	75 08                	jne    3b66 <show_text_syntax_highlighting+0x1dd5>
							end = tmp_pos;
    3b5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3b61:	89 45 d0             	mov    %eax,-0x30(%ebp)
							break;
    3b64:	eb 0d                	jmp    3b73 <show_text_syntax_highlighting+0x1de2>
						}
						else{
							tmp_pos++;
    3b66:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
				}
				// single character
				else if(text[j][mark] == '\''){
					int tmp_pos = mark+1;
					int end = -1;
					while(tmp_pos < MAX_LINE_LENGTH){
    3b6a:	81 7d d4 ff 00 00 00 	cmpl   $0xff,-0x2c(%ebp)
    3b71:	7e ce                	jle    3b41 <show_text_syntax_highlighting+0x1db0>
						}
						else{
							tmp_pos++;
						}
					}
					for(int inter = mark; inter <= end; inter++){
    3b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3b76:	89 45 cc             	mov    %eax,-0x34(%ebp)
    3b79:	eb 33                	jmp    3bae <show_text_syntax_highlighting+0x1e1d>
						printf(1, "\e[1;33m%c\e[0m", text[j][inter]);
    3b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3b85:	8b 45 08             	mov    0x8(%ebp),%eax
    3b88:	01 d0                	add    %edx,%eax
    3b8a:	8b 10                	mov    (%eax),%edx
    3b8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3b8f:	01 d0                	add    %edx,%eax
    3b91:	0f b6 00             	movzbl (%eax),%eax
    3b94:	0f be c0             	movsbl %al,%eax
    3b97:	83 ec 04             	sub    $0x4,%esp
    3b9a:	50                   	push   %eax
    3b9b:	68 65 59 00 00       	push   $0x5965
    3ba0:	6a 01                	push   $0x1
    3ba2:	e8 fd 0b 00 00       	call   47a4 <printf>
    3ba7:	83 c4 10             	add    $0x10,%esp
						}
						else{
							tmp_pos++;
						}
					}
					for(int inter = mark; inter <= end; inter++){
    3baa:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
    3bae:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3bb1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
    3bb4:	7e c5                	jle    3b7b <show_text_syntax_highlighting+0x1dea>
						printf(1, "\e[1;33m%c\e[0m", text[j][inter]);
					}
					mark = end + 1;
    3bb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3bb9:	83 c0 01             	add    $0x1,%eax
    3bbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    3bbf:	e9 0c 05 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// continue
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'c' && text[j][mark+1] == 'o' && text[j][mark+2] == 'n'
    3bc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3bc7:	83 c0 05             	add    $0x5,%eax
    3bca:	3d ff 00 00 00       	cmp    $0xff,%eax
    3bcf:	0f 8f b3 02 00 00    	jg     3e88 <show_text_syntax_highlighting+0x20f7>
    3bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3bd8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3bdf:	8b 45 08             	mov    0x8(%ebp),%eax
    3be2:	01 d0                	add    %edx,%eax
    3be4:	8b 10                	mov    (%eax),%edx
    3be6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3be9:	01 d0                	add    %edx,%eax
    3beb:	0f b6 00             	movzbl (%eax),%eax
    3bee:	3c 63                	cmp    $0x63,%al
    3bf0:	0f 85 92 02 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
    3bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3bf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3c00:	8b 45 08             	mov    0x8(%ebp),%eax
    3c03:	01 d0                	add    %edx,%eax
    3c05:	8b 00                	mov    (%eax),%eax
    3c07:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3c0a:	83 c2 01             	add    $0x1,%edx
    3c0d:	01 d0                	add    %edx,%eax
    3c0f:	0f b6 00             	movzbl (%eax),%eax
    3c12:	3c 6f                	cmp    $0x6f,%al
    3c14:	0f 85 6e 02 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
    3c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3c24:	8b 45 08             	mov    0x8(%ebp),%eax
    3c27:	01 d0                	add    %edx,%eax
    3c29:	8b 00                	mov    (%eax),%eax
    3c2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3c2e:	83 c2 02             	add    $0x2,%edx
    3c31:	01 d0                	add    %edx,%eax
    3c33:	0f b6 00             	movzbl (%eax),%eax
    3c36:	3c 6e                	cmp    $0x6e,%al
    3c38:	0f 85 4a 02 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
					&& text[j][mark+3] == 't' && text[j][mark+4] == 'i' && text[j][mark+5] == 'n' && text[j][mark+6] == 'u'
    3c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3c48:	8b 45 08             	mov    0x8(%ebp),%eax
    3c4b:	01 d0                	add    %edx,%eax
    3c4d:	8b 00                	mov    (%eax),%eax
    3c4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3c52:	83 c2 03             	add    $0x3,%edx
    3c55:	01 d0                	add    %edx,%eax
    3c57:	0f b6 00             	movzbl (%eax),%eax
    3c5a:	3c 74                	cmp    $0x74,%al
    3c5c:	0f 85 26 02 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
    3c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3c6c:	8b 45 08             	mov    0x8(%ebp),%eax
    3c6f:	01 d0                	add    %edx,%eax
    3c71:	8b 00                	mov    (%eax),%eax
    3c73:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3c76:	83 c2 04             	add    $0x4,%edx
    3c79:	01 d0                	add    %edx,%eax
    3c7b:	0f b6 00             	movzbl (%eax),%eax
    3c7e:	3c 69                	cmp    $0x69,%al
    3c80:	0f 85 02 02 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
    3c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3c89:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3c90:	8b 45 08             	mov    0x8(%ebp),%eax
    3c93:	01 d0                	add    %edx,%eax
    3c95:	8b 00                	mov    (%eax),%eax
    3c97:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3c9a:	83 c2 05             	add    $0x5,%edx
    3c9d:	01 d0                	add    %edx,%eax
    3c9f:	0f b6 00             	movzbl (%eax),%eax
    3ca2:	3c 6e                	cmp    $0x6e,%al
    3ca4:	0f 85 de 01 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
    3caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3cad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3cb4:	8b 45 08             	mov    0x8(%ebp),%eax
    3cb7:	01 d0                	add    %edx,%eax
    3cb9:	8b 00                	mov    (%eax),%eax
    3cbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3cbe:	83 c2 06             	add    $0x6,%edx
    3cc1:	01 d0                	add    %edx,%eax
    3cc3:	0f b6 00             	movzbl (%eax),%eax
    3cc6:	3c 75                	cmp    $0x75,%al
    3cc8:	0f 85 ba 01 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
					&& text[j][mark+7] == 'e'){
    3cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3cd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3cd8:	8b 45 08             	mov    0x8(%ebp),%eax
    3cdb:	01 d0                	add    %edx,%eax
    3cdd:	8b 00                	mov    (%eax),%eax
    3cdf:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3ce2:	83 c2 07             	add    $0x7,%edx
    3ce5:	01 d0                	add    %edx,%eax
    3ce7:	0f b6 00             	movzbl (%eax),%eax
    3cea:	3c 65                	cmp    $0x65,%al
    3cec:	0f 85 96 01 00 00    	jne    3e88 <show_text_syntax_highlighting+0x20f7>
					printf(1, "\e[1;35m%c\e[0m", text[j][mark]);
    3cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3cfc:	8b 45 08             	mov    0x8(%ebp),%eax
    3cff:	01 d0                	add    %edx,%eax
    3d01:	8b 10                	mov    (%eax),%edx
    3d03:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3d06:	01 d0                	add    %edx,%eax
    3d08:	0f b6 00             	movzbl (%eax),%eax
    3d0b:	0f be c0             	movsbl %al,%eax
    3d0e:	83 ec 04             	sub    $0x4,%esp
    3d11:	50                   	push   %eax
    3d12:	68 57 59 00 00       	push   $0x5957
    3d17:	6a 01                	push   $0x1
    3d19:	e8 86 0a 00 00       	call   47a4 <printf>
    3d1e:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+1]);
    3d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3d2b:	8b 45 08             	mov    0x8(%ebp),%eax
    3d2e:	01 d0                	add    %edx,%eax
    3d30:	8b 00                	mov    (%eax),%eax
    3d32:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3d35:	83 c2 01             	add    $0x1,%edx
    3d38:	01 d0                	add    %edx,%eax
    3d3a:	0f b6 00             	movzbl (%eax),%eax
    3d3d:	0f be c0             	movsbl %al,%eax
    3d40:	83 ec 04             	sub    $0x4,%esp
    3d43:	50                   	push   %eax
    3d44:	68 57 59 00 00       	push   $0x5957
    3d49:	6a 01                	push   $0x1
    3d4b:	e8 54 0a 00 00       	call   47a4 <printf>
    3d50:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+2]);
    3d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3d5d:	8b 45 08             	mov    0x8(%ebp),%eax
    3d60:	01 d0                	add    %edx,%eax
    3d62:	8b 00                	mov    (%eax),%eax
    3d64:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3d67:	83 c2 02             	add    $0x2,%edx
    3d6a:	01 d0                	add    %edx,%eax
    3d6c:	0f b6 00             	movzbl (%eax),%eax
    3d6f:	0f be c0             	movsbl %al,%eax
    3d72:	83 ec 04             	sub    $0x4,%esp
    3d75:	50                   	push   %eax
    3d76:	68 57 59 00 00       	push   $0x5957
    3d7b:	6a 01                	push   $0x1
    3d7d:	e8 22 0a 00 00       	call   47a4 <printf>
    3d82:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+3]);
    3d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3d8f:	8b 45 08             	mov    0x8(%ebp),%eax
    3d92:	01 d0                	add    %edx,%eax
    3d94:	8b 00                	mov    (%eax),%eax
    3d96:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3d99:	83 c2 03             	add    $0x3,%edx
    3d9c:	01 d0                	add    %edx,%eax
    3d9e:	0f b6 00             	movzbl (%eax),%eax
    3da1:	0f be c0             	movsbl %al,%eax
    3da4:	83 ec 04             	sub    $0x4,%esp
    3da7:	50                   	push   %eax
    3da8:	68 57 59 00 00       	push   $0x5957
    3dad:	6a 01                	push   $0x1
    3daf:	e8 f0 09 00 00       	call   47a4 <printf>
    3db4:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+4]);
    3db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3dc1:	8b 45 08             	mov    0x8(%ebp),%eax
    3dc4:	01 d0                	add    %edx,%eax
    3dc6:	8b 00                	mov    (%eax),%eax
    3dc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3dcb:	83 c2 04             	add    $0x4,%edx
    3dce:	01 d0                	add    %edx,%eax
    3dd0:	0f b6 00             	movzbl (%eax),%eax
    3dd3:	0f be c0             	movsbl %al,%eax
    3dd6:	83 ec 04             	sub    $0x4,%esp
    3dd9:	50                   	push   %eax
    3dda:	68 57 59 00 00       	push   $0x5957
    3ddf:	6a 01                	push   $0x1
    3de1:	e8 be 09 00 00       	call   47a4 <printf>
    3de6:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+5]);
    3de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3dec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3df3:	8b 45 08             	mov    0x8(%ebp),%eax
    3df6:	01 d0                	add    %edx,%eax
    3df8:	8b 00                	mov    (%eax),%eax
    3dfa:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3dfd:	83 c2 05             	add    $0x5,%edx
    3e00:	01 d0                	add    %edx,%eax
    3e02:	0f b6 00             	movzbl (%eax),%eax
    3e05:	0f be c0             	movsbl %al,%eax
    3e08:	83 ec 04             	sub    $0x4,%esp
    3e0b:	50                   	push   %eax
    3e0c:	68 57 59 00 00       	push   $0x5957
    3e11:	6a 01                	push   $0x1
    3e13:	e8 8c 09 00 00       	call   47a4 <printf>
    3e18:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+6]);
    3e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3e25:	8b 45 08             	mov    0x8(%ebp),%eax
    3e28:	01 d0                	add    %edx,%eax
    3e2a:	8b 00                	mov    (%eax),%eax
    3e2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3e2f:	83 c2 06             	add    $0x6,%edx
    3e32:	01 d0                	add    %edx,%eax
    3e34:	0f b6 00             	movzbl (%eax),%eax
    3e37:	0f be c0             	movsbl %al,%eax
    3e3a:	83 ec 04             	sub    $0x4,%esp
    3e3d:	50                   	push   %eax
    3e3e:	68 57 59 00 00       	push   $0x5957
    3e43:	6a 01                	push   $0x1
    3e45:	e8 5a 09 00 00       	call   47a4 <printf>
    3e4a:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;35m%c\e[0m", text[j][mark+7]);
    3e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3e57:	8b 45 08             	mov    0x8(%ebp),%eax
    3e5a:	01 d0                	add    %edx,%eax
    3e5c:	8b 00                	mov    (%eax),%eax
    3e5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3e61:	83 c2 07             	add    $0x7,%edx
    3e64:	01 d0                	add    %edx,%eax
    3e66:	0f b6 00             	movzbl (%eax),%eax
    3e69:	0f be c0             	movsbl %al,%eax
    3e6c:	83 ec 04             	sub    $0x4,%esp
    3e6f:	50                   	push   %eax
    3e70:	68 57 59 00 00       	push   $0x5957
    3e75:	6a 01                	push   $0x1
    3e77:	e8 28 09 00 00       	call   47a4 <printf>
    3e7c:	83 c4 10             	add    $0x10,%esp
					mark = mark + 8;
    3e7f:	83 45 e8 08          	addl   $0x8,-0x18(%ebp)
    3e83:	e9 48 02 00 00       	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				// return
				else if((mark+5)<MAX_LINE_LENGTH && text[j][mark] == 'r' && text[j][mark+1] == 'e' && text[j][mark+2] == 't'
    3e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e8b:	83 c0 05             	add    $0x5,%eax
    3e8e:	3d ff 00 00 00       	cmp    $0xff,%eax
    3e93:	0f 8f 04 02 00 00    	jg     409d <show_text_syntax_highlighting+0x230c>
    3e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3ea3:	8b 45 08             	mov    0x8(%ebp),%eax
    3ea6:	01 d0                	add    %edx,%eax
    3ea8:	8b 10                	mov    (%eax),%edx
    3eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ead:	01 d0                	add    %edx,%eax
    3eaf:	0f b6 00             	movzbl (%eax),%eax
    3eb2:	3c 72                	cmp    $0x72,%al
    3eb4:	0f 85 e3 01 00 00    	jne    409d <show_text_syntax_highlighting+0x230c>
    3eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ebd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3ec4:	8b 45 08             	mov    0x8(%ebp),%eax
    3ec7:	01 d0                	add    %edx,%eax
    3ec9:	8b 00                	mov    (%eax),%eax
    3ecb:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3ece:	83 c2 01             	add    $0x1,%edx
    3ed1:	01 d0                	add    %edx,%eax
    3ed3:	0f b6 00             	movzbl (%eax),%eax
    3ed6:	3c 65                	cmp    $0x65,%al
    3ed8:	0f 85 bf 01 00 00    	jne    409d <show_text_syntax_highlighting+0x230c>
    3ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ee1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3ee8:	8b 45 08             	mov    0x8(%ebp),%eax
    3eeb:	01 d0                	add    %edx,%eax
    3eed:	8b 00                	mov    (%eax),%eax
    3eef:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3ef2:	83 c2 02             	add    $0x2,%edx
    3ef5:	01 d0                	add    %edx,%eax
    3ef7:	0f b6 00             	movzbl (%eax),%eax
    3efa:	3c 74                	cmp    $0x74,%al
    3efc:	0f 85 9b 01 00 00    	jne    409d <show_text_syntax_highlighting+0x230c>
					&& text[j][mark+3] == 'u' && text[j][mark+4] == 'r' && text[j][mark+5] == 'n'){
    3f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3f0c:	8b 45 08             	mov    0x8(%ebp),%eax
    3f0f:	01 d0                	add    %edx,%eax
    3f11:	8b 00                	mov    (%eax),%eax
    3f13:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3f16:	83 c2 03             	add    $0x3,%edx
    3f19:	01 d0                	add    %edx,%eax
    3f1b:	0f b6 00             	movzbl (%eax),%eax
    3f1e:	3c 75                	cmp    $0x75,%al
    3f20:	0f 85 77 01 00 00    	jne    409d <show_text_syntax_highlighting+0x230c>
    3f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3f30:	8b 45 08             	mov    0x8(%ebp),%eax
    3f33:	01 d0                	add    %edx,%eax
    3f35:	8b 00                	mov    (%eax),%eax
    3f37:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3f3a:	83 c2 04             	add    $0x4,%edx
    3f3d:	01 d0                	add    %edx,%eax
    3f3f:	0f b6 00             	movzbl (%eax),%eax
    3f42:	3c 72                	cmp    $0x72,%al
    3f44:	0f 85 53 01 00 00    	jne    409d <show_text_syntax_highlighting+0x230c>
    3f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3f54:	8b 45 08             	mov    0x8(%ebp),%eax
    3f57:	01 d0                	add    %edx,%eax
    3f59:	8b 00                	mov    (%eax),%eax
    3f5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3f5e:	83 c2 05             	add    $0x5,%edx
    3f61:	01 d0                	add    %edx,%eax
    3f63:	0f b6 00             	movzbl (%eax),%eax
    3f66:	3c 6e                	cmp    $0x6e,%al
    3f68:	0f 85 2f 01 00 00    	jne    409d <show_text_syntax_highlighting+0x230c>
					printf(1, "\e[1;34m%c\e[0m", text[j][mark]);
    3f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3f71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3f78:	8b 45 08             	mov    0x8(%ebp),%eax
    3f7b:	01 d0                	add    %edx,%eax
    3f7d:	8b 10                	mov    (%eax),%edx
    3f7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3f82:	01 d0                	add    %edx,%eax
    3f84:	0f b6 00             	movzbl (%eax),%eax
    3f87:	0f be c0             	movsbl %al,%eax
    3f8a:	83 ec 04             	sub    $0x4,%esp
    3f8d:	50                   	push   %eax
    3f8e:	68 49 59 00 00       	push   $0x5949
    3f93:	6a 01                	push   $0x1
    3f95:	e8 0a 08 00 00       	call   47a4 <printf>
    3f9a:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+1]);
    3f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3fa0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3fa7:	8b 45 08             	mov    0x8(%ebp),%eax
    3faa:	01 d0                	add    %edx,%eax
    3fac:	8b 00                	mov    (%eax),%eax
    3fae:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3fb1:	83 c2 01             	add    $0x1,%edx
    3fb4:	01 d0                	add    %edx,%eax
    3fb6:	0f b6 00             	movzbl (%eax),%eax
    3fb9:	0f be c0             	movsbl %al,%eax
    3fbc:	83 ec 04             	sub    $0x4,%esp
    3fbf:	50                   	push   %eax
    3fc0:	68 49 59 00 00       	push   $0x5949
    3fc5:	6a 01                	push   $0x1
    3fc7:	e8 d8 07 00 00       	call   47a4 <printf>
    3fcc:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+2]);
    3fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3fd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3fd9:	8b 45 08             	mov    0x8(%ebp),%eax
    3fdc:	01 d0                	add    %edx,%eax
    3fde:	8b 00                	mov    (%eax),%eax
    3fe0:	8b 55 e8             	mov    -0x18(%ebp),%edx
    3fe3:	83 c2 02             	add    $0x2,%edx
    3fe6:	01 d0                	add    %edx,%eax
    3fe8:	0f b6 00             	movzbl (%eax),%eax
    3feb:	0f be c0             	movsbl %al,%eax
    3fee:	83 ec 04             	sub    $0x4,%esp
    3ff1:	50                   	push   %eax
    3ff2:	68 49 59 00 00       	push   $0x5949
    3ff7:	6a 01                	push   $0x1
    3ff9:	e8 a6 07 00 00       	call   47a4 <printf>
    3ffe:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+3]);
    4001:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4004:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    400b:	8b 45 08             	mov    0x8(%ebp),%eax
    400e:	01 d0                	add    %edx,%eax
    4010:	8b 00                	mov    (%eax),%eax
    4012:	8b 55 e8             	mov    -0x18(%ebp),%edx
    4015:	83 c2 03             	add    $0x3,%edx
    4018:	01 d0                	add    %edx,%eax
    401a:	0f b6 00             	movzbl (%eax),%eax
    401d:	0f be c0             	movsbl %al,%eax
    4020:	83 ec 04             	sub    $0x4,%esp
    4023:	50                   	push   %eax
    4024:	68 49 59 00 00       	push   $0x5949
    4029:	6a 01                	push   $0x1
    402b:	e8 74 07 00 00       	call   47a4 <printf>
    4030:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+4]);
    4033:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    403d:	8b 45 08             	mov    0x8(%ebp),%eax
    4040:	01 d0                	add    %edx,%eax
    4042:	8b 00                	mov    (%eax),%eax
    4044:	8b 55 e8             	mov    -0x18(%ebp),%edx
    4047:	83 c2 04             	add    $0x4,%edx
    404a:	01 d0                	add    %edx,%eax
    404c:	0f b6 00             	movzbl (%eax),%eax
    404f:	0f be c0             	movsbl %al,%eax
    4052:	83 ec 04             	sub    $0x4,%esp
    4055:	50                   	push   %eax
    4056:	68 49 59 00 00       	push   $0x5949
    405b:	6a 01                	push   $0x1
    405d:	e8 42 07 00 00       	call   47a4 <printf>
    4062:	83 c4 10             	add    $0x10,%esp
					printf(1, "\e[1;34m%c\e[0m", text[j][mark+5]);
    4065:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4068:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    406f:	8b 45 08             	mov    0x8(%ebp),%eax
    4072:	01 d0                	add    %edx,%eax
    4074:	8b 00                	mov    (%eax),%eax
    4076:	8b 55 e8             	mov    -0x18(%ebp),%edx
    4079:	83 c2 05             	add    $0x5,%edx
    407c:	01 d0                	add    %edx,%eax
    407e:	0f b6 00             	movzbl (%eax),%eax
    4081:	0f be c0             	movsbl %al,%eax
    4084:	83 ec 04             	sub    $0x4,%esp
    4087:	50                   	push   %eax
    4088:	68 49 59 00 00       	push   $0x5949
    408d:	6a 01                	push   $0x1
    408f:	e8 10 07 00 00       	call   47a4 <printf>
    4094:	83 c4 10             	add    $0x10,%esp
					mark = mark + 6;
    4097:	83 45 e8 06          	addl   $0x6,-0x18(%ebp)
    409b:	eb 33                	jmp    40d0 <show_text_syntax_highlighting+0x233f>
				}
				else{
					printf(1, "%c\e[0m", text[j][mark]);
    409d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    40a7:	8b 45 08             	mov    0x8(%ebp),%eax
    40aa:	01 d0                	add    %edx,%eax
    40ac:	8b 10                	mov    (%eax),%edx
    40ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40b1:	01 d0                	add    %edx,%eax
    40b3:	0f b6 00             	movzbl (%eax),%eax
    40b6:	0f be c0             	movsbl %al,%eax
    40b9:	83 ec 04             	sub    $0x4,%esp
    40bc:	50                   	push   %eax
    40bd:	68 73 59 00 00       	push   $0x5973
    40c2:	6a 01                	push   $0x1
    40c4:	e8 db 06 00 00       	call   47a4 <printf>
    40c9:	83 c4 10             	add    $0x10,%esp
					mark++;
    40cc:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
			printf(1, "\e[1;32m%s\n\e[0m", text[j]);
		}
		else{
			int mark = 0;
			int flag_annotation = 0;
			while(mark < MAX_LINE_LENGTH && text[j][mark] != NULL){
    40d0:	81 7d e8 ff 00 00 00 	cmpl   $0xff,-0x18(%ebp)
    40d7:	7f 21                	jg     40fa <show_text_syntax_highlighting+0x2369>
    40d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    40e3:	8b 45 08             	mov    0x8(%ebp),%eax
    40e6:	01 d0                	add    %edx,%eax
    40e8:	8b 10                	mov    (%eax),%edx
    40ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40ed:	01 d0                	add    %edx,%eax
    40ef:	0f b6 00             	movzbl (%eax),%eax
    40f2:	84 c0                	test   %al,%al
    40f4:	0f 85 56 de ff ff    	jne    1f50 <show_text_syntax_highlighting+0x1bf>
				else{
					printf(1, "%c\e[0m", text[j][mark]);
					mark++;
				}
			}
			printf(1, "\n");
    40fa:	83 ec 08             	sub    $0x8,%esp
    40fd:	68 cb 4c 00 00       	push   $0x4ccb
    4102:	6a 01                	push   $0x1
    4104:	e8 9b 06 00 00       	call   47a4 <printf>
    4109:	83 c4 10             	add    $0x10,%esp
// 语法高亮
void show_text_syntax_highlighting(char *text[]){
	printf(1, ">>> \033[1m\e[45;33mthe contents of the file are:\e[0m\n");
	printf(1, "\n");
	int j = 0;
	for (; text[j] != NULL; j++){
    410c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4110:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4113:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    411a:	8b 45 08             	mov    0x8(%ebp),%eax
    411d:	01 d0                	add    %edx,%eax
    411f:	8b 00                	mov    (%eax),%eax
    4121:	85 c0                	test   %eax,%eax
    4123:	0f 85 a0 dc ff ff    	jne    1dc9 <show_text_syntax_highlighting+0x38>
				}
			}
			printf(1, "\n");
		}
	}
	printf(1, "\n");
    4129:	83 ec 08             	sub    $0x8,%esp
    412c:	68 cb 4c 00 00       	push   $0x4ccb
    4131:	6a 01                	push   $0x1
    4133:	e8 6c 06 00 00       	call   47a4 <printf>
    4138:	83 c4 10             	add    $0x10,%esp
}
    413b:	90                   	nop
    413c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    413f:	5b                   	pop    %ebx
    4140:	5e                   	pop    %esi
    4141:	5d                   	pop    %ebp
    4142:	c3                   	ret    

00004143 <com_rollback>:

void com_rollback(char *text[], int n){
    4143:	55                   	push   %ebp
    4144:	89 e5                	mov    %esp,%ebp
    4146:	83 ec 28             	sub    $0x28,%esp
	// rollback the command
	if(upper_bound < 0){
    4149:	a1 60 5e 00 00       	mov    0x5e60,%eax
    414e:	85 c0                	test   %eax,%eax
    4150:	79 17                	jns    4169 <com_rollback+0x26>
		printf(1, ">>> \033[1m\e[41;33mcouldn't rollback\e[0m\n");
    4152:	83 ec 08             	sub    $0x8,%esp
    4155:	68 7c 59 00 00       	push   $0x597c
    415a:	6a 01                	push   $0x1
    415c:	e8 43 06 00 00       	call   47a4 <printf>
    4161:	83 c4 10             	add    $0x10,%esp
		return;
    4164:	e9 a9 01 00 00       	jmp    4312 <com_rollback+0x1cf>
	}

	char *input = malloc(MAX_LINE_LENGTH);
    4169:	83 ec 0c             	sub    $0xc,%esp
    416c:	68 00 01 00 00       	push   $0x100
    4171:	e8 01 09 00 00       	call   4a77 <malloc>
    4176:	83 c4 10             	add    $0x10,%esp
    4179:	89 45 ec             	mov    %eax,-0x14(%ebp)
	strcpy(input, command_set[upper_bound]);
    417c:	a1 60 5e 00 00       	mov    0x5e60,%eax
    4181:	8b 04 85 a0 5e 00 00 	mov    0x5ea0(,%eax,4),%eax
    4188:	83 ec 08             	sub    $0x8,%esp
    418b:	50                   	push   %eax
    418c:	ff 75 ec             	pushl  -0x14(%ebp)
    418f:	e8 68 02 00 00       	call   43fc <strcpy>
    4194:	83 c4 10             	add    $0x10,%esp
	upper_bound--;
    4197:	a1 60 5e 00 00       	mov    0x5e60,%eax
    419c:	83 e8 01             	sub    $0x1,%eax
    419f:	a3 60 5e 00 00       	mov    %eax,0x5e60
	// searching the first space of command
	int pos = MAX_LINE_LENGTH - 1;
    41a4:	c7 45 f4 ff 00 00 00 	movl   $0xff,-0xc(%ebp)
	int j = 0;
    41ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (; j < 10; j++)
    41b2:	eb 1e                	jmp    41d2 <com_rollback+0x8f>
	{
		if (input[j] == ' ')
    41b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    41b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41ba:	01 d0                	add    %edx,%eax
    41bc:	0f b6 00             	movzbl (%eax),%eax
    41bf:	3c 20                	cmp    $0x20,%al
    41c1:	75 0b                	jne    41ce <com_rollback+0x8b>
		{
			pos = j + 1;
    41c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    41c6:	83 c0 01             	add    $0x1,%eax
    41c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
			break;
    41cc:	eb 0a                	jmp    41d8 <com_rollback+0x95>
	strcpy(input, command_set[upper_bound]);
	upper_bound--;
	// searching the first space of command
	int pos = MAX_LINE_LENGTH - 1;
	int j = 0;
	for (; j < 10; j++)
    41ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    41d2:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
    41d6:	7e dc                	jle    41b4 <com_rollback+0x71>
			pos = j + 1;
			break;
		}
	}
	// deal 'ins' command
	if (input[0] == 'i' && input[1] == 'n' && input[2] == 's')
    41d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41db:	0f b6 00             	movzbl (%eax),%eax
    41de:	3c 69                	cmp    $0x69,%al
    41e0:	75 5a                	jne    423c <com_rollback+0xf9>
    41e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41e5:	83 c0 01             	add    $0x1,%eax
    41e8:	0f b6 00             	movzbl (%eax),%eax
    41eb:	3c 6e                	cmp    $0x6e,%al
    41ed:	75 4d                	jne    423c <com_rollback+0xf9>
    41ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41f2:	83 c0 02             	add    $0x2,%eax
    41f5:	0f b6 00             	movzbl (%eax),%eax
    41f8:	3c 73                	cmp    $0x73,%al
    41fa:	75 40                	jne    423c <com_rollback+0xf9>
	{
		// the line to be deleted
		int line = stringtonumber(&input[4]);
    41fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    41ff:	83 c0 04             	add    $0x4,%eax
    4202:	83 ec 0c             	sub    $0xc,%esp
    4205:	50                   	push   %eax
    4206:	e8 b4 c8 ff ff       	call   abf <stringtonumber>
    420b:	83 c4 10             	add    $0x10,%esp
    420e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		com_del(text, line, 0);
    4211:	83 ec 04             	sub    $0x4,%esp
    4214:	6a 00                	push   $0x0
    4216:	ff 75 e8             	pushl  -0x18(%ebp)
    4219:	ff 75 08             	pushl  0x8(%ebp)
    421c:	e8 66 d1 ff ff       	call   1387 <com_del>
    4221:	83 c4 10             	add    $0x10,%esp
		line_number = get_line_number(text);
    4224:	83 ec 0c             	sub    $0xc,%esp
    4227:	ff 75 08             	pushl  0x8(%ebp)
    422a:	e8 4f c8 ff ff       	call   a7e <get_line_number>
    422f:	83 c4 10             	add    $0x10,%esp
    4232:	a3 84 5e 00 00       	mov    %eax,0x5e84
			break;
		}
	}
	// deal 'ins' command
	if (input[0] == 'i' && input[1] == 'n' && input[2] == 's')
	{
    4237:	e9 d6 00 00 00       	jmp    4312 <com_rollback+0x1cf>
		int line = stringtonumber(&input[4]);
		com_del(text, line, 0);
		line_number = get_line_number(text);
	}
	// deal 'mod' command
	else if (input[0] == 'm' && input[1] == 'o' && input[2] == 'd')
    423c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    423f:	0f b6 00             	movzbl (%eax),%eax
    4242:	3c 6d                	cmp    $0x6d,%al
    4244:	75 62                	jne    42a8 <com_rollback+0x165>
    4246:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4249:	83 c0 01             	add    $0x1,%eax
    424c:	0f b6 00             	movzbl (%eax),%eax
    424f:	3c 6f                	cmp    $0x6f,%al
    4251:	75 55                	jne    42a8 <com_rollback+0x165>
    4253:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4256:	83 c0 02             	add    $0x2,%eax
    4259:	0f b6 00             	movzbl (%eax),%eax
    425c:	3c 64                	cmp    $0x64,%al
    425e:	75 48                	jne    42a8 <com_rollback+0x165>
	{
		// the line to be modified
		int line = stringtonumber(&input[4]);
    4260:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4263:	83 c0 04             	add    $0x4,%eax
    4266:	83 ec 0c             	sub    $0xc,%esp
    4269:	50                   	push   %eax
    426a:	e8 50 c8 ff ff       	call   abf <stringtonumber>
    426f:	83 c4 10             	add    $0x10,%esp
    4272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// the content of mod
		char *content = &input[pos];
    4275:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4278:	8b 45 ec             	mov    -0x14(%ebp),%eax
    427b:	01 d0                	add    %edx,%eax
    427d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		com_mod(text, line, content, 0);
    4280:	6a 00                	push   $0x0
    4282:	ff 75 e0             	pushl  -0x20(%ebp)
    4285:	ff 75 e4             	pushl  -0x1c(%ebp)
    4288:	ff 75 08             	pushl  0x8(%ebp)
    428b:	e8 8e ce ff ff       	call   111e <com_mod>
    4290:	83 c4 10             	add    $0x10,%esp
		line_number = get_line_number(text);
    4293:	83 ec 0c             	sub    $0xc,%esp
    4296:	ff 75 08             	pushl  0x8(%ebp)
    4299:	e8 e0 c7 ff ff       	call   a7e <get_line_number>
    429e:	83 c4 10             	add    $0x10,%esp
    42a1:	a3 84 5e 00 00       	mov    %eax,0x5e84
		com_del(text, line, 0);
		line_number = get_line_number(text);
	}
	// deal 'mod' command
	else if (input[0] == 'm' && input[1] == 'o' && input[2] == 'd')
	{
    42a6:	eb 6a                	jmp    4312 <com_rollback+0x1cf>
		char *content = &input[pos];
		com_mod(text, line, content, 0);
		line_number = get_line_number(text);
	}
	// deal 'del' command
	else if (input[0] == 'd' && input[1] == 'e' && input[2] == 'l')
    42a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    42ab:	0f b6 00             	movzbl (%eax),%eax
    42ae:	3c 64                	cmp    $0x64,%al
    42b0:	75 60                	jne    4312 <com_rollback+0x1cf>
    42b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    42b5:	83 c0 01             	add    $0x1,%eax
    42b8:	0f b6 00             	movzbl (%eax),%eax
    42bb:	3c 65                	cmp    $0x65,%al
    42bd:	75 53                	jne    4312 <com_rollback+0x1cf>
    42bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    42c2:	83 c0 02             	add    $0x2,%eax
    42c5:	0f b6 00             	movzbl (%eax),%eax
    42c8:	3c 6c                	cmp    $0x6c,%al
    42ca:	75 46                	jne    4312 <com_rollback+0x1cf>
	{
		// the line to be deleted
		int line = stringtonumber(&input[4]);
    42cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    42cf:	83 c0 04             	add    $0x4,%eax
    42d2:	83 ec 0c             	sub    $0xc,%esp
    42d5:	50                   	push   %eax
    42d6:	e8 e4 c7 ff ff       	call   abf <stringtonumber>
    42db:	83 c4 10             	add    $0x10,%esp
    42de:	89 45 dc             	mov    %eax,-0x24(%ebp)
		// the content of deletion
		char *content = &input[pos];
    42e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    42e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    42e7:	01 d0                	add    %edx,%eax
    42e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		com_ins(text, line, content, 0);
    42ec:	6a 00                	push   $0x0
    42ee:	ff 75 d8             	pushl  -0x28(%ebp)
    42f1:	ff 75 dc             	pushl  -0x24(%ebp)
    42f4:	ff 75 08             	pushl  0x8(%ebp)
    42f7:	e8 5b c9 ff ff       	call   c57 <com_ins>
    42fc:	83 c4 10             	add    $0x10,%esp
		line_number = get_line_number(text);
    42ff:	83 ec 0c             	sub    $0xc,%esp
    4302:	ff 75 08             	pushl  0x8(%ebp)
    4305:	e8 74 c7 ff ff       	call   a7e <get_line_number>
    430a:	83 c4 10             	add    $0x10,%esp
    430d:	a3 84 5e 00 00       	mov    %eax,0x5e84
	}
}
    4312:	c9                   	leave  
    4313:	c3                   	ret    

00004314 <record_command>:

void record_command(char *command){
    4314:	55                   	push   %ebp
    4315:	89 e5                	mov    %esp,%ebp
    4317:	53                   	push   %ebx
    4318:	83 ec 14             	sub    $0x14,%esp
	if((upper_bound+1) < MAX_ROLLBAKC_STEP){
    431b:	a1 60 5e 00 00       	mov    0x5e60,%eax
    4320:	83 c0 01             	add    $0x1,%eax
    4323:	83 f8 13             	cmp    $0x13,%eax
    4326:	7f 4c                	jg     4374 <record_command+0x60>
		command_set[upper_bound+1] = malloc(MAX_LINE_LENGTH);
    4328:	a1 60 5e 00 00       	mov    0x5e60,%eax
    432d:	8d 58 01             	lea    0x1(%eax),%ebx
    4330:	83 ec 0c             	sub    $0xc,%esp
    4333:	68 00 01 00 00       	push   $0x100
    4338:	e8 3a 07 00 00       	call   4a77 <malloc>
    433d:	83 c4 10             	add    $0x10,%esp
    4340:	89 04 9d a0 5e 00 00 	mov    %eax,0x5ea0(,%ebx,4)
		strcpy(command_set[upper_bound+1], command);
    4347:	a1 60 5e 00 00       	mov    0x5e60,%eax
    434c:	83 c0 01             	add    $0x1,%eax
    434f:	8b 04 85 a0 5e 00 00 	mov    0x5ea0(,%eax,4),%eax
    4356:	83 ec 08             	sub    $0x8,%esp
    4359:	ff 75 08             	pushl  0x8(%ebp)
    435c:	50                   	push   %eax
    435d:	e8 9a 00 00 00       	call   43fc <strcpy>
    4362:	83 c4 10             	add    $0x10,%esp
		upper_bound++;
    4365:	a1 60 5e 00 00       	mov    0x5e60,%eax
    436a:	83 c0 01             	add    $0x1,%eax
    436d:	a3 60 5e 00 00       	mov    %eax,0x5e60
			strcpy(command_set[i-1], command_set[i]);
		}
		strcpy(command_set[upper_bound], command);
		upper_bound = MAX_ROLLBAKC_STEP - 1;
	}
    4372:	eb 5c                	jmp    43d0 <record_command+0xbc>
		command_set[upper_bound+1] = malloc(MAX_LINE_LENGTH);
		strcpy(command_set[upper_bound+1], command);
		upper_bound++;
	}
	else{
		for(int i = 1; i < MAX_ROLLBAKC_STEP; i++){
    4374:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    437b:	eb 28                	jmp    43a5 <record_command+0x91>
			strcpy(command_set[i-1], command_set[i]);
    437d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4380:	8b 14 85 a0 5e 00 00 	mov    0x5ea0(,%eax,4),%edx
    4387:	8b 45 f4             	mov    -0xc(%ebp),%eax
    438a:	83 e8 01             	sub    $0x1,%eax
    438d:	8b 04 85 a0 5e 00 00 	mov    0x5ea0(,%eax,4),%eax
    4394:	83 ec 08             	sub    $0x8,%esp
    4397:	52                   	push   %edx
    4398:	50                   	push   %eax
    4399:	e8 5e 00 00 00       	call   43fc <strcpy>
    439e:	83 c4 10             	add    $0x10,%esp
		command_set[upper_bound+1] = malloc(MAX_LINE_LENGTH);
		strcpy(command_set[upper_bound+1], command);
		upper_bound++;
	}
	else{
		for(int i = 1; i < MAX_ROLLBAKC_STEP; i++){
    43a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    43a5:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    43a9:	7e d2                	jle    437d <record_command+0x69>
			strcpy(command_set[i-1], command_set[i]);
		}
		strcpy(command_set[upper_bound], command);
    43ab:	a1 60 5e 00 00       	mov    0x5e60,%eax
    43b0:	8b 04 85 a0 5e 00 00 	mov    0x5ea0(,%eax,4),%eax
    43b7:	83 ec 08             	sub    $0x8,%esp
    43ba:	ff 75 08             	pushl  0x8(%ebp)
    43bd:	50                   	push   %eax
    43be:	e8 39 00 00 00       	call   43fc <strcpy>
    43c3:	83 c4 10             	add    $0x10,%esp
		upper_bound = MAX_ROLLBAKC_STEP - 1;
    43c6:	c7 05 60 5e 00 00 13 	movl   $0x13,0x5e60
    43cd:	00 00 00 
	}
    43d0:	90                   	nop
    43d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    43d4:	c9                   	leave  
    43d5:	c3                   	ret    

000043d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    43d6:	55                   	push   %ebp
    43d7:	89 e5                	mov    %esp,%ebp
    43d9:	57                   	push   %edi
    43da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    43db:	8b 4d 08             	mov    0x8(%ebp),%ecx
    43de:	8b 55 10             	mov    0x10(%ebp),%edx
    43e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    43e4:	89 cb                	mov    %ecx,%ebx
    43e6:	89 df                	mov    %ebx,%edi
    43e8:	89 d1                	mov    %edx,%ecx
    43ea:	fc                   	cld    
    43eb:	f3 aa                	rep stos %al,%es:(%edi)
    43ed:	89 ca                	mov    %ecx,%edx
    43ef:	89 fb                	mov    %edi,%ebx
    43f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
    43f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    43f7:	90                   	nop
    43f8:	5b                   	pop    %ebx
    43f9:	5f                   	pop    %edi
    43fa:	5d                   	pop    %ebp
    43fb:	c3                   	ret    

000043fc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    43fc:	55                   	push   %ebp
    43fd:	89 e5                	mov    %esp,%ebp
    43ff:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    4402:	8b 45 08             	mov    0x8(%ebp),%eax
    4405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    4408:	90                   	nop
    4409:	8b 45 08             	mov    0x8(%ebp),%eax
    440c:	8d 50 01             	lea    0x1(%eax),%edx
    440f:	89 55 08             	mov    %edx,0x8(%ebp)
    4412:	8b 55 0c             	mov    0xc(%ebp),%edx
    4415:	8d 4a 01             	lea    0x1(%edx),%ecx
    4418:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    441b:	0f b6 12             	movzbl (%edx),%edx
    441e:	88 10                	mov    %dl,(%eax)
    4420:	0f b6 00             	movzbl (%eax),%eax
    4423:	84 c0                	test   %al,%al
    4425:	75 e2                	jne    4409 <strcpy+0xd>
    ;
  return os;
    4427:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    442a:	c9                   	leave  
    442b:	c3                   	ret    

0000442c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    442c:	55                   	push   %ebp
    442d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    442f:	eb 08                	jmp    4439 <strcmp+0xd>
    p++, q++;
    4431:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4435:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    4439:	8b 45 08             	mov    0x8(%ebp),%eax
    443c:	0f b6 00             	movzbl (%eax),%eax
    443f:	84 c0                	test   %al,%al
    4441:	74 10                	je     4453 <strcmp+0x27>
    4443:	8b 45 08             	mov    0x8(%ebp),%eax
    4446:	0f b6 10             	movzbl (%eax),%edx
    4449:	8b 45 0c             	mov    0xc(%ebp),%eax
    444c:	0f b6 00             	movzbl (%eax),%eax
    444f:	38 c2                	cmp    %al,%dl
    4451:	74 de                	je     4431 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    4453:	8b 45 08             	mov    0x8(%ebp),%eax
    4456:	0f b6 00             	movzbl (%eax),%eax
    4459:	0f b6 d0             	movzbl %al,%edx
    445c:	8b 45 0c             	mov    0xc(%ebp),%eax
    445f:	0f b6 00             	movzbl (%eax),%eax
    4462:	0f b6 c0             	movzbl %al,%eax
    4465:	29 c2                	sub    %eax,%edx
    4467:	89 d0                	mov    %edx,%eax
}
    4469:	5d                   	pop    %ebp
    446a:	c3                   	ret    

0000446b <strlen>:

uint
strlen(char *s)
{
    446b:	55                   	push   %ebp
    446c:	89 e5                	mov    %esp,%ebp
    446e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    4471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    4478:	eb 04                	jmp    447e <strlen+0x13>
    447a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    447e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    4481:	8b 45 08             	mov    0x8(%ebp),%eax
    4484:	01 d0                	add    %edx,%eax
    4486:	0f b6 00             	movzbl (%eax),%eax
    4489:	84 c0                	test   %al,%al
    448b:	75 ed                	jne    447a <strlen+0xf>
    ;
  return n;
    448d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4490:	c9                   	leave  
    4491:	c3                   	ret    

00004492 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4492:	55                   	push   %ebp
    4493:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    4495:	8b 45 10             	mov    0x10(%ebp),%eax
    4498:	50                   	push   %eax
    4499:	ff 75 0c             	pushl  0xc(%ebp)
    449c:	ff 75 08             	pushl  0x8(%ebp)
    449f:	e8 32 ff ff ff       	call   43d6 <stosb>
    44a4:	83 c4 0c             	add    $0xc,%esp
  return dst;
    44a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    44aa:	c9                   	leave  
    44ab:	c3                   	ret    

000044ac <strchr>:

char*
strchr(const char *s, char c)
{
    44ac:	55                   	push   %ebp
    44ad:	89 e5                	mov    %esp,%ebp
    44af:	83 ec 04             	sub    $0x4,%esp
    44b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    44b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    44b8:	eb 14                	jmp    44ce <strchr+0x22>
    if(*s == c)
    44ba:	8b 45 08             	mov    0x8(%ebp),%eax
    44bd:	0f b6 00             	movzbl (%eax),%eax
    44c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
    44c3:	75 05                	jne    44ca <strchr+0x1e>
      return (char*)s;
    44c5:	8b 45 08             	mov    0x8(%ebp),%eax
    44c8:	eb 13                	jmp    44dd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    44ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    44ce:	8b 45 08             	mov    0x8(%ebp),%eax
    44d1:	0f b6 00             	movzbl (%eax),%eax
    44d4:	84 c0                	test   %al,%al
    44d6:	75 e2                	jne    44ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    44d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
    44dd:	c9                   	leave  
    44de:	c3                   	ret    

000044df <gets>:

char*
gets(char *buf, int max)
{
    44df:	55                   	push   %ebp
    44e0:	89 e5                	mov    %esp,%ebp
    44e2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    44e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    44ec:	eb 42                	jmp    4530 <gets+0x51>
    cc = read(0, &c, 1);
    44ee:	83 ec 04             	sub    $0x4,%esp
    44f1:	6a 01                	push   $0x1
    44f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
    44f6:	50                   	push   %eax
    44f7:	6a 00                	push   $0x0
    44f9:	e8 47 01 00 00       	call   4645 <read>
    44fe:	83 c4 10             	add    $0x10,%esp
    4501:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    4504:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4508:	7e 33                	jle    453d <gets+0x5e>
      break;
    buf[i++] = c;
    450a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    450d:	8d 50 01             	lea    0x1(%eax),%edx
    4510:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4513:	89 c2                	mov    %eax,%edx
    4515:	8b 45 08             	mov    0x8(%ebp),%eax
    4518:	01 c2                	add    %eax,%edx
    451a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    451e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    4520:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4524:	3c 0a                	cmp    $0xa,%al
    4526:	74 16                	je     453e <gets+0x5f>
    4528:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    452c:	3c 0d                	cmp    $0xd,%al
    452e:	74 0e                	je     453e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4530:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4533:	83 c0 01             	add    $0x1,%eax
    4536:	3b 45 0c             	cmp    0xc(%ebp),%eax
    4539:	7c b3                	jl     44ee <gets+0xf>
    453b:	eb 01                	jmp    453e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    453d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    453e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4541:	8b 45 08             	mov    0x8(%ebp),%eax
    4544:	01 d0                	add    %edx,%eax
    4546:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    4549:	8b 45 08             	mov    0x8(%ebp),%eax
}
    454c:	c9                   	leave  
    454d:	c3                   	ret    

0000454e <stat>:

int
stat(char *n, struct stat *st)
{
    454e:	55                   	push   %ebp
    454f:	89 e5                	mov    %esp,%ebp
    4551:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4554:	83 ec 08             	sub    $0x8,%esp
    4557:	6a 00                	push   $0x0
    4559:	ff 75 08             	pushl  0x8(%ebp)
    455c:	e8 0c 01 00 00       	call   466d <open>
    4561:	83 c4 10             	add    $0x10,%esp
    4564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    4567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    456b:	79 07                	jns    4574 <stat+0x26>
    return -1;
    456d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    4572:	eb 25                	jmp    4599 <stat+0x4b>
  r = fstat(fd, st);
    4574:	83 ec 08             	sub    $0x8,%esp
    4577:	ff 75 0c             	pushl  0xc(%ebp)
    457a:	ff 75 f4             	pushl  -0xc(%ebp)
    457d:	e8 03 01 00 00       	call   4685 <fstat>
    4582:	83 c4 10             	add    $0x10,%esp
    4585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    4588:	83 ec 0c             	sub    $0xc,%esp
    458b:	ff 75 f4             	pushl  -0xc(%ebp)
    458e:	e8 c2 00 00 00       	call   4655 <close>
    4593:	83 c4 10             	add    $0x10,%esp
  return r;
    4596:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    4599:	c9                   	leave  
    459a:	c3                   	ret    

0000459b <atoi>:

int
atoi(const char *s)
{
    459b:	55                   	push   %ebp
    459c:	89 e5                	mov    %esp,%ebp
    459e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    45a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    45a8:	eb 25                	jmp    45cf <atoi+0x34>
    n = n*10 + *s++ - '0';
    45aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
    45ad:	89 d0                	mov    %edx,%eax
    45af:	c1 e0 02             	shl    $0x2,%eax
    45b2:	01 d0                	add    %edx,%eax
    45b4:	01 c0                	add    %eax,%eax
    45b6:	89 c1                	mov    %eax,%ecx
    45b8:	8b 45 08             	mov    0x8(%ebp),%eax
    45bb:	8d 50 01             	lea    0x1(%eax),%edx
    45be:	89 55 08             	mov    %edx,0x8(%ebp)
    45c1:	0f b6 00             	movzbl (%eax),%eax
    45c4:	0f be c0             	movsbl %al,%eax
    45c7:	01 c8                	add    %ecx,%eax
    45c9:	83 e8 30             	sub    $0x30,%eax
    45cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    45cf:	8b 45 08             	mov    0x8(%ebp),%eax
    45d2:	0f b6 00             	movzbl (%eax),%eax
    45d5:	3c 2f                	cmp    $0x2f,%al
    45d7:	7e 0a                	jle    45e3 <atoi+0x48>
    45d9:	8b 45 08             	mov    0x8(%ebp),%eax
    45dc:	0f b6 00             	movzbl (%eax),%eax
    45df:	3c 39                	cmp    $0x39,%al
    45e1:	7e c7                	jle    45aa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    45e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    45e6:	c9                   	leave  
    45e7:	c3                   	ret    

000045e8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    45e8:	55                   	push   %ebp
    45e9:	89 e5                	mov    %esp,%ebp
    45eb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    45ee:	8b 45 08             	mov    0x8(%ebp),%eax
    45f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    45f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    45f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    45fa:	eb 17                	jmp    4613 <memmove+0x2b>
    *dst++ = *src++;
    45fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    45ff:	8d 50 01             	lea    0x1(%eax),%edx
    4602:	89 55 fc             	mov    %edx,-0x4(%ebp)
    4605:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4608:	8d 4a 01             	lea    0x1(%edx),%ecx
    460b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    460e:	0f b6 12             	movzbl (%edx),%edx
    4611:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    4613:	8b 45 10             	mov    0x10(%ebp),%eax
    4616:	8d 50 ff             	lea    -0x1(%eax),%edx
    4619:	89 55 10             	mov    %edx,0x10(%ebp)
    461c:	85 c0                	test   %eax,%eax
    461e:	7f dc                	jg     45fc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    4620:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4623:	c9                   	leave  
    4624:	c3                   	ret    

00004625 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    4625:	b8 01 00 00 00       	mov    $0x1,%eax
    462a:	cd 40                	int    $0x40
    462c:	c3                   	ret    

0000462d <exit>:
SYSCALL(exit)
    462d:	b8 02 00 00 00       	mov    $0x2,%eax
    4632:	cd 40                	int    $0x40
    4634:	c3                   	ret    

00004635 <wait>:
SYSCALL(wait)
    4635:	b8 03 00 00 00       	mov    $0x3,%eax
    463a:	cd 40                	int    $0x40
    463c:	c3                   	ret    

0000463d <pipe>:
SYSCALL(pipe)
    463d:	b8 04 00 00 00       	mov    $0x4,%eax
    4642:	cd 40                	int    $0x40
    4644:	c3                   	ret    

00004645 <read>:
SYSCALL(read)
    4645:	b8 05 00 00 00       	mov    $0x5,%eax
    464a:	cd 40                	int    $0x40
    464c:	c3                   	ret    

0000464d <write>:
SYSCALL(write)
    464d:	b8 10 00 00 00       	mov    $0x10,%eax
    4652:	cd 40                	int    $0x40
    4654:	c3                   	ret    

00004655 <close>:
SYSCALL(close)
    4655:	b8 15 00 00 00       	mov    $0x15,%eax
    465a:	cd 40                	int    $0x40
    465c:	c3                   	ret    

0000465d <kill>:
SYSCALL(kill)
    465d:	b8 06 00 00 00       	mov    $0x6,%eax
    4662:	cd 40                	int    $0x40
    4664:	c3                   	ret    

00004665 <exec>:
SYSCALL(exec)
    4665:	b8 07 00 00 00       	mov    $0x7,%eax
    466a:	cd 40                	int    $0x40
    466c:	c3                   	ret    

0000466d <open>:
SYSCALL(open)
    466d:	b8 0f 00 00 00       	mov    $0xf,%eax
    4672:	cd 40                	int    $0x40
    4674:	c3                   	ret    

00004675 <mknod>:
SYSCALL(mknod)
    4675:	b8 11 00 00 00       	mov    $0x11,%eax
    467a:	cd 40                	int    $0x40
    467c:	c3                   	ret    

0000467d <unlink>:
SYSCALL(unlink)
    467d:	b8 12 00 00 00       	mov    $0x12,%eax
    4682:	cd 40                	int    $0x40
    4684:	c3                   	ret    

00004685 <fstat>:
SYSCALL(fstat)
    4685:	b8 08 00 00 00       	mov    $0x8,%eax
    468a:	cd 40                	int    $0x40
    468c:	c3                   	ret    

0000468d <link>:
SYSCALL(link)
    468d:	b8 13 00 00 00       	mov    $0x13,%eax
    4692:	cd 40                	int    $0x40
    4694:	c3                   	ret    

00004695 <mkdir>:
SYSCALL(mkdir)
    4695:	b8 14 00 00 00       	mov    $0x14,%eax
    469a:	cd 40                	int    $0x40
    469c:	c3                   	ret    

0000469d <chdir>:
SYSCALL(chdir)
    469d:	b8 09 00 00 00       	mov    $0x9,%eax
    46a2:	cd 40                	int    $0x40
    46a4:	c3                   	ret    

000046a5 <dup>:
SYSCALL(dup)
    46a5:	b8 0a 00 00 00       	mov    $0xa,%eax
    46aa:	cd 40                	int    $0x40
    46ac:	c3                   	ret    

000046ad <getpid>:
SYSCALL(getpid)
    46ad:	b8 0b 00 00 00       	mov    $0xb,%eax
    46b2:	cd 40                	int    $0x40
    46b4:	c3                   	ret    

000046b5 <sbrk>:
SYSCALL(sbrk)
    46b5:	b8 0c 00 00 00       	mov    $0xc,%eax
    46ba:	cd 40                	int    $0x40
    46bc:	c3                   	ret    

000046bd <sleep>:
SYSCALL(sleep)
    46bd:	b8 0d 00 00 00       	mov    $0xd,%eax
    46c2:	cd 40                	int    $0x40
    46c4:	c3                   	ret    

000046c5 <uptime>:
SYSCALL(uptime)
    46c5:	b8 0e 00 00 00       	mov    $0xe,%eax
    46ca:	cd 40                	int    $0x40
    46cc:	c3                   	ret    

000046cd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    46cd:	55                   	push   %ebp
    46ce:	89 e5                	mov    %esp,%ebp
    46d0:	83 ec 18             	sub    $0x18,%esp
    46d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    46d6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    46d9:	83 ec 04             	sub    $0x4,%esp
    46dc:	6a 01                	push   $0x1
    46de:	8d 45 f4             	lea    -0xc(%ebp),%eax
    46e1:	50                   	push   %eax
    46e2:	ff 75 08             	pushl  0x8(%ebp)
    46e5:	e8 63 ff ff ff       	call   464d <write>
    46ea:	83 c4 10             	add    $0x10,%esp
}
    46ed:	90                   	nop
    46ee:	c9                   	leave  
    46ef:	c3                   	ret    

000046f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    46f0:	55                   	push   %ebp
    46f1:	89 e5                	mov    %esp,%ebp
    46f3:	53                   	push   %ebx
    46f4:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    46f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    46fe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    4702:	74 17                	je     471b <printint+0x2b>
    4704:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    4708:	79 11                	jns    471b <printint+0x2b>
    neg = 1;
    470a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    4711:	8b 45 0c             	mov    0xc(%ebp),%eax
    4714:	f7 d8                	neg    %eax
    4716:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4719:	eb 06                	jmp    4721 <printint+0x31>
  } else {
    x = xx;
    471b:	8b 45 0c             	mov    0xc(%ebp),%eax
    471e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    4721:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    4728:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    472b:	8d 41 01             	lea    0x1(%ecx),%eax
    472e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4731:	8b 5d 10             	mov    0x10(%ebp),%ebx
    4734:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4737:	ba 00 00 00 00       	mov    $0x0,%edx
    473c:	f7 f3                	div    %ebx
    473e:	89 d0                	mov    %edx,%eax
    4740:	0f b6 80 64 5e 00 00 	movzbl 0x5e64(%eax),%eax
    4747:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    474b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    474e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4751:	ba 00 00 00 00       	mov    $0x0,%edx
    4756:	f7 f3                	div    %ebx
    4758:	89 45 ec             	mov    %eax,-0x14(%ebp)
    475b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    475f:	75 c7                	jne    4728 <printint+0x38>
  if(neg)
    4761:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4765:	74 2d                	je     4794 <printint+0xa4>
    buf[i++] = '-';
    4767:	8b 45 f4             	mov    -0xc(%ebp),%eax
    476a:	8d 50 01             	lea    0x1(%eax),%edx
    476d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4770:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    4775:	eb 1d                	jmp    4794 <printint+0xa4>
    putc(fd, buf[i]);
    4777:	8d 55 dc             	lea    -0x24(%ebp),%edx
    477a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    477d:	01 d0                	add    %edx,%eax
    477f:	0f b6 00             	movzbl (%eax),%eax
    4782:	0f be c0             	movsbl %al,%eax
    4785:	83 ec 08             	sub    $0x8,%esp
    4788:	50                   	push   %eax
    4789:	ff 75 08             	pushl  0x8(%ebp)
    478c:	e8 3c ff ff ff       	call   46cd <putc>
    4791:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    4794:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    4798:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    479c:	79 d9                	jns    4777 <printint+0x87>
    putc(fd, buf[i]);
}
    479e:	90                   	nop
    479f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    47a2:	c9                   	leave  
    47a3:	c3                   	ret    

000047a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    47a4:	55                   	push   %ebp
    47a5:	89 e5                	mov    %esp,%ebp
    47a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    47aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    47b1:	8d 45 0c             	lea    0xc(%ebp),%eax
    47b4:	83 c0 04             	add    $0x4,%eax
    47b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    47ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    47c1:	e9 59 01 00 00       	jmp    491f <printf+0x17b>
    c = fmt[i] & 0xff;
    47c6:	8b 55 0c             	mov    0xc(%ebp),%edx
    47c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    47cc:	01 d0                	add    %edx,%eax
    47ce:	0f b6 00             	movzbl (%eax),%eax
    47d1:	0f be c0             	movsbl %al,%eax
    47d4:	25 ff 00 00 00       	and    $0xff,%eax
    47d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    47dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    47e0:	75 2c                	jne    480e <printf+0x6a>
      if(c == '%'){
    47e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    47e6:	75 0c                	jne    47f4 <printf+0x50>
        state = '%';
    47e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    47ef:	e9 27 01 00 00       	jmp    491b <printf+0x177>
      } else {
        putc(fd, c);
    47f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    47f7:	0f be c0             	movsbl %al,%eax
    47fa:	83 ec 08             	sub    $0x8,%esp
    47fd:	50                   	push   %eax
    47fe:	ff 75 08             	pushl  0x8(%ebp)
    4801:	e8 c7 fe ff ff       	call   46cd <putc>
    4806:	83 c4 10             	add    $0x10,%esp
    4809:	e9 0d 01 00 00       	jmp    491b <printf+0x177>
      }
    } else if(state == '%'){
    480e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    4812:	0f 85 03 01 00 00    	jne    491b <printf+0x177>
      if(c == 'd'){
    4818:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    481c:	75 1e                	jne    483c <printf+0x98>
        printint(fd, *ap, 10, 1);
    481e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4821:	8b 00                	mov    (%eax),%eax
    4823:	6a 01                	push   $0x1
    4825:	6a 0a                	push   $0xa
    4827:	50                   	push   %eax
    4828:	ff 75 08             	pushl  0x8(%ebp)
    482b:	e8 c0 fe ff ff       	call   46f0 <printint>
    4830:	83 c4 10             	add    $0x10,%esp
        ap++;
    4833:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4837:	e9 d8 00 00 00       	jmp    4914 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    483c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4840:	74 06                	je     4848 <printf+0xa4>
    4842:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    4846:	75 1e                	jne    4866 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    4848:	8b 45 e8             	mov    -0x18(%ebp),%eax
    484b:	8b 00                	mov    (%eax),%eax
    484d:	6a 00                	push   $0x0
    484f:	6a 10                	push   $0x10
    4851:	50                   	push   %eax
    4852:	ff 75 08             	pushl  0x8(%ebp)
    4855:	e8 96 fe ff ff       	call   46f0 <printint>
    485a:	83 c4 10             	add    $0x10,%esp
        ap++;
    485d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4861:	e9 ae 00 00 00       	jmp    4914 <printf+0x170>
      } else if(c == 's'){
    4866:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    486a:	75 43                	jne    48af <printf+0x10b>
        s = (char*)*ap;
    486c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    486f:	8b 00                	mov    (%eax),%eax
    4871:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4874:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    487c:	75 25                	jne    48a3 <printf+0xff>
          s = "(null)";
    487e:	c7 45 f4 a3 59 00 00 	movl   $0x59a3,-0xc(%ebp)
        while(*s != 0){
    4885:	eb 1c                	jmp    48a3 <printf+0xff>
          putc(fd, *s);
    4887:	8b 45 f4             	mov    -0xc(%ebp),%eax
    488a:	0f b6 00             	movzbl (%eax),%eax
    488d:	0f be c0             	movsbl %al,%eax
    4890:	83 ec 08             	sub    $0x8,%esp
    4893:	50                   	push   %eax
    4894:	ff 75 08             	pushl  0x8(%ebp)
    4897:	e8 31 fe ff ff       	call   46cd <putc>
    489c:	83 c4 10             	add    $0x10,%esp
          s++;
    489f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    48a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    48a6:	0f b6 00             	movzbl (%eax),%eax
    48a9:	84 c0                	test   %al,%al
    48ab:	75 da                	jne    4887 <printf+0xe3>
    48ad:	eb 65                	jmp    4914 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    48af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    48b3:	75 1d                	jne    48d2 <printf+0x12e>
        putc(fd, *ap);
    48b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    48b8:	8b 00                	mov    (%eax),%eax
    48ba:	0f be c0             	movsbl %al,%eax
    48bd:	83 ec 08             	sub    $0x8,%esp
    48c0:	50                   	push   %eax
    48c1:	ff 75 08             	pushl  0x8(%ebp)
    48c4:	e8 04 fe ff ff       	call   46cd <putc>
    48c9:	83 c4 10             	add    $0x10,%esp
        ap++;
    48cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    48d0:	eb 42                	jmp    4914 <printf+0x170>
      } else if(c == '%'){
    48d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    48d6:	75 17                	jne    48ef <printf+0x14b>
        putc(fd, c);
    48d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    48db:	0f be c0             	movsbl %al,%eax
    48de:	83 ec 08             	sub    $0x8,%esp
    48e1:	50                   	push   %eax
    48e2:	ff 75 08             	pushl  0x8(%ebp)
    48e5:	e8 e3 fd ff ff       	call   46cd <putc>
    48ea:	83 c4 10             	add    $0x10,%esp
    48ed:	eb 25                	jmp    4914 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    48ef:	83 ec 08             	sub    $0x8,%esp
    48f2:	6a 25                	push   $0x25
    48f4:	ff 75 08             	pushl  0x8(%ebp)
    48f7:	e8 d1 fd ff ff       	call   46cd <putc>
    48fc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    48ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4902:	0f be c0             	movsbl %al,%eax
    4905:	83 ec 08             	sub    $0x8,%esp
    4908:	50                   	push   %eax
    4909:	ff 75 08             	pushl  0x8(%ebp)
    490c:	e8 bc fd ff ff       	call   46cd <putc>
    4911:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    4914:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    491b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    491f:	8b 55 0c             	mov    0xc(%ebp),%edx
    4922:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4925:	01 d0                	add    %edx,%eax
    4927:	0f b6 00             	movzbl (%eax),%eax
    492a:	84 c0                	test   %al,%al
    492c:	0f 85 94 fe ff ff    	jne    47c6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4932:	90                   	nop
    4933:	c9                   	leave  
    4934:	c3                   	ret    

00004935 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4935:	55                   	push   %ebp
    4936:	89 e5                	mov    %esp,%ebp
    4938:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    493b:	8b 45 08             	mov    0x8(%ebp),%eax
    493e:	83 e8 08             	sub    $0x8,%eax
    4941:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4944:	a1 f8 5e 00 00       	mov    0x5ef8,%eax
    4949:	89 45 fc             	mov    %eax,-0x4(%ebp)
    494c:	eb 24                	jmp    4972 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    494e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4951:	8b 00                	mov    (%eax),%eax
    4953:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4956:	77 12                	ja     496a <free+0x35>
    4958:	8b 45 f8             	mov    -0x8(%ebp),%eax
    495b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    495e:	77 24                	ja     4984 <free+0x4f>
    4960:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4963:	8b 00                	mov    (%eax),%eax
    4965:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4968:	77 1a                	ja     4984 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    496a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    496d:	8b 00                	mov    (%eax),%eax
    496f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4972:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4975:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4978:	76 d4                	jbe    494e <free+0x19>
    497a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    497d:	8b 00                	mov    (%eax),%eax
    497f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4982:	76 ca                	jbe    494e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4984:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4987:	8b 40 04             	mov    0x4(%eax),%eax
    498a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4991:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4994:	01 c2                	add    %eax,%edx
    4996:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4999:	8b 00                	mov    (%eax),%eax
    499b:	39 c2                	cmp    %eax,%edx
    499d:	75 24                	jne    49c3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    499f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    49a2:	8b 50 04             	mov    0x4(%eax),%edx
    49a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    49a8:	8b 00                	mov    (%eax),%eax
    49aa:	8b 40 04             	mov    0x4(%eax),%eax
    49ad:	01 c2                	add    %eax,%edx
    49af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    49b2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    49b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    49b8:	8b 00                	mov    (%eax),%eax
    49ba:	8b 10                	mov    (%eax),%edx
    49bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    49bf:	89 10                	mov    %edx,(%eax)
    49c1:	eb 0a                	jmp    49cd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    49c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    49c6:	8b 10                	mov    (%eax),%edx
    49c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    49cb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    49cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    49d0:	8b 40 04             	mov    0x4(%eax),%eax
    49d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    49da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    49dd:	01 d0                	add    %edx,%eax
    49df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    49e2:	75 20                	jne    4a04 <free+0xcf>
    p->s.size += bp->s.size;
    49e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    49e7:	8b 50 04             	mov    0x4(%eax),%edx
    49ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    49ed:	8b 40 04             	mov    0x4(%eax),%eax
    49f0:	01 c2                	add    %eax,%edx
    49f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    49f5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    49f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    49fb:	8b 10                	mov    (%eax),%edx
    49fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4a00:	89 10                	mov    %edx,(%eax)
    4a02:	eb 08                	jmp    4a0c <free+0xd7>
  } else
    p->s.ptr = bp;
    4a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4a07:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4a0a:	89 10                	mov    %edx,(%eax)
  freep = p;
    4a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4a0f:	a3 f8 5e 00 00       	mov    %eax,0x5ef8
}
    4a14:	90                   	nop
    4a15:	c9                   	leave  
    4a16:	c3                   	ret    

00004a17 <morecore>:

static Header*
morecore(uint nu)
{
    4a17:	55                   	push   %ebp
    4a18:	89 e5                	mov    %esp,%ebp
    4a1a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    4a1d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4a24:	77 07                	ja     4a2d <morecore+0x16>
    nu = 4096;
    4a26:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4a2d:	8b 45 08             	mov    0x8(%ebp),%eax
    4a30:	c1 e0 03             	shl    $0x3,%eax
    4a33:	83 ec 0c             	sub    $0xc,%esp
    4a36:	50                   	push   %eax
    4a37:	e8 79 fc ff ff       	call   46b5 <sbrk>
    4a3c:	83 c4 10             	add    $0x10,%esp
    4a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4a42:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4a46:	75 07                	jne    4a4f <morecore+0x38>
    return 0;
    4a48:	b8 00 00 00 00       	mov    $0x0,%eax
    4a4d:	eb 26                	jmp    4a75 <morecore+0x5e>
  hp = (Header*)p;
    4a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4a58:	8b 55 08             	mov    0x8(%ebp),%edx
    4a5b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    4a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4a61:	83 c0 08             	add    $0x8,%eax
    4a64:	83 ec 0c             	sub    $0xc,%esp
    4a67:	50                   	push   %eax
    4a68:	e8 c8 fe ff ff       	call   4935 <free>
    4a6d:	83 c4 10             	add    $0x10,%esp
  return freep;
    4a70:	a1 f8 5e 00 00       	mov    0x5ef8,%eax
}
    4a75:	c9                   	leave  
    4a76:	c3                   	ret    

00004a77 <malloc>:

void*
malloc(uint nbytes)
{
    4a77:	55                   	push   %ebp
    4a78:	89 e5                	mov    %esp,%ebp
    4a7a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4a7d:	8b 45 08             	mov    0x8(%ebp),%eax
    4a80:	83 c0 07             	add    $0x7,%eax
    4a83:	c1 e8 03             	shr    $0x3,%eax
    4a86:	83 c0 01             	add    $0x1,%eax
    4a89:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4a8c:	a1 f8 5e 00 00       	mov    0x5ef8,%eax
    4a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4a98:	75 23                	jne    4abd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    4a9a:	c7 45 f0 f0 5e 00 00 	movl   $0x5ef0,-0x10(%ebp)
    4aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4aa4:	a3 f8 5e 00 00       	mov    %eax,0x5ef8
    4aa9:	a1 f8 5e 00 00       	mov    0x5ef8,%eax
    4aae:	a3 f0 5e 00 00       	mov    %eax,0x5ef0
    base.s.size = 0;
    4ab3:	c7 05 f4 5e 00 00 00 	movl   $0x0,0x5ef4
    4aba:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4ac0:	8b 00                	mov    (%eax),%eax
    4ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    4ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4ac8:	8b 40 04             	mov    0x4(%eax),%eax
    4acb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4ace:	72 4d                	jb     4b1d <malloc+0xa6>
      if(p->s.size == nunits)
    4ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4ad3:	8b 40 04             	mov    0x4(%eax),%eax
    4ad6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4ad9:	75 0c                	jne    4ae7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    4adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4ade:	8b 10                	mov    (%eax),%edx
    4ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4ae3:	89 10                	mov    %edx,(%eax)
    4ae5:	eb 26                	jmp    4b0d <malloc+0x96>
      else {
        p->s.size -= nunits;
    4ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4aea:	8b 40 04             	mov    0x4(%eax),%eax
    4aed:	2b 45 ec             	sub    -0x14(%ebp),%eax
    4af0:	89 c2                	mov    %eax,%edx
    4af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4af5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    4af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4afb:	8b 40 04             	mov    0x4(%eax),%eax
    4afe:	c1 e0 03             	shl    $0x3,%eax
    4b01:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    4b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4b07:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4b0a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    4b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4b10:	a3 f8 5e 00 00       	mov    %eax,0x5ef8
      return (void*)(p + 1);
    4b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4b18:	83 c0 08             	add    $0x8,%eax
    4b1b:	eb 3b                	jmp    4b58 <malloc+0xe1>
    }
    if(p == freep)
    4b1d:	a1 f8 5e 00 00       	mov    0x5ef8,%eax
    4b22:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    4b25:	75 1e                	jne    4b45 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    4b27:	83 ec 0c             	sub    $0xc,%esp
    4b2a:	ff 75 ec             	pushl  -0x14(%ebp)
    4b2d:	e8 e5 fe ff ff       	call   4a17 <morecore>
    4b32:	83 c4 10             	add    $0x10,%esp
    4b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4b3c:	75 07                	jne    4b45 <malloc+0xce>
        return 0;
    4b3e:	b8 00 00 00 00       	mov    $0x0,%eax
    4b43:	eb 13                	jmp    4b58 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4b4e:	8b 00                	mov    (%eax),%eax
    4b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4b53:	e9 6d ff ff ff       	jmp    4ac5 <malloc+0x4e>
}
    4b58:	c9                   	leave  
    4b59:	c3                   	ret    
