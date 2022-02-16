# MD5
Introduction





#The Algorithm

We implemented the MD5, a one way cryptographic hash function, using Verilog (Hardware Description Language). We tested our implementation through existing code for few input strings. But this implementation is not fully veriified using advance verification techniques/methology so there can be the some corner cases for where this implementation may fails. As this is the hardware implementation so we fixed the input pins as 448 bits long which we call as message, and MD5 will generate 128 bits output which we call as digest.
For understanding the MD5 algorithm I found that relatively complete description is given in Wiki.

Step 1: Padding 

According to the standard MD5 algorithm we insert the arbitary lenght input and padded the message signal by appending bits at the end until its lenght is congruent to 448 mod 512. But in this implementation we have to provide the padded message in the imput side. The padding is simply a single "1" bit at the end of the message followed by enough "0" bits to satisfy the length condition above (n*512 - 64, where n is a whole number).

For Example: 

Message String - "Testing MD5"

Note - Double Quotation is not a part of message signal. And it is not taking null character.

Message String (in Hex) - 54_65_73_74_69_6e_67_20_4d_44_35








