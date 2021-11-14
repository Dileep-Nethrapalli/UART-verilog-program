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


module UART_Transmitter(
         output reg RXD,  
         input TX_Enable, clock_10KHz, Reset_n);                
  
    reg [7:0] TX_data;    
    
             
 // FSM for UART Transmitter    
   reg [3:0] present_state, next_state; 
  
   parameter [7:0] 
     RESET = 8'd0,   START = 8'd1,   
     DATA_0 =  8'd2, DATA_1 =  8'd3,                 
     DATA_2 =  8'd4, DATA_3 =  8'd5, 
     DATA_4 =  8'd6, DATA_5 =  8'd7,
     DATA_6 =  8'd8, DATA_7 =  8'd9,
     STOP = 8'd10,   FINISH = 8'd11;
                                    
                   
  // FSM registers
     always@(posedge clock_10KHz, negedge Reset_n)
       if(!Reset_n) 
          present_state <= RESET;
       else
          present_state <= next_state;
          
          
  // FSM Combinational block
     always@(present_state, TX_data, TX_Enable)
       case(present_state)
         RESET: begin RXD = 1; next_state = START; end 
         
         START: if(TX_Enable) 
                  begin
                    RXD = 0;
                    next_state = DATA_0;
                  end                    
                else
                  begin
                    RXD = 1;
                    next_state = present_state; 
                  end   
                           
         DATA_0: begin 
                   RXD = TX_data[0]; next_state = DATA_1; 
                 end         
         DATA_1: begin 
                   RXD = TX_data[1]; next_state = DATA_2; 
                 end         
         DATA_2: begin 
                   RXD = TX_data[2]; next_state = DATA_3; 
                 end         
         DATA_3: begin 
                   RXD = TX_data[3]; next_state = DATA_4; 
                 end         
         DATA_4: begin 
                   RXD = TX_data[4]; next_state = DATA_5; 
                 end          
         DATA_5: begin 
                   RXD = TX_data[5]; next_state = DATA_6; 
                 end          
         DATA_6: begin 
                   RXD = TX_data[6]; next_state = DATA_7; 
                 end 
         DATA_7: begin 
                   RXD = TX_data[7]; next_state = STOP; 
                 end                
         
         STOP:   begin 
                   RXD = 1; 
                   if(TX_data == 127)
                      next_state = FINISH;
                   else
                      next_state = START; 
                 end
                 
         FINISH: begin 
                   RXD = 1; next_state = present_state; 
                 end        
         
         default: begin RXD = 1; next_state = RESET; end
       endcase 
       
 
  // Genenrate Transmission Data  
      always@(negedge clock_10KHz, negedge Reset_n)
          // Starting ASCII code for Printable character is 32
        if(!Reset_n) 
           TX_data <= 32; 
           // Ending ASCII code for Printable character is 126   
        else if(TX_data == 127)              
           TX_data <= TX_data;
        else if(present_state == STOP)
           TX_data <= TX_data + 1;
 
endmodule
