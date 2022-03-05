# MD5
**Introduction**





**The Algorithm**

We implemented the MD5, a one-way cryptographic hash function, using Verilog (Hardware Description Language). We tested our implementation through existing code for a few input strings. But this implementation is not fully verified using advanced verification techniques/methodology so there can be some corner cases for which this implementation may fail. As this is the hardware implementation so we fixed the input pins as 448 bits long which we call a message, and MD5 will generate 128 bits output which we call digest. For understanding the MD5 algorithm I found that a relatively complete description is given in Wiki.
    
    Wiki Link - https://en.wikipedia.org/wiki/MD5


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

    digest = a0 append b0 append c0 append d0

    // s specifies the per-round shift amounts

    s[ 0..15] := { 7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22 }
    s [16..31] := { 5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20 }
    s[32..47] := { 4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23 }
    s[48..63] := { 6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21 }

   // K specifies the constant values
      
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

**Step 1:** To synthesis your design you first need to have Intel Quartus Prime software in your system. Please click the below download link for it.

Download Link - https://cdrdv2.intel.com/v1/dl/downloadStart/684220/684241?filename=Quartus-lite-21.1.0.842-windows.tar

**Step 2:** After installing Quartus prime, open the tool by double clicking the "Quartus Prime" icon. You should now see the image below. Select FILE --> New Project Wizard

 This will brings up the new project wizard which has 5 panes.
<img src ="https://user-images.githubusercontent.com/82434808/155185325-6e6e378b-ffa7-450d-9f03-86dc428f5f76.png" width="600" height="450">

**Step 2.2:** Fill in new project information.

<img src ="https://user-images.githubusercontent.com/82434808/155185627-59047428-5e45-4ad3-a189-edfb3b3a29a3.png" width="600" height="450">

**Step 2.3:** Click NEXT. We'll add source file later.

<img src ="https://user-images.githubusercontent.com/82434808/155185955-bb5f1ff3-1b1d-479d-a35d-772af3702d27.png" width="600" height="450">

**Step 2.4:** Device Settings. For this implementation we used 

          Device Family: Cyclone
          Device Name: 5CGXFC9E6F35I7.
          
<img src ="https://user-images.githubusercontent.com/82434808/155186083-5af3a619-b177-4f7c-b099-0082b521af5a.png" width="600" height="450">

 You could also just start typing the full part number in the Name filter box until you find it.
 Click NEXT. EDA tool setting doesn't matter for this lab so we can skip it.

**Step 2.5:** Summary
          Nothing to select - it should look like this. 
          
<img src ="https://user-images.githubusercontent.com/82434808/155186180-2694616d-56e9-42cd-b29b-660fb6488414.png" width="600" height="450">

Click FINISH
 
 **Step 3:** Select FILE --> Open. Browse your source file (.v) and CLick Open.
<img src ="https://user-images.githubusercontent.com/82434808/155186366-3fc2f182-ca7e-48b1-baea-c746b61d3f75.png" width="600" height="450">

**Step 4:** Write/Add .SDC file in your project folder. You can download .SDC file from the directory.

**Step 5:** Window should look like this. Now click on start arrow at the bottom left corner **|> Compile** for full compilation. 
<img src ="https://user-images.githubusercontent.com/82434808/155186633-9c78b942-e52a-46c9-9c84-e40aac2ece5e.png" width="700" height="400">

When the full compilation is done, you can now do power and timing analysis of your design.

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


# Power Analysis


When your design is compiled successfully then you can proceed towards its power analysis. There are the following steps that need to be followed to do power analysis in Quartus Prime software. I did vector-based power analysis in which we provide vectors in the form of an activity file (.VCD file). These are the following steps -

**Step 1:** Select PROCESSING --> Power Analyzer Tool. As you can see in the below image.

