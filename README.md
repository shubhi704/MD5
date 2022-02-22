# MD5
**Introduction**





**The Algorithm**

We implemented the MD5, a one-way cryptographic hash function, using Verilog (Hardware Description Language). We tested our implementation through existing code for a few input strings. But this implementation is not fully verified using advanced verification techniques/methodology so there can be some corner cases for which this implementation may fail. As this is the hardware implementation so we fixed the input pins as 448 bits long which we call a message, and MD5 will generate 128 bits output which we call digest. For understanding the MD5 algorithm I found that a relatively complete description is given in Wiki.
For understanding the MD5 algorithm I found that a relatively complete description is given in Wiki.


**Step 1: Padding** 

According to the standard MD5 algorithm, we insert the arbitrary length input and padded the message signal by appending bits at the end until its length is congruent to 448 mod 512. But in this implementation, we have to provide the padded message on the input side. The padding is simply a single "1" bit at the end of the message followed by enough "0" bits to satisfy the length condition above (n*512 - 64, where n is a whole number).

**For Example:** 

Message String - "Message Padding"

Message (in Hex) - 4d 65 73 73 61 67 65 20 50 61 64 64 69 6e 67

Padded Message (in Hex) -  
                    
                           4d 65 73 73 61 67 65 20 50 61 64 64 69 6e 67

                           80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
                           
                           00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
                           
                           00 00 00 00 00 00 00 00 00 00 00



Please note - 
           
             1. If in case your message width is 448 bits then you simply add the "1" bit at the end of the message signal to convert it into the padded message.

             2. Double Quotation is not a part of the message signal. And it is not taking the null character into account.



**Step 2: Appending the Length**

In this step, we append the message length using 64 bits at the end of the padded message. As your msg length is 30 bits, you need to append "1E" by representing it using 64 bits.
But one point to be noted here is, we represented the appended length using the little-endian form.
   

00 00 00 00 00 00 00 1E -->   1E 00 00 00 00 00 00 00

Now your message signal becomes - 
    
    4d 65 73 73 61 67 65 20 50 61 64 64 69 6e 67
    80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        
    00 00 00 00 00 00 00 00 00 00 00 1E 00 00 00
    00 00 00 00




**Step 3: Initializing 4 Registers**

In this step, we initialize four 32-bit registers whose initial values are:

    A = 32'h67452301 
    B = 32'hefcdab89 
    C = 32'h98badcfe 
    D = 32'h10325476

In this step, we also need to chunk padded Msg signal into 16 32-bit words and each 32-bit word must be converted into little-endian form.

    For Example: 
      
      Zeroth padded Message signal is M[0] = {pm[487:480],pm[495:488],pm[503:496],pm[511:504]}
      or, M[0] = 73 73 65 4d instead of 4d 65 73 73.
      Here, pm = padded message signal
       

Step 4: Iteration

In MD5, there is 4 function and with each function 16 times the iterations are taken place.

    for i from 0 to 63 do
        if 0 ≤ i ≤ 15 then
            F = (B and C) or ((not B) and D)
            g = i
        else if 16 ≤ i ≤ 31 then
            F = (D and B) or ((not D) and C)
            g = (5×i + 1) mod 16
        else if 32 ≤ i ≤ 47 then
            F = B xor C xor D
            g = (3×i + 5) mod 16
        else if 48 ≤ i ≤ 63 then
            F = C xor (B or (not D))
            g = (7×i) mod 16
        F := F + A + K[i] + M[g]  // M[g] must be a 32-bits block
        A := D
        D := C
        C := B
        B := B + leftrotate(F, s[i])
    end for
    // Add this chunk's hash to result so far:
    a0 := a0 + A
    b0 := b0 + B
    c0 := c0 + C
    d0 := d0 + D
end for

