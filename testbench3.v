module testbench3 (
);
    reg clk1 , clk2; 
    integer k;

    myProcessor tojo (clk1,clk2);

    initial begin
       clk1=0; clk2=0;
       repeat(80) begin
            #5 clk1 = 1; #5 clk1 = 0 ;
            #5 clk2 = 1; #5 clk2 = 0 ;
       end
    end

    initial begin
    
        for (k=0; k<31; k=k+1) 
            tojo.Reg[k] = k;

        tojo.mem[200] = 7;

        tojo.mem[0]  = 32'h280a00c8;  // ADDI R10, R0, 200
        tojo.mem[1]  = 32'h28020001;  // ADDI R2, R0, 1
        tojo.mem[2]  = 32'h0e94a000;  // OR   R20, R20, R20  — dummy instr.
        tojo.mem[3]  = 32'h21430000;  // LW   R3, 0(R10)
        tojo.mem[4]  = 32'h0e94a000;  // OR   R20, R20, R20  — dummy instr.
        tojo.mem[5]  = 32'h14431000;  // MUL  R2, R2, R3     — label: Loop
        tojo.mem[6]  = 32'h2c630001;  // SUBI R3, R3, 1
        tojo.mem[7]  = 32'h0e94a000;  // OR   R20, R20, R20  — dummy instr.
        tojo.mem[8]  = 32'h3460fffc;  // BNEQZ R3, Loop (i.e., -4 offset)
        tojo.mem[9]  = 32'h2542fffe;  // SW   R2, -2(R10)
        tojo.mem[10] = 32'hfc000000;  // HLT
        
        tojo.PC = 0;
        tojo.HALTED = 0;
        tojo.BRANCHED = 0;

        $monitor("R2: %4d", tojo.Reg[2]);
        
        #2000 $display ("mem[200]: %2d \nmem[198]: %6d", 
                    tojo.mem[200], tojo.mem[198]);
        

        #600 $finish;
    end    
    
endmodule