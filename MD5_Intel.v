
///////////////// MD5 ///////////////


module MD5_Intel(
   input clock,
   input [447:0] MSG,
   output reg[95:0] md );

  reg [511:0] pm ;
  reg [31:0]A,B,C,D;
  reg [31:0]M[0:15];
  reg [31:0]K [0:63];
  reg [7:0]s [0:63];
  reg [31:0]F,E;
  reg [31:0]temp;
  integer g,i;
  
  /*initial begin
   fd = $fopen("func_val.txt");  
  end*/
/*
localparam [32*64-1:0]K = {32'hd76aa478, 32'he8c7b756, 32'h242070db, 32'hc1bdceee,
                            32'hf57c0faf, 32'h4787c62a, 32'ha8304613, 32'hfd469501,
                            32'h698098d8, 32'h8b44f7af, 32'hffff5bb1, 32'h895cd7be,
                            32'h6b901122, 32'hfd987193, 32'ha679438e, 32'h49b40821,
                            32'hf61e2562, 32'hc040b340, 32'h265e5a51, 32'he9b6c7aa,
                            32'hd62f105d, 32'h02441453, 32'hd8a1e681, 32'he7d3fbc8,
                            32'h21e1cde6, 32'hc33707d6, 32'hf4d50d87, 32'h455a14ed,
                            32'ha9e3e905, 32'hfcefa3f8, 32'h676f02d9, 32'h8d2a4c8a,
                            32'hfffa3942, 32'h8771f681, 32'h6d9d6122, 32'hfde5380c,
                            32'ha4beea44, 32'h4bdecfa9, 32'hf6bb4b60, 32'hbebfbc70,
                            32'h289b7ec6, 32'heaa127fa, 32'hd4ef3085, 32'h04881d05,
                            32'hd9d4d039, 32'he6db99e5, 32'h1fa27cf8, 32'hc4ac5665,
                            32'hf4292244, 32'h432aff97, 32'hab9423a7, 32'hfc93a039,
                            32'h655b59c3, 32'h8f0ccc92, 32'hffeff47d, 32'h85845dd1,
                            32'h6fa87e4f, 32'hfe2ce6e0, 32'ha3014314, 32'h4e0811a1,
                            32'hf7537e82, 32'hbd3af235, 32'h2ad7d2bb, 32'heb86d391} ;

localparam [5*64-1:0] S = {5'd7, 5'd12, 5'd17, 5'd22, 5'd7, 5'd12, 5'd17, 5'd22, 5'd7, 5'd12, 5'd17, 5'd22, 5'd7, 5'd12, 5'd17, 5'd22,
                         5'd5, 5'd 9, 5'd14, 5'd20, 5'd5, 5'd9,  5'd14, 5'd20, 5'd5, 5'd 9, 5'd14, 5'd20, 5'd5, 5'd9, 5'd14, 5'd20,
                         5'd4, 5'd11, 5'd16, 5'd23, 5'd4, 5'd11, 5'd16, 5'd23, 5'd4, 5'd11, 5'd16, 5'd23, 5'd4, 5'd11, 5'd16, 5'd23,
                         5'd6, 5'd10, 5'd15, 5'd21, 5'd6, 5'd10, 5'd15, 5'd21, 5'd6, 5'd10, 5'd15, 5'd21, 5'd6, 5'd10, 5'd15, 5'd21};
  
*/
  
   reg [31:0] a0 = 32'h67452301 ;
   reg [31:0] b0 = 32'hefcdab89 ;
   reg [31:0] c0 = 32'h98badcfe ;
   reg [31:0] d0 = 32'h10325476 ;



 always @(posedge clock)  begin
      
  s[0] = 8'd07;
  s[1] = 8'd12;
  s[2] = 8'd17;
  s[3] = 8'd22;
  s[4] = 8'd07;
  s[5] = 8'd12;
  s[6] = 8'd17;
  s[7] = 8'd22;
  s[8] = 8'd07;
  s[9] = 8'd12;
  s[10] = 8'd17;
  s[11] = 8'd22;
  s[12] = 8'd07;
  s[13] = 8'd12;
  s[14] = 8'd17;
  s[15] = 8'd22;
  s[16] = 8'd05;
  s[17] = 8'd09;
  s[18] = 8'd14;
  s[19] = 8'd20;
  s[20] = 8'd05;
  s[21] = 8'd09;
  s[22] = 8'd14;
  s[23] = 8'd20;
  s[24] = 8'd05;
  s[25] = 8'd09;
  s[26] = 8'd14;
  s[27] = 8'd20;
  s[28] = 8'd05;
  s[29] = 8'd09;
  s[30] = 8'd14;
  s[31] = 8'd20;
  s[32] = 8'd04;
  s[33] = 8'd11;
  s[34] = 8'd16;
  s[35] = 8'd23;
  s[36] = 8'd04;
  s[37] = 8'd11;
  s[38] = 8'd16;
  s[39] = 8'd23;
  s[40] = 8'd04;
  s[41] = 8'd11;
  s[42] = 8'd16;
  s[43] = 8'd23;
  s[44] = 8'd04;
  s[45] = 8'd11;
  s[46] = 8'd16;
  s[47] = 8'd23;
  s[48] = 8'd06;
  s[49] = 8'd10;
  s[50] = 8'd15;
  s[51] = 8'd21;
  s[52] = 8'd06;
  s[53] = 8'd10;
  s[54] = 8'd15;
  s[55] = 8'd21;
  s[56] = 8'd06;
  s[57] = 8'd10;
  s[58] = 8'd15;
  s[59] = 8'd21;
  s[60] = 8'd06;
  s[61] = 8'd10;
  s[62] = 8'd15;
  s[63] = 8'd21;
  
  
  
  K[0] = 32'hd76aa478;
  K[1] = 32'he8c7b756;
  K[2] = 32'h242070db;
  K[3] = 32'hc1bdceee;
  K[4] = 32'hf57c0faf;
  K[5] = 32'h4787c62a;
  K[6] = 32'ha8304613;
  K[7] = 32'hfd469501;
  K[8] = 32'h698098d8;
  K[9] = 32'h8b44f7af;
  K[10] = 32'hffff5bb1;
  K[11] = 32'h895cd7be;
  K[12] = 32'h6b901122;
  K[13] = 32'hfd987193;
  K[14] = 32'ha679438e;
  K[15] = 32'h49b40821;
  K[16] = 32'hf61e2562;
  K[17] = 32'hc040b340;
  K[18] = 32'h265e5a51;
  K[19] = 32'he9b6c7aa;
  K[20] = 32'hd62f105d;
  K[21] = 32'h02441453;
  K[22] = 32'hd8a1e681;
  K[23] = 32'he7d3fbc8;
  K[24] = 32'h21e1cde6;
  K[25] = 32'hc33707d6;
  K[26] = 32'hf4d50d87;
  K[27] = 32'h455a14ed;
  K[28] = 32'ha9e3e905;
  K[29] = 32'hfcefa3f8;
  K[30] = 32'h676f02d9;
  K[31] = 32'h8d2a4c8a;
  K[32] = 32'hfffa3942;
  K[33] = 32'h8771f681;
  K[34] = 32'h6d9d6122;
  K[35] = 32'hfde5380c;
  K[36] = 32'ha4beea44;
  K[37] = 32'h4bdecfa9;
  K[38] = 32'hf6bb4b60;
  K[39] = 32'hbebfbc70;
  K[40] = 32'h289b7ec6;
  K[41] = 32'heaa127fa;
  K[42] = 32'hd4ef3085;
  K[43] = 32'h04881d05;
  K[44] = 32'hd9d4d039;
  K[45] = 32'he6db99e5;
  K[46] = 32'h1fa27cf8;
  K[47] = 32'hc4ac5665;
  K[48] = 32'hf4292244;
  K[49] = 32'h432aff97;
  K[50] = 32'hab9423a7;
  K[51] = 32'hfc93a039;
  K[52] = 32'h655b59c3;
  K[53] = 32'h8f0ccc92;
  K[54] = 32'hffeff47d;
  K[55] = 32'h85845dd1;
  K[56] = 32'h6fa87e4f;
  K[57] = 32'hfe2ce6e0;
  K[58] = 32'ha3014314;
  K[59] = 32'h4e0811a1;
  K[60] = 32'hf7537e82;
  K[61] = 32'hbd3af235;
  K[62] = 32'h2ad7d2bb;
  K[63] = 32'heb86d391;
  
    pm = {MSG,8'h68,24'b0,32'b0};   //Append Length


   // Initialize Registers

    A = a0;
    B = b0;    
    C = c0;
    D = d0;

     //Chunk padded Msg signal into 16 32-bit words

      M[15] = {pm[7:0],pm[15:8],pm[23:16],pm[31:24]} ;
      M[14] = {pm[39:32],pm[47:40],pm[55:48],pm[63:56]} ;
      M[13] = {pm[71:64],pm[79:72],pm[87:80],pm[95:88]} ;
      M[12] = {pm[103:96],pm[111:104],pm[119:112],pm[127:120]} ;
      M[11] = {pm[135:128],pm[143:136],pm[151:144],pm[159:152]} ;
      M[10] = {pm[167:160],pm[175:168],pm[183:176],pm[191:184]} ;
      M[9] = {pm[199:192],pm[207:200],pm[215:208],pm[223:216]} ;
      M[8] = {pm[231:224],pm[239:232],pm[247:240],pm[255:248]} ;
      M[7] = {pm[263:256],pm[271:264],pm[279:272],pm[287:280]} ;
      M[6] = {pm[295:288],pm[303:296],pm[311:304],pm[319:312]} ;
      M[5] = {pm[327:320],pm[335:328],pm[343:336],pm[351:344]} ;
      M[4] = {pm[359:352],pm[367:360],pm[375:368],pm[383:376]} ;
      M[3] = {pm[391:384],pm[399:392],pm[407:400],pm[415:408]} ;
      M[2] = {pm[423:416],pm[431:424],pm[439:432],pm[447:440]} ;
      M[1] = {pm[455:448],pm[463:456],pm[471:464],pm[479:472]} ;
      M[0] = {pm[487:480],pm[495:488],pm[503:496],pm[511:504]} ;


    // MD operations

     for(i=0; i<64; i=i+1) begin
      
         if(i>=0 && i<16) begin
            E = ((B & C) | ((~ B) & D));
            g = i;
          
            end

        if(i>=16 && i<32) begin
            E = ((D & B) | ((~ D) & C));
          g = ((5*i + 1) % 16);
        
            end

       if(i>=32 && i<48) begin
            E = B ^ C ^ D ;
          g = (3*i + 5) % 16;
	   
            end

        if(i>=48 && i<64) begin
            E = (C ^ (B | (~ D))) ;
          g = (7*i) % 16;
	   

            end
        
         /*
            $fwrite(fd,"--------------------------------------------------------------------\n");
            $fwrite(fd,"i: %0d\n AA: %h \n BB: %h\n CC: %h\n DD: %h \n F: %h\n S[%0d]: %d\n K[%0d]: %h\n M[%0d]: %h \n",i,A,B,C,D,E,i,s[i],i,K[i],g,M[g]);
    	    $fwrite(fd,"--------------------------------------------------------------------\n");
             #1; */

            temp = D;
       D = C;
       C = B;
       F = E + A + K[i] + M[g] ;
       B = B + ((F << s[i]) | F >> (32 - s[i])) ;
       A= temp;
      

      end
      
       a0 = A + a0;
       b0 = B + b0;
       c0 = C + c0;
       d0 = D + d0;
      
   
      md = {a0[7:0],a0[15:8],a0[23:16],a0[31:24],b0[7:0],b0[15:8],b0[23:16],b0[31:24],c0[7:0],c0[15:8],c0[23:16],c0[31:24]} ;
      $display(" Input String  : %s \n Message Digest: %h",MSG,md);
    
  end

  endmodule

