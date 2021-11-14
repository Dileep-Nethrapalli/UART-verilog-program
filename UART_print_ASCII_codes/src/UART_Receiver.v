`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 10.07.2020 10:04:28
// Design Name: 
// Module Name: Keyboard
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


module UART_Receiver(output reg [7:0] UART_Data,  
                     input TXD, clock_10KHz, Reset_n);                
                
            
 // FSM for UART Receiver    
   reg [3:0] present_state, next_state;  
 
   parameter [7:0] 
      RESET = 8'h00,   START = 8'h01,   
      DATA_0 =  8'h02, DATA_1 =  8'h03,
      DATA_2 =  8'h04, DATA_3 =  8'h05,
      DATA_4 =  8'h06, DATA_5 =  8'h07,
      DATA_6 =  8'h08, DATA_7 =  8'h09,
      STOP = 8'h0A;
                                    
                   
  // FSM registers
     always@(posedge clock_10KHz, negedge Reset_n)
       if(!Reset_n) 
          present_state <= RESET;
       else
          present_state <= next_state;
          
          
  // FSM Combinational block
     always@(present_state, TXD)
       case(present_state)
         RESET: next_state = START; 
         
         START: if(!TXD) 
                   next_state = DATA_0;                   
                else
                   next_state = present_state; 
                           
         DATA_0: next_state = DATA_1;          
         DATA_1: next_state = DATA_2;         
         DATA_2: next_state = DATA_3;         
         DATA_3: next_state = DATA_4;         
         DATA_4: next_state = DATA_5;         
         DATA_5: next_state = DATA_6;          
         DATA_6: next_state = DATA_7;         
         DATA_7: next_state = STOP; 
         
         STOP: next_state = START; 
         
         default: next_state = RESET; 
       endcase 
       
 
   //Capture Received UART data
     reg [7:0] data;
     always@(posedge clock_10KHz, negedge Reset_n)
       if(!Reset_n)
          data <= 8'h00;
       else 
         case(present_state)
           DATA_0: data[0] <= TXD; 
           DATA_1: data[1] <= TXD;     
           DATA_2: data[2] <= TXD; 
           DATA_3: data[3] <= TXD;  
           DATA_4: data[4] <= TXD; 
           DATA_5: data[5] <= TXD;  
           DATA_6: data[6] <= TXD; 
           DATA_7: data[7] <= TXD;
         endcase  
          
          
 // Assign output only in STOP state      
    always@(negedge clock_10KHz, negedge Reset_n)
      if(!Reset_n)
         UART_Data <= 8'h00;
      else if(present_state == STOP) 
         UART_Data <= data;                                  

endmodule
