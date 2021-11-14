`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli 
// 
// Create Date: 19.07.2020 16:33:33
// Design Name: 
// Module Name: Clock_10KHz
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Clock_10KHz(output reg clock_10KHz,
                   input Clock_100MHz, Reset_n);
    
  // Generate 10KHz clock
    // 100us = 10KHz
    // 100us clock = 50us ON + 50us OFF
    // 10ns = 1; 50us = x; x = 5000;
    // 4999 = 1_0011_1000_1000b       
     reg [12:0] count_5000;     
       
   always@(posedge Clock_100MHz, negedge Reset_n)
     if(!Reset_n)   
       begin             
         clock_10KHz <= 0;
         count_5000 <= 0; 
       end
     else if(count_5000 == 4999)        
       begin             
         clock_10KHz <= ~clock_10KHz;
         count_5000 <= 0; 
        end 
      else         
        begin             
          clock_10KHz <= clock_10KHz;
          count_5000 <= count_5000 + 1; 
        end  
                  
endmodule
