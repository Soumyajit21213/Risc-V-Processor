module myProcessor #(
    parameter ADD   = 6'b000000,
    parameter SUB   = 6'b000001,
    parameter AND   = 6'b000010,
    parameter OR    = 6'b000011,
    parameter SLT   = 6'b000100,
    parameter MUL   = 6'b000101,
    parameter HLT   = 6'b111111,
    parameter LW    = 6'b001000,
    parameter SW    = 6'b001001,
    parameter ADDI  = 6'b001010,
    parameter SUBI  = 6'b001011,
    parameter SLTI  = 6'b001100,
    parameter BNEQZ = 6'b001101,
    parameter BEQZ  = 6'b001110,

    parameter RR_ALU = 3'b000,
    parameter RM_ALU = 3'b001,
    parameter LOAD   = 3'b010,
    parameter STORE  = 3'b011,
    parameter BRANCH = 3'b100,
    parameter HALT   = 3'b101
) (
    input clk1 , clk2 
);
    reg [31:0] mem [1023:0];
    reg [31:0] Reg [31:0];

    reg ex_mem_COND , HALTED , BRANCHED ;
    reg [31:0] if_id_IR , if_id_PC_copy , PC ;
    reg [31:0] id_ex_IR , id_ex_RS1 , id_ex_RS2 , id_ex_IMM , id_ex_PC_copy ;
    reg [2:0] id_ex_OPTYPE, ex_mem_OPTYPE, mem_wb_OPTYPE  ;
    reg [31:0] ex_mem_IR , ex_mem_RS2, ex_mem_ALUOUT ;
    reg [31:0] mem_wb_IR , mem_wb_RS2, mem_wb_ALUOUT ; 


    //IF STAGE
    always @(posedge clk1) begin
        if(~HALTED) begin
            if (((ex_mem_IR[31:26]==BEQZ) & (ex_mem_COND == 1)) |
                ((ex_mem_IR[31:26]==BNEQZ) & (ex_mem_COND == 0))) begin
                    BRANCHED      <= 1;
                    if_id_IR      <= mem[ex_mem_ALUOUT];
                    if_id_PC_copy <= ex_mem_ALUOUT +1;
                    PC            <= ex_mem_ALUOUT +1; 
                end else begin  
                    if_id_IR      <= mem[PC];
                    if_id_PC_copy <= PC + 1;
                    PC            <= PC + 1; 
                    end
        end
    end

    //ID STAGE
    always @(posedge clk2) begin
        if(~HALTED) begin
            id_ex_PC_copy <= if_id_PC_copy;
            id_ex_IR      <= if_id_IR;

            id_ex_RS1 <= Reg[if_id_IR[25:21]];
            id_ex_RS2 <= Reg[if_id_IR[20:16]];

            id_ex_IMM <= { {16{if_id_IR[15]}} , if_id_IR[15:0]};

            case (if_id_IR[31:26])
                ADD, SUB, AND, OR, SLT, MUL: id_ex_OPTYPE <= RR_ALU;
                ADDI, SUBI, SLTI :           id_ex_OPTYPE <= RM_ALU;
                LW :                         id_ex_OPTYPE <= LOAD ;
                SW :                         id_ex_OPTYPE <= STORE;
                BNEQZ, BEQZ :                id_ex_OPTYPE <= BRANCH;
                HLT :                        id_ex_OPTYPE <= HALT;
                default:                     id_ex_OPTYPE <= HALT;
            endcase
        end
    end

    //EX STAGE
    always @(posedge clk1) begin 
        if (~HALTED) begin
            BRANCHED      <=  0 ;
            ex_mem_IR     <=  id_ex_IR;
            ex_mem_OPTYPE <=  id_ex_OPTYPE;
            ex_mem_RS2    <=  id_ex_RS2;

            case (id_ex_OPTYPE)
                RR_ALU: begin
                    case(id_ex_IR[31:26])
                        ADD : ex_mem_ALUOUT <= id_ex_RS1 + id_ex_RS2;
                        SUB : ex_mem_ALUOUT <= id_ex_RS1 - id_ex_RS2;
                        AND : ex_mem_ALUOUT <= id_ex_RS1 & id_ex_RS2;
                        OR  : ex_mem_ALUOUT <= id_ex_RS1 | id_ex_RS2;
                        SLT : ex_mem_ALUOUT <= id_ex_RS1 < id_ex_RS2;
                        MUL : ex_mem_ALUOUT <= id_ex_RS1 * id_ex_RS2;
                        default: ex_mem_ALUOUT <= 32'hxxxxxxxx;
                    endcase
                end
                
                RM_ALU : begin
                    case(id_ex_IR[31:26])
                        ADDI: ex_mem_ALUOUT <= id_ex_RS1 + id_ex_IMM;
                        SUBI: ex_mem_ALUOUT <= id_ex_RS1 - id_ex_IMM;
                        SLTI: ex_mem_ALUOUT <= id_ex_RS1 < id_ex_IMM;
                        default: ex_mem_ALUOUT <= 32'hxxxxxxxx;
                    endcase
                end

                LOAD,STORE : begin
                    ex_mem_ALUOUT <= id_ex_RS1 + id_ex_IMM;
                end

                BRANCH: begin
                    ex_mem_ALUOUT <= id_ex_PC_copy + id_ex_IMM;
                    ex_mem_COND   <= (id_ex_RS1 == 0);
                end
            endcase
        end
    end

    //MEM STAGE
    always @(posedge clk2) begin
        if(~HALTED) begin 
            mem_wb_IR     <= ex_mem_IR;
            mem_wb_OPTYPE <= ex_mem_OPTYPE;
            case (ex_mem_OPTYPE)
                RR_ALU , RM_ALU:       mem_wb_ALUOUT <= ex_mem_ALUOUT;
                LOAD :                 mem_wb_RS2    <= mem[ex_mem_ALUOUT];
                STORE : if (~BRANCHED) mem[ex_mem_ALUOUT] <= ex_mem_RS2;
                HALT : HALTED <= 1;
            endcase
        end
    end
    
    //WB STAGE
    always @(posedge clk1) begin
        if(~BRANCHED) begin
            case (mem_wb_OPTYPE)
                RR_ALU : Reg[mem_wb_IR[15:11]] <= mem_wb_ALUOUT;
                RM_ALU : Reg[mem_wb_IR[20:16]] <= mem_wb_ALUOUT;
                LOAD :   Reg[mem_wb_IR[20:16]] <= mem_wb_RS2;
            endcase
        end
    end

endmodule 