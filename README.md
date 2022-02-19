# MD5
**Introduction**





** The Algorithm**

We implemented the MD5, a one way cryptographic hash function, using Verilog (Hardware Description Language). We tested our implementation through existing code for few input strings. But this implementation is not fully veriified using advance verification techniques/methology so there can be the some corner cases for which this implementation may fails. As this is the hardware implementation so we fixed the input pins as 448 bits long which we call as message, and MD5 will generate 128 bits output which we call as digest.
For understanding the MD5 algorithm I found that relatively complete description is given in Wiki.

**Step 1: Padding** 

According to the standard MD5 algorithm we insert the arbitary length input and padded the message signal by appending bits at the end until its length is congruent to 448 mod 512. But in this implementation we have to provide the padded message in the input side. The padding is simply a single "1" bit at the end of the message followed by enough "0" bits to satisfy the length condition above (n*512 - 64, where n is a whole number).

**For Example:** 

Message String - "Message Padding"

Message (in Hex) - 4d 65 73 73 61 67 65 20 50 61 64 64 69 6e 67

Padded Message (in Hex) -  4d 65 73 73 61 67 65 20 50 61 64 64 69 6e 67

                           80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
                           
                           00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
                           
                           00 00 00 00 00 00 00 00 00 00 00



Please note - 1. If in case your message width is 448 bits then you simply addd "1" bit at the end of the message signal to convert it into padded message.

              2. Double Quotation is not a part of message signal. And it is not taking null character.


**Step 2: Appending the Length**

In this step, we append the lenght of the message at the end of the padded msg by represented it using 64 bits.




