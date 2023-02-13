#if 0
	shc Version 3.8.7, Generic Script Compiler
	Copyright (c) 1994-2009 Francisco Rosales <frosal@fi.upm.es>

	shc -f askpass.sh 
#endif

static  char data [] = 
#define      lsto_z	1
#define      lsto	((&data[0]))
	"\023"
#define      opts_z	1
#define      opts	((&data[1]))
	"\224"
#define      xecc_z	15
#define      xecc	((&data[4]))
	"\304\216\223\013\232\142\364\327\253\140\117\022\126\377\241\325"
	"\371\052"
#define      rlax_z	1
#define      rlax	((&data[20]))
	"\063"
#define      inlo_z	3
#define      inlo	((&data[21]))
	"\124\375\304"
#define      shll_z	10
#define      shll	((&data[26]))
	"\047\040\077\232\257\162\045\163\110\103\111\106\167\207"
#define      tst1_z	22
#define      tst1	((&data[41]))
	"\270\062\113\311\030\257\126\352\041\112\252\211\077\101\224\357"
	"\257\031\345\115\257\145\003\054\041\043\070\345"
#define      chk2_z	19
#define      chk2	((&data[70]))
	"\122\173\044\026\032\101\000\327\362\362\164\246\217\343\107\244"
	"\125\331\114\366\076\014\104\011\116\307"
#define      chk1_z	22
#define      chk1	((&data[92]))
	"\174\206\022\176\025\141\224\350\342\216\120\315\111\103\251\307"
	"\224\356\134\276\004\041"
#define      text_z	141
#define      text	((&data[116]))
	"\261\367\340\320\171\170\216\335\144\113\126\366\346\270\046\243"
	"\227\313\356\056\216\271\147\234\273\133\371\146\263\115\317\366"
	"\145\140\350\170\240\231\314\217\055\314\041\112\246\232\165\034"
	"\302\022\134\262\303\007\015\164\305\235\115\334\220\301\262\251"
	"\143\001\151\270\220\021\336\206\300\127\215\337\344\337\220\201"
	"\027\106\030\115\156\064\205\042\342\272\334\143\065\005\061\155"
	"\302\126\260\021\107\267\340\314\250\146\155\074\240\067\235\146"
	"\247\101\300\120\134\226\201\003\054\174\373\320\020\260\030\327"
	"\025\333\266\020\057\121\237\057\063\370\125\134\230\340\163\163"
	"\322\156\373\102\002\201\372\065\314"
#define      msg1_z	42
#define      msg1	((&data[271]))
	"\016\113\151\141\014\026\351\314\012\170\064\003\206\104\060\051"
	"\115\143\052\044\143\016\275\172\047\123\247\052\253\144\166\013"
	"\274\002\062\246\034\047\356\016\167\070\231\302\171\131\306\215"
	"\170\317\333\100\137"
#define      pswd_z	256
#define      pswd	((&data[340]))
	"\010\235\353\377\021\275\156\015\377\161\216\372\246\133\031\024"
	"\015\047\140\166\005\365\164\154\161\135\333\150\126\140\011\144"
	"\326\356\106\220\367\025\056\147\062\273\124\304\345\317\153\377"
	"\025\372\377\032\357\164\207\141\322\142\311\050\303\323\215\231"
	"\301\323\051\271\351\130\041\033\023\165\337\371\104\112\370\131"
	"\105\370\163\065\154\373\226\076\135\137\147\040\062\364\272\364"
	"\310\343\255\261\074\316\315\117\103\254\110\210\367\101\341\074"
	"\072\125\161\246\120\007\345\256\147\115\316\231\101\210\216\012"
	"\154\074\274\250\012\211\370\116\066\101\327\055\203\270\151\275"
	"\016\333\144\136\342\111\014\112\226\333\343\330\144\162\343\321"
	"\256\237\172\271\051\162\007\137\264\337\215\070\227\366\365\246"
	"\322\132\004\264\243\021\376\072\355\342\023\121\124\366\043\003"
	"\226\235\274\300\020\304\037\304\243\255\374\072\244\362\340\166"
	"\114\345\053\360\367\052\052\345\014\076\067\141\064\132\145\313"
	"\367\041\213\007\345\253\314\210\130\310\303\374\273\244\162\007"
	"\212\235\370\202\307\043\147\324\141\236\066\226\370\233\141\360"
	"\275\355\370\242\230\304\052\360\215\356\355\110\222\140\120\034"
	"\375\110\236\305\210\046\004\000\366\340\100\125\327\222\217\340"
	"\060\172"
