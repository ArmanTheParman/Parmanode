#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char ** argv) {

if(argc == 1) { perror("No args. Exiting"); return 1 ; }

//if(strcmp(argv[1], "systemctl") && strcmp(argv[2], "restart") && strcmp(argv[3], "tor"))
//   execl(argv[1], argv[2], argv[3], argv[4], argv[5], NULL);
   execl("/usr/bin/systemctl", "systemctl", "start", "tor", NULL);

return 0;
}