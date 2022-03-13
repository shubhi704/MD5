/*
wsl commands =>
g++ bm.cpp -std=c++11 -lpthread -O1
./a.out
*/



#include <benchmark/benchmark.h>
#include <iostream>
#include <cstring>
#include <cstdio>

#define S11 7
#define S12 12
#define S13 17
#define S14 22
#define S21 5
#define S22 9
#define S23 14
#define S24 20
#define S31 4
#define S32 11
#define S33 16
#define S34 23
#define S41 6
#define S42 10
#define S43 15
#define S44 21

#define blockSize 64

typedef unsigned int uInt; // 32-bit
typedef unsigned char uChar; // 8-bit(Byte)


class MD5 {
    public:
        MD5();
        MD5(const std::string&); 
        void update(const uChar*, uInt);
        void update(const char*, uInt);
        MD5& finalize();
        std::string hexdigest();
        friend std::ostream& operator << (std::ostream&, MD5);

        bool finish; // Flag to check transformation finished
        uInt count[2]; // 64-bit counter for number of bits(low, high)
        uInt state[4]; // Store A.B.C.D numbers while transforming
        uChar result[16]; // The result of MD5
        uChar buffer[blockSize];// Bytes that didn't fit in last 64 byte chunk

        void init();
        void transform(const uChar*);
        void decode(uInt*, const uChar*, uInt);
        void encode(uChar*, const uInt*, uInt);
        //std::string md5(const std::string);
        
        // F, G， H，I are the basic MD5 functions
        inline uInt F(uInt x, uInt y, uInt z) {
            return x & y | ~x & z;
        }

        inline uInt G(uInt x, uInt y, uInt z) {
            return x & z | y & ~z;
        }

        inline uInt H(uInt x, uInt y, uInt z) {
            return x ^ y ^ z;
        }

        inline uInt I(uInt x, uInt y, uInt z) {
            return y ^ (x | ~z);
        }

        // Rotates x left n bits
        inline uInt rotateLeft(uInt x, int n) {
            return (x << n) | (x >> (32 - n));
        }

        // FF, GG, HH, II transformations for rounds 1, 2, 3, 4.
        inline void FF(uInt &a, uInt b, uInt c, uInt d, uInt x, uInt s, uInt ac) {
            a = rotateLeft(a + F(b, c, d) + x + ac, s) + b;
        }

        inline void GG(uInt &a, uInt b, uInt c, uInt d, uInt x, uInt s, uInt ac) {
            a = rotateLeft(a + G(b, c, d) + x + ac, s) + b;
        }

        inline void HH(uInt &a, uInt b, uInt c, uInt d, uInt x, uInt s, uInt ac) {
            a = rotateLeft(a + H(b, c, d) + x + ac, s) + b;
        }

        inline void II(uInt &a, uInt b, uInt c, uInt d, uInt x, uInt s, uInt ac) {
            a = rotateLeft(a + I(b, c, d) + x + ac, s) + b;
        }
};

// Defualt Constructor, just initalize
MD5::MD5() {
    MD5::init();
}

// Constructor with string parameter and transform immediately
MD5::MD5(const std::string& str) {
    MD5::init();
    MD5::update(str.c_str(), str.length());
    MD5::finalize();
}

// Initialization
void MD5::init() {
    finish = false;
    count[0] = count[1] = 0;
    // Magic number
    state[0] = 0x67452301;
    state[1] = 0xefcdab89;
    state[2] = 0x98badcfe;
    state[3] = 0x10325476;
}

// MD5 block update operation with unsigned char
void MD5::update(const char input[], uInt length) {
    MD5::update((const uChar*)input, length);
}


// operation, processing another message block
void MD5::update(const uChar input[], uInt length) {
    // Compute number of bytes mod 64
    uInt index = count[0] / 8 % blockSize;
    // Update number of bits
    if ((count[0] += (length << 3)) < (length << 3)) {
        count[1]++;
    }
    count[1] += (length >> 29);
    // Number of bytes we need to fill in buffer
    uInt firstPart = 64 - index, i;
    // Transform as many times as possible
    if (length >= firstPart) {
        // Fill buffer first, transform
        memcpy(&buffer[index], input, firstPart);
        MD5::transform(buffer);
        // Transform chunks of blockSize(64)
        for (i = firstPart; i + blockSize <= length ; i += blockSize) {
            MD5::transform(&input[i]);
        }
        index = 0;
    } else {
        i = 0;
    }
    // Buffer remaining input
    memcpy(&buffer[index], &input[i], length - i);
}

void MD5::transform(const uChar block[blockSize]) {
    uInt a = state[0], b = state[1], c = state[2], d = state[3], x[16];
    MD5::decode (x, block, blockSize);

    // Round One
    MD5::FF (a, b, c, d, x[ 0], S11, 0xd76aa478);
    MD5::FF (d, a, b, c, x[ 1], S12, 0xe8c7b756);
    MD5::FF (c, d, a, b, x[ 2], S13, 0x242070db);
    MD5::FF (b, c, d, a, x[ 3], S14, 0xc1bdceee);
    MD5::FF (a, b, c, d, x[ 4], S11, 0xf57c0faf);
    MD5::FF (d, a, b, c, x[ 5], S12, 0x4787c62a);
    MD5::FF (c, d, a, b, x[ 6], S13, 0xa8304613);
    MD5::FF (b, c, d, a, x[ 7], S14, 0xfd469501);
    MD5::FF (a, b, c, d, x[ 8], S11, 0x698098d8);
    MD5::FF (d, a, b, c, x[ 9], S12, 0x8b44f7af);
    MD5::FF (c, d, a, b, x[10], S13, 0xffff5bb1);
    MD5::FF (b, c, d, a, x[11], S14, 0x895cd7be);
    MD5::FF (a, b, c, d, x[12], S11, 0x6b901122);
    MD5::FF (d, a, b, c, x[13], S12, 0xfd987193);
    MD5::FF (c, d, a, b, x[14], S13, 0xa679438e);
    MD5::FF (b, c, d, a, x[15], S14, 0x49b40821);

    // Round Two
    MD5::GG (a, b, c, d, x[ 1], S21, 0xf61e2562);
    MD5::GG (d, a, b, c, x[ 6], S22, 0xc040b340);
    MD5::GG (c, d, a, b, x[11], S23, 0x265e5a51);
    MD5::GG (b, c, d, a, x[ 0], S24, 0xe9b6c7aa);
    MD5::GG (a, b, c, d, x[ 5], S21, 0xd62f105d);
    MD5::GG (d, a, b, c, x[10], S22,  0x2441453);
    MD5::GG (c, d, a, b, x[15], S23, 0xd8a1e681);
    MD5::GG (b, c, d, a, x[ 4], S24, 0xe7d3fbc8);
    MD5::GG (a, b, c, d, x[ 9], S21, 0x21e1cde6);
    MD5::GG (d, a, b, c, x[14], S22, 0xc33707d6);
    MD5::GG (c, d, a, b, x[ 3], S23, 0xf4d50d87);
    MD5::GG (b, c, d, a, x[ 8], S24, 0x455a14ed);
    MD5::GG (a, b, c, d, x[13], S21, 0xa9e3e905);
    MD5::GG (d, a, b, c, x[ 2], S22, 0xfcefa3f8);
    MD5::GG (c, d, a, b, x[ 7], S23, 0x676f02d9);
    MD5::GG (b, c, d, a, x[12], S24, 0x8d2a4c8a);

    // Round Three
    MD5::HH (a, b, c, d, x[ 5], S31, 0xfffa3942);
    MD5::HH (d, a, b, c, x[ 8], S32, 0x8771f681);
    MD5::HH (c, d, a, b, x[11], S33, 0x6d9d6122);
    MD5::HH (b, c, d, a, x[14], S34, 0xfde5380c);
    MD5::HH (a, b, c, d, x[ 1], S31, 0xa4beea44);
    MD5::HH (d, a, b, c, x[ 4], S32, 0x4bdecfa9);
    MD5::HH (c, d, a, b, x[ 7], S33, 0xf6bb4b60);
    MD5::HH (b, c, d, a, x[10], S34, 0xbebfbc70);
    MD5::HH (a, b, c, d, x[13], S31, 0x289b7ec6);
    MD5::HH (d, a, b, c, x[ 0], S32, 0xeaa127fa);
    MD5::HH (c, d, a, b, x[ 3], S33, 0xd4ef3085);
    MD5::HH (b, c, d, a, x[ 6], S34,  0x4881d05);
    MD5::HH (a, b, c, d, x[ 9], S31, 0xd9d4d039);
    MD5::HH (d, a, b, c, x[12], S32, 0xe6db99e5);
    MD5::HH (c, d, a, b, x[15], S33, 0x1fa27cf8);
    MD5::HH (b, c, d, a, x[ 2], S34, 0xc4ac5665);

    // Round Four
    MD5::II (a, b, c, d, x[ 0], S41, 0xf4292244);
    MD5::II (d, a, b, c, x[ 7], S42, 0x432aff97);
    MD5::II (c, d, a, b, x[14], S43, 0xab9423a7);
    MD5::II (b, c, d, a, x[ 5], S44, 0xfc93a039);
    MD5::II (a, b, c, d, x[12], S41, 0x655b59c3);
    MD5::II (d, a, b, c, x[ 3], S42, 0x8f0ccc92);
    MD5::II (c, d, a, b, x[10], S43, 0xffeff47d);
    MD5::II (b, c, d, a, x[ 1], S44, 0x85845dd1);
    MD5::II (a, b, c, d, x[ 8], S41, 0x6fa87e4f);
    MD5::II (d, a, b, c, x[15], S42, 0xfe2ce6e0);
    MD5::II (c, d, a, b, x[ 6], S43, 0xa3014314);
    MD5::II (b, c, d, a, x[13], S44, 0x4e0811a1);
    MD5::II (a, b, c, d, x[ 4], S41, 0xf7537e82);
    MD5::II (d, a, b, c, x[11], S42, 0xbd3af235);
    MD5::II (c, d, a, b, x[ 2], S43, 0x2ad7d2bb);
    MD5::II (b, c, d, a, x[ 9], S44, 0xeb86d391);

    // Add back to the A.B.C.D
    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;

    // Zeroize sensitive information
    memset(x, 0, sizeof x);
}