#define      tst2_z	19
#define      tst2	((&data[611]))
	"\116\305\217\170\067\002\276\163\201\205\057\341\162\277\347\163"
	"\041\160\037\125\116"
#define      msg2_z	19
#define      msg2	((&data[634]))
	"\062\146\070\325\272\112\226\211\326\163\126\213\216\070\253\145"
	"\335\367\276\107\024\253\114\173\105\163"
#define      date_z	1
#define      date	((&data[657]))
	"\025"/* End of data[] */;
#define      hide_z	4096
#define DEBUGEXEC	0	/* Define as 1 to debug execvp calls */
#define TRACEABLE	0	/* Define as 1 to enable ptrace the executable */

/* rtc.c */

#include <sys/stat.h>
#include <sys/types.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

/* 'Alleged RC4' */

static unsigned char stte[256], indx, jndx, kndx;

/*
 * Reset arc4 stte. 
 */
void stte_0(void)
{
	indx = jndx = kndx = 0;
	do {
		stte[indx] = indx;
	} while (++indx);
}

/*
 * Set key. Can be used more than once. 
 */
void key(void * str, int len)
{
	unsigned char tmp, * ptr = (unsigned char *)str;
	while (len > 0) {
		do {
			tmp = stte[indx];
			kndx += tmp;
			kndx += ptr[(int)indx % len];
			stte[indx] = stte[kndx];
			stte[kndx] = tmp;
		} while (++indx);
		ptr += 256;
		len -= 256;
	}
}

/*
 * Crypt data. 
 */
void arc4(void * str, int len)
{
	unsigned char tmp, * ptr = (unsigned char *)str;
	while (len > 0) {
		indx++;
		tmp = stte[indx];
		jndx += tmp;
		stte[indx] = stte[jndx];
		stte[jndx] = tmp;
		tmp += stte[indx];
		*ptr ^= stte[tmp];
		ptr++;
		len--;
	}
}

/* End of ARC4 */

/*
 * Key with file invariants. 
 */
int key_with_file(char * file)
{
	struct stat statf[1];
	struct stat control[1];

	if (stat(file, statf) < 0)
		return -1;

	/* Turn on stable fields */
	memset(control, 0, sizeof(control));
	control->st_ino = statf->st_ino;
	control->st_dev = statf->st_dev;
	control->st_rdev = statf->st_rdev;
	control->st_uid = statf->st_uid;
	control->st_gid = statf->st_gid;
	control->st_size = statf->st_size;
	control->st_mtime = statf->st_mtime;
	control->st_ctime = statf->st_ctime;
	key(control, sizeof(control));
	return 0;
}

#if DEBUGEXEC
void debugexec(char * sh11, int argc, char ** argv)
{
	int i;
	fprintf(stderr, "shll=%s\n", sh11 ? sh11 : "<null>");
	fprintf(stderr, "argc=%d\n", argc);
	if (!argv) {
		fprintf(stderr, "argv=<null>\n");
	} else { 
		for (i = 0; i <= argc ; i++)
			fprintf(stderr, "argv[%d]=%.60s\n", i, argv[i] ? argv[i] : "<null>");
	}
}
#endif /* DEBUGEXEC */

void rmarg(char ** argv, char * arg)
{
	for (; argv && *argv && *argv != arg; argv++);
	for (; argv && *argv; argv++)
		*argv = argv[1];
}

int chkenv(int argc)
{
	char buff[512];
	unsigned long mask, m;
	int l, a, c;
	char * string;
	extern char ** environ;

	mask  = (unsigned long)&chkenv;
	mask ^= (unsigned long)getpid() * ~mask;
	sprintf(buff, "x%lx", mask);
	string = getenv(buff);
#if DEBUGEXEC
	fprintf(stderr, "getenv(%s)=%s\n", buff, string ? string : "<null>");
#endif
	l = strlen(buff);
	if (!string) {
		/* 1st */
		sprintf(&buff[l], "=%lu %d", mask, argc);
		putenv(strdup(buff));
		return 0;
	}
	c = sscanf(string, "%lu %d%c", &m, &a, buff);
	if (c == 2 && m == mask) {
		/* 3rd */
		rmarg(environ, &string[-l - 1]);
		return 1 + (argc - a);
	}
	return -1;
}