![image](https://user-images.githubusercontent.com/82434808/155191254-08931c1b-534a-4a59-b901-bb4a45f80aef.png)

**Step 2: ** In this step, you need to add an activity file. CLICK "Add Power Input File"


![image](https://user-images.githubusercontent.com/82434808/155191389-687a0d8d-a428-45f8-8388-0a72d4c66a6f.png)

Step 2.2: CLICK "ADD". Browse your activity file and click on the "OK" option. Your file will be shown as you can see in the below picture.


![image](https://user-images.githubusercontent.com/82434808/155191498-ef351dc5-4802-4575-bf62-7962fe378137.png)

Step 3: At the bottom of the Power Analyzer Tool, CLICK on the START option. The tool will start calculating the power of your design based on the vectors provided by you. You'll notice more will be the vector more you'll get power (or switching power).


![image](https://user-images.githubusercontent.com/82434808/155191601-960548c1-d97c-47b6-9dc7-5b5d0e10c218.png)


# Timing Analysis


When your design is compiled successfully then you can proceed towards its timing analysis. There are the following steps that need to be followed to do timing analysis in Quartus Prime software.


![image](https://user-images.githubusercontent.com/82434808/155191709-9337e193-b78d-49bd-aa49-fa022ed40e50.png)

![image](https://user-images.githubusercontent.com/82434808/156552495-870b3e55-4069-4d70-96d7-478b778b3acf.png)


![image](https://user-images.githubusercontent.com/82434808/156552855-5f7c947f-2b36-49ee-89ad-f6ddc1205fe6.png)


![image](https://user-images.githubusercontent.com/82434808/156552611-d1f8fa03-966f-4736-bea0-3a673f2d6820.png)

![image](https://user-images.githubusercontent.com/82434808/155842829-64ea278c-e788-435c-a257-20ed56042e0b.png)


# Results

**1. Verilog Code Simulation**
     Below are the snippet of simulation result for various strings -

   <img src ="https://user-images.githubusercontent.com/82434808/155838631-3e157429-6380-40d5-9673-4df236564618.png" width="500" height="75">


   <img src ="https://user-images.githubusercontent.com/82434808/155838639-5cfdcecb-7468-4ae3-b266-f96eef1405f3.png" width="500" height="40">


   <img src ="https://user-images.githubusercontent.com/82434808/155838644-3621f228-dd21-49f7-90e9-827c0dbad6b2.png" width="500" height="40">


**2. Power Result on FPGA**

   In the Summary report generated by the power analyzer, you will find that the Total Power dissipation by the circuit is nearly 600mW. The circuit has large static power as compared to dynamic power. As I already mentioned this is a vector-based power result, you can also do vector less power analysis using Power Analyzer where you need to give toggle rate/activity rate. we can also reduce this much power dissipation to some extent by adopting low power techniques.
     
   <img src ="https://user-images.githubusercontent.com/82434808/155595089-2c76285a-e8b1-42b2-be1c-e71c220222ea.png" width="700" height="350">
   
  We can also view power based on instances, block type, etc. Below is the Block type power distribution report of combinational cell, register cell, Clock enable block, and I/O power. You’ll notice that 95% power is the I/O power which we can ignore.
   
   <img src ="https://user-images.githubusercontent.com/82434808/155595109-41abeb0c-7346-4863-8fba-1c2842877deb.png" width="1000" height="300">


**3. Worst Delay on FPGA**

  In the summary report generated by the Timing Analyzer, you’ll find that there is no setup and hold violation inside the design. I assigned 600ns as the min. the time period of the clock signal.
   
   <img src ="https://user-images.githubusercontent.com/82434808/155595186-c678c36a-25b2-4d5b-a569-61e224efc3a2.png" width="600" height="600">


  From the timing report, the worst-case delay is nearly 600ns which is fairly good. We can do some optimization by replacing a high delay cell with a small delay cell of the FPGA board. 
  
  
   <img src ="https://user-images.githubusercontent.com/82434808/155595513-4f38d7ec-7bf5-4b4e-83b0-3fb648406f75.png" width="650" height="350">


# Analysis using C++ Code

 For the c++ code we used the implementation by Jackie Tseng and performed the timing and power analysis on that code

Link to Jackie Tseng's MD5 implementation- https://github.com/JackieTseng/md5
 
# Timing Analysis
  
  To conduct the timing analysis on the CPU, Google Benchmark is used. A wrapper function was created and the code was timed for input of a single string. 
   Inorder to use Google Benchmark certain installations and testings need to be done on the computer after which the computer recognizes the benchmark library.
     
     Link for installation steps and implementation of Google Benchmark- https://github.com/google/benchmark
 
# Power Analysis
  
  For power analysis of the c++ implementation Intel(R) Power Gadget 3.6 is used. This tool is a software-based power usage monitoring tool enabled for Intel® Core™ processors (from 2nd Generation up to 10th Generation Intel® Core™ processors). 
  
  The power analysis was done for single string input run in a loop for 100 times. 
  
  **Step 1:** Install Intel(R) Power Gadget 3.6 on the system 
  
  Link for Intel(R) Power Gadget 3.6 installation- https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html
  
  **Step 2:** Power can be calculated by 2 methods- 1. Using command prompt
                                                    2. Using log 
  
  We used the command prompt method to calculate the power 
 
  Step 2.1- Open the path to the source file destination of Intel(R) Power Gadget 3.6 on your computer 
  
  In our case the path was as follows- C:\Program Files\Intel\Power Gadget 3.6
  
  Type 'cmd' on the location bar and press enter to open the command prompt relevant to this path as shown below
  
  ![cmd window](https://user-images.githubusercontent.com/59177041/156890310-cecac3b9-84b6-4ad5-bda0-f06508222ac7.JPG)

  
  ![image](https://user-images.githubusercontent.com/59177041/156890241-9fc99548-2001-4e07-8cf7-10c76370d2ff.png)

  
  