void MD5::decode(uInt output[], const uChar input[], uInt length) {
    for (uInt i = 0, j = 0; j < length; i++, j += 4) {
        output[i] = (uInt)input[j] | ((uInt)input[j + 1] << 8) |
                    ((uInt)input[j + 2] << 16) | ((uInt)input[j + 3] << 24);
    }
}


// Encodes uInt into uChar. Assumes length is a multiple of 4
void MD5::encode(uChar output[], const uInt input[], uInt length) {
    for (uInt i = 0, j = 0; j < length; i++, j += 4) {
        output[j] = input[i] & 0xff;
        output[j + 1] = (input[i] >> 8) & 0xff;
        output[j + 2] = (input[i] >> 16) & 0xff;
        output[j + 3] = (input[i] >> 24) & 0xff;
    }
}




// md5 function use the parameter to construct a MD5 object
// and return the MD5 value
std::string md5(const std::string str) {
    MD5 obj(str);
    return obj.hexdigest();
}


std::ostream& operator << (std::ostream& out, MD5 md5) {
    return out << md5.hexdigest();
}

std::string MD5::hexdigest() {
    if (!finish) {
        return "";
    }
    char temp[33] = {0};
    for (int i = 0; i < 16; i++) {
        sprintf(temp + i * 2, "%02x", result[i]);
    }
    return std::string(temp);
}

// writing the message digest and zeroizing the context
MD5& MD5::finalize() {
    static uChar padding[64] = {
        0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    };
    if (!finish) {
        // Save number of bits
        uChar bits[8];
        MD5::encode(bits, count, 8);

        // Pad out to 56 mod 64
        uInt index = count[0] / 8 % 64;
        uInt padLength = (index < 56) ? (56 - index) : (120 - index);
        MD5::update(padding, padLength);

        // Append length (before padding)
        MD5::update(bits, 8);
        // Store state in result
        MD5::encode(result, state, 16);

        // Zeroize sensitive information
        memset(buffer, 0, sizeof(buffer));
        memset(count, 0, sizeof(count));
        finish = true;
    }
    return *this;
}

/*
int main() {
    std::cout << "MD5(\"hi\") = " << md5("hi") << std::endl;
    return 0;
}
*/



static void benchmark_MD5(benchmark::State& state) {
  std::string x = "The quick brown fox jumps over the lazy dog";
  for (auto _ : state)
    std::string a =  md5(x);
}
BENCHMARK(benchmark_MD5);

BENCHMARK_MAIN();