var char digest[16] := a0 append b0 append c0 append d0

    // s specifies the per-round shift amounts

    s[ 0..15] := { 7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22 }
    s [16..31] := { 5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20 }
    s[32..47] := { 4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23 }
    s[48..63] := { 6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21 }

    K[ 0.. 3] := { 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee }
    K[ 4.. 7] := { 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501 }
    K[ 8..11] := { 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be }
    K[12..15] := { 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821 }
    K[16..19] := { 0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa }
    K[20..23] := { 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8 }
    K[24..27] := { 0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed }
    K[28..31] := { 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a }
    K[32..35] := { 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c }
    K[36..39] := { 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70 }
    K[40..43] := { 0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05 }
    K[44..47] := { 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665 }
    K[48..51] := { 0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039 }
    K[52..55] := { 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1 }
    K[56..59] := { 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1 }
    K[60..63] := { 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391 }



# Synthesis using Intel Quartus Prime.


Download Link - https://cdrdv2.intel.com/v1/dl/downloadStart/684220/684241?filename=Quartus-lite-21.1.0.842-windows.tar

![image](https://user-images.githubusercontent.com/82434808/155185325-6e6e378b-ffa7-450d-9f03-86dc428f5f76.png)

![image](https://user-images.githubusercontent.com/82434808/155185627-59047428-5e45-4ad3-a189-edfb3b3a29a3.png)

![image](https://user-images.githubusercontent.com/82434808/155185888-84a1e91d-50a5-43ea-9906-6c4b073caace.png)

![image](https://user-images.githubusercontent.com/82434808/155185955-bb5f1ff3-1b1d-479d-a35d-772af3702d27.png)

![image](https://user-images.githubusercontent.com/82434808/155186083-5af3a619-b177-4f7c-b099-0082b521af5a.png)

![image](https://user-images.githubusercontent.com/82434808/155186180-2694616d-56e9-42cd-b29b-660fb6488414.png)

![image](https://user-images.githubusercontent.com/82434808/155186366-3fc2f182-ca7e-48b1-baea-c746b61d3f75.png)

![image](https://user-images.githubusercontent.com/82434808/155186522-50998d86-4480-4b42-b361-cecb77074aca.png)

![image](https://user-images.githubusercontent.com/82434808/155186633-9c78b942-e52a-46c9-9c84-e40aac2ece5e.png)


# .SDC file
    
 .sdc stands for Synopsys Design Constraints which is used to define the design constraints. Below I have listed important commands of the SDC file.

    ******************************************************
    Time Information   
    ******************************************************
    set_time_format -unit ns -decimal_places 3

 This is indicating that all the values are represented in nano-second and the digits are valid up to 3 decimal places.
 
    **************************************************************
    Create Clock
    **************************************************************
    create_clock -period 600.000 -waveform { 0.000 300.000 } -name {clock} [get_ports {clock}] 

Using the create_clock command we make the clock period 600ns which will trigger at 0ns and 300ns (or 50% duty cycle). 

    **************************************************************
    Set Input Delay
    **************************************************************
    set_input_delay 2.00 -clock [get_clocks {clock}] [get_ports {MSG}]

    **************************************************************
    Set Output Delay
    **************************************************************
    set_output_delay 1.00 -clock [get_clocks {clock}] [get_ports {md}]
    
 Using set_inputdelay/set_output_delay we assigned the input/output delay (interconnect delay).

# Power Result

![image](https://user-images.githubusercontent.com/82434808/155191254-08931c1b-534a-4a59-b901-bb4a45f80aef.png)
![image](https://user-images.githubusercontent.com/82434808/155191389-687a0d8d-a428-45f8-8388-0a72d4c66a6f.png)
![image](https://user-images.githubusercontent.com/82434808/155191498-ef351dc5-4802-4575-bf62-7962fe378137.png)
![image](https://user-images.githubusercontent.com/82434808/155191601-960548c1-d97c-47b6-9dc7-5b5d0e10c218.png)
![image](https://user-images.githubusercontent.com/82434808/155191709-9337e193-b78d-49bd-aa49-fa022ed40e50.png)



# Timing Report


