module testbench1 (
);
    reg clk1 , clk2; 
    integer k;

    myProcessor tojo (clk1,clk2);

    initial begin
       clk1=0; clk2=0;
       repeat(50) begin
            #5 clk1 = 1; #5 clk1 = 0 ;
            #5 clk2 = 1; #5 clk2 = 0 ;
       end
    end

    initial begin
    
        for (k=0; k<31; k=k+1) 
            tojo.Reg[k] = k;

        tojo.mem[0] = 32'h28010078;   // ADDI   R1, R0, 120
        tojo.mem[1] = 32'h0c631800;   // OR     R3, R3, R3  -- dummy instr.
        tojo.mem[2] = 32'h20220000;   // LW     R2, 0(R1)
        tojo.mem[3] = 32'h0c631800;   // OR     R3, R3, R3  -- dummy instr.
        tojo.mem[4] = 32'h2842002d;   // ADDI   R2, R2, 45
        tojo.mem[5] = 32'h0c631800;   // OR     R3, R3, R3  -- dummy instr.
        tojo.mem[6] = 32'h24220001;   // SW     R2, 1(R1)
        tojo.mem[7] = 32'hfc000000;   // HLT

        tojo.mem[120] = 85;
        
        tojo.PC = 0;
        tojo.HALTED = 0;
        tojo.BRANCHED = 0;

        #500 $display ("mem[120]: %4d \nmem[121]: %4d", 
                    tojo.mem[120], tojo.mem[121]);

        #300 $finish;
    end    
    
endmodule