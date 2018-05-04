#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <dlfcn.h>
#include <string.h>
#include <stdlib.h>

static int (*real_execve)(const char *filename, char *const argv[], char *const envp[])=0;
static int (*real_execv)(const char *file, char *const argv[])=0;


// int execl(const char *path, const char *arg, ...);
// int execlp(const char *file, const char *arg, ...);
// int execle(const char *path, const char *arg, ..., char * const envp[]);
// int execv(const char *path, char *const argv[]);
// int execvp(const char *file, char *const argv[]);
// int execvpe(const char *file, char *const argv[], char *const envp[]);

int execl(const char *path, const char *arg, ...){
  printf("intercepted execl %s, %s\n", path, arg);
}

int execlp(const char *file, const char *arg, ...){
  printf("intercepted execlp %s, %s\n", file, arg);
}

int execle(const char *path, const char *arg, ...){
  printf("intercepted execle %s, %s\n", path, arg);
}

int setenv(const char *name, const char *value, int overwrite) {
  printf("intercepted setenv %s, %s\n", name, value);
}
int unsetenv(const char *name){
  printf("intercepted unsetenv %s\n", name);
  printf("preload env: %s\n", getenv("LD_PRELOAD"));
}

int clearenv() {
  printf("intercepted clearenv\n");
}

int clone(int (*fn)(void *), void *child_stack, int flags, void *arg, ...
/* pid_t *ptid, void *newtls, pid_t *ctid */ ) {
  printf("intercepted clone\n");
}


int execv(const char *filename, char *const argv[]){
    if (!real_execv) {
      real_execv = dlsym(RTLD_NEXT, "execv");
    }
  printf("intercepted execv %s (and passed)\n", filename);
  return real_execv(filename, argv);
}

int execvpe(const char *filename, char *const argv[], char *const envp[]) {
  if (!real_execve) {
    real_execve = dlsym(RTLD_NEXT, "execve");
  }
  printf("intercepted execvpe %s (and passed)\n", filename);
  return real_execve("/usr/bin/chromedriver", argv, envp);
}

int execve(const char *filename, char *const argv[], char *const envp[]) {
  if (!real_execve) {
    real_execve = dlsym(RTLD_NEXT, "execve");
  }

  if (strstr(filename, "node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver")) {
    //return real_execve("/usr/bin/chromedriver", argv, envp);
    printf("intercepted %s (and replaced)\n", filename);
  }
  printf("intercepted %s (and passed)\n", filename);

  int i=0;
  for (i=0; envp[i] != '\0'; i++)
  {
    //count elements in i
   //printf("env: %s\n", envp[i]);
  }
  size_t newSize = (i+1) * sizeof(char*);
  char** envn = (char **) malloc(newSize);
  if (envn == NULL)
  {
    printf("Could not allocate memory!\n");
    exit -1;
  }

  char* preload = "LD_PRELOAD=/usr/local/lib/intercept-execve.so";
  envn[i] = preload;
  envn[i+1] = '\0';

  for (int i=0; envp[i] != '\0'; i++)
  {
    envn[i] = envp[i];
  }

  for (i=0; envn[i] != '\0'; i++)
  {
     printf("env: %s\n", envn[i]);
  }

  return real_execve(filename, argv, (char* const*) envn);
  //free(envn) ignored;
}
