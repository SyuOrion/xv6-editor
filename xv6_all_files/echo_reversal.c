//*********************************************
// author:  xufang
// date:    2019/3/24
//*********************************************

#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    for (int i =1; i < argc; i++){
        int l = strlen(argv[i]) - 1;
        for(; l >= 0; l--){
            printf(1, "%c", argv[i][l]);
        }
        if (i+1 < argc)
            printf(1, " ");
        else
            printf(1, "\n");
    }
    exit();
}
