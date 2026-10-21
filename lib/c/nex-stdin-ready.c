#include <sys/select.h>
#include <unistd.h>
#include <stdio.h>

int main(void) {
	fd_set fds;
	struct timeval timeout = {0, 0};  /* Don't wait */

	FD_ZERO(&fds);
	FD_SET(STDIN_FILENO, &fds);

	int result = select(STDIN_FILENO + 1, &fds, NULL, NULL, &timeout);

	if (result < 0)
		return 2;

	if (result == 0)
		return 1;
	return 0;
}

