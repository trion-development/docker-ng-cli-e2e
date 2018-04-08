#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

static int (*real_execve)(const char *filename, char *const argv[], char *const envp[])=0;

int execve(const char *filename, char *const argv[], char *const envp[]) {
  if (!real_execve) {
    real_execve = dlsym(RTLD_NEXT, "execve");
  }

  if (strstr(filename, "node_modules/protractor/node_modules/webdriver-manager/selenium/chromedriver")) {
    //return real_execve("/usr/bin/chromedriver", argv, envp);
    printf("intercepted %s (and replaced)\n", filename);
    return real_execve("/usr/bin/chromedriver", argv, envp);
  }
  printf("intercepted %s (and passed)\n", filename);
  return real_execve(filename, argv, envp);
}
