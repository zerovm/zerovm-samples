/*
 * this sample demonstrate zrt library - simple way to use libc
 * from untrusted code.
 */
#include <stdio.h>
#include <stdlib.h>

#include <wchar.h>
#include <assert.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define TEST_FILE "Makefile"

int main(int argc, char **argv)
{
  /* write to default device (in our case it is stdout) */
  printf("hello, world\n");

  const char *file = "/tar/"TEST_FILE;
  const char *file_orig = "/mnt/tar/"TEST_FILE;

  struct stat st;
  int err = stat(file, &st);
  /* write to user log (stderr) */
  printf("err=%d, /tar/%s\n", err, TEST_FILE);

  int fd = open(file, O_WRONLY);
  assert(fd>=0);
  printf("open O_WRONLY err=%d, %s\n", err, file);
  ssize_t bytes_wrote = write(fd, "hello", strlen("hello"));
  assert(strlen("hello")==bytes_wrote);
  printf("wrote bytes=%d, %s\n", bytes_wrote, file);
  close(fd);

  char buf[100];
  fd = open(file, O_RDONLY);
  printf("open O_RDONLY fd=%d, %s\n", fd, file);
  ssize_t bytes_read = read(fd, buf, strlen("hello"));
  close(fd);
  assert(!strcmp("hello", buf));

  fd = open(file_orig, O_RDONLY);
  printf("open O_RDONLY fd=%d, %s\n", fd, file_orig);
  bytes_read = read(fd, buf, strlen("hello"));
  close(fd);
  assert(strcmp("hello", buf));

  return 0;
}
