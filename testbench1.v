module testbench1 (
);
    reg clk1 , clk2; 
    integer k;

    myProcessor tojo (clk1,clk2);

    initial begin
       clk1=0; clk2=0;
       repeat(40) begin
            #5 clk1 = 1; #5 clk1 = 0 ;
            #5 clk2 = 1; #5 clk2 = 0 ;
       end
    end

    initial begin

        for (k=0; k<31; k=k+1) 
            tojo.Reg[k] = k;

        tojo.mem[0] = 32'h2801000a;   // ADDI R1, R0, 10
        tojo.mem[1] = 32'h28020014;   // ADDI R2, R0, 20
        tojo.mem[2] = 32'h28030019;   // ADDI R3, R0, 25
        tojo.mem[3] = 32'h0ce77800;   // OR   R7, R7, R7  -- dummy instruction
        tojo.mem[4] = 32'h0ce77800;   // OR   R7, R7, R7  -- dummy instruction
        tojo.mem[5] = 32'h00222000;   // ADD R4, R1, R2
        tojo.mem[6] = 32'h0ce77800;   // OR   R7, R7, R7  -- dummy instruction
        tojo.mem[7] = 32'h00832800;   // ADD R5, R4, R3
        tojo.mem[8] = 32'hfc000000;   // HLT 

        tojo.HALTED = 0;
        tojo.BRANCHED = 0;
        tojo.PC = 0;

        #280 
        for (k=0; k<6; k=k+1)
            $display("R%1d - %2d",k, tojo.Reg[k]);

        #300 $finish;
    end    
    
endmodule