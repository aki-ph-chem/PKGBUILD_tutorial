#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
    if(argc < 2) {
        fprintf(stderr, "Error: No args\n");
        exit(1);
    }

    char* name = argv[1];
    printf("Hello %s! \n",name);
}
