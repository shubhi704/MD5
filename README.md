# MD5
Introduction





MD5 Implementation

We implemented the MD5, a one way cryptographic hash function, using Verilog (Hardware Description Language). This implementation is not fully veriified using advance verification techniques/methology so there can be the corner cases where this implementation may fails. We tested our implementation through existing code for few input strings. As this is the hardware implementation so we fixed the input pins as 448 bits long which we call as message, and MD5 will generate 128 bits output call as digest.
For understanding the MD5 algorithm I found that relatively complete description is given in Wiki.

The Algorithm






