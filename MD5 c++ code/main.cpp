#include "MD5.h"
 
int main(int argc, char *argv[]) {
    // Output the test cases when no-input argv
    if (argc <= 1) {
        for (int a=1; a<101; a++){
        std::cout << "MD5(\"The quick brown fox jumps over the lazy dog\") = " << md5("The quick brown fox jumps over the lazy dog") << std::endl;
       
        std::cout << ""<<a<<std::endl;}
    } else {
        // Output the MD5 value of each input argv
        for (int i = 1; i < argc; i++) {
            std::cout << "MD5(\"" << argv[i] << "\") = " << md5(std::string(argv[i])) << std::endl;
        }
    }
    return 0;
}