#if !defined(TRACEABLE)

#define _LINUX_SOURCE_COMPAT
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <unistd.h>

#if !defined(PTRACE_ATTACH) && defined(PT_ATTACH)
#	define PTRACE_ATTACH	PT_ATTACH
#endif
void untraceable(char * argv0)
{
	char proc[80];
	int pid, mine;

	switch(pid = fork()) {
	case  0:
		pid = getppid();
		/* For problematic SunOS ptrace */
#if defined(__FreeBSD__)
		sprintf(proc, "/proc/%d/mem", (int)pid);
#else
		sprintf(proc, "/proc/%d/as",  (int)pid);
#endif
		close(0);
		mine = !open(proc, O_RDWR|O_EXCL);
		if (!mine && errno != EBUSY)
			mine = !ptrace(PTRACE_ATTACH, pid, 0, 0);
		if (mine) {
			kill(pid, SIGCONT);
		} else {
			perror(argv0);
			kill(pid, SIGKILL);
		}
		_exit(mine);
	case -1:
		break;
	default:
		if (pid == waitpid(pid, 0, 0))
			return;
	}
	perror(argv0);
	_exit(1);
}
#endif /* !defined(TRACEABLE) */

char * xsh(int argc, char ** argv)
{
	char * scrpt;
	int ret, i, j;
	char ** varg;

	stte_0();
	 key(pswd, pswd_z);
	arc4(msg1, msg1_z);
	arc4(date, date_z);
	if (date[0] && (atoll(date)<time(NULL)))
		return msg1;
	arc4(shll, shll_z);
	arc4(inlo, inlo_z);
	arc4(xecc, xecc_z);
	arc4(lsto, lsto_z);
	arc4(tst1, tst1_z);
	 key(tst1, tst1_z);
	arc4(chk1, chk1_z);
	if ((chk1_z != tst1_z) || memcmp(tst1, chk1, tst1_z))
		return tst1;
	ret = chkenv(argc);
	arc4(msg2, msg2_z);
	if (ret < 0)
		return msg2;
	varg = (char **)calloc(argc + 10, sizeof(char *));
	if (!varg)
		return 0;
	if (ret) {
		arc4(rlax, rlax_z);
		if (!rlax[0] && key_with_file(shll))
			return shll;
		arc4(opts, opts_z);
		arc4(text, text_z);
		arc4(tst2, tst2_z);
		 key(tst2, tst2_z);
		arc4(chk2, chk2_z);
		if ((chk2_z != tst2_z) || memcmp(tst2, chk2, tst2_z))
			return tst2;
		if (text_z < hide_z) {
			/* Prepend spaces til a hide_z script size. */
			scrpt = malloc(hide_z);
			if (!scrpt)
				return 0;
			memset(scrpt, (int) ' ', hide_z);
			memcpy(&scrpt[hide_z - text_z], text, text_z);
		} else {
			scrpt = text;	/* Script text */
		}
	} else {			/* Reexecute */
		if (*xecc) {
			scrpt = malloc(512);
			if (!scrpt)
				return 0;
			sprintf(scrpt, xecc, argv[0]);
		} else {
			scrpt = argv[0];
		}
	}
	j = 0;
	varg[j++] = argv[0];		/* My own name at execution */
	if (ret && *opts)
		varg[j++] = opts;	/* Options on 1st line of code */
	if (*inlo)
		varg[j++] = inlo;	/* Option introducing inline code */
	varg[j++] = scrpt;		/* The script itself */
	if (*lsto)
		varg[j++] = lsto;	/* Option meaning last option */
	i = (ret > 1) ? ret : 0;	/* Args numbering correction */
	while (i < argc)
		varg[j++] = argv[i++];	/* Main run-time arguments */
	varg[j] = 0;			/* NULL terminated array */
#if DEBUGEXEC
	debugexec(shll, j, varg);
#endif
	execvp(shll, varg);
	return shll;
}

int main(int argc, char ** argv)
{
#if DEBUGEXEC
	debugexec("main", argc, argv);
#endif
#if !defined(TRACEABLE)
	untraceable(argv[0]);
#endif
	argv[1] = xsh(argc, argv);
	fprintf(stderr, "%s%s%s: %s\n", argv[0],
		errno ? ": " : "",
		errno ? strerror(errno) : "",
		argv[1] ? argv[1] : "<null>"
	);
	return 1;
}
