module DSP (A,B,D,C,PCIN,BCIN,CARRYIN,CARRYOUT,CARRYOUTF,
            clk, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP,
            RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP,
            OPMODE,M,P,BCOUT,PCOUT
);

    parameter A0REG = 0; parameter A1REG = 1; parameter B0REG = 0; parameter B1REG = 1;
    parameter CREG = 1; parameter DREG = 1; parameter MREG = 1; parameter PREG = 1;
    parameter CARRYINREG = 1; parameter CARRYOUTREG = 1; parameter OPMODREG = 1;
    // OR --> "CARRYIN"
    parameter CARRYINSEL = "OPMOD5";
    // OR --> "CASCADE"
    parameter B_INPUT = "DIRECT";
    // OR --> "ASYNC"
    parameter RSTTYPE = "SYNC";


    input [17:0] A,B,D;
    input [47:0] C;
    input [47:0] PCIN;
    input [17:0] BCIN;
    input clk, CARRYIN,CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    input RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
    input [7:0] OPMODE;
    output [35:0] M;
    output [47:0] P;
    output [17:0] BCOUT;
    output [47:0] PCOUT;
    output CARRYOUT,CARRYOUTF;

    wire [17:0] w0, w1, w2, w3, w7, w8;
    reg [17:0] w5, w6;
    reg [47:0] w9, x_select, z_select, w14;
    wire [35:0] w10,w12;
    wire [47:0] w4;
    wire op1, op2, op3, op6;
    wire [1:0] op4, op5;
    reg w15;
    wire w11,w13_CIN;

    generate
        // -------> Stage 0 <----------
        assign w0 = (B_INPUT == "DIRECT")? B : BCIN;

        // -------> Stage 1 <----------
        Pipeline_Mux #(.WIDTH(18), .PIPELINE_ENABLE(DREG), .RSTTYPE(RSTTYPE))
        D_REG (.in(D), .clk(clk), .en(CED), .rst(RSTD), .out(w1));

        Pipeline_Mux #(.WIDTH(18), .PIPELINE_ENABLE(B0REG), .RSTTYPE(RSTTYPE))
        B0_REG (.in(w0), .clk(clk), .en(CEB), .rst(RSTB), .out(w2));

        Pipeline_Mux #(.WIDTH(18), .PIPELINE_ENABLE(A0REG), .RSTTYPE(RSTTYPE))
        A0_REG (.in(A), .clk(clk), .en(CEA), .rst(RSTA), .out(w3));

        Pipeline_Mux #(.WIDTH(48), .PIPELINE_ENABLE(CREG), .RSTTYPE(RSTTYPE))
        C_REG (.in(C), .clk(clk), .en(CEC), .rst(RSTC), .out(w4));

        // -------> Buttom Stage <----------
        Pipeline_Mux #(.WIDTH(1), .PIPELINE_ENABLE(OPMODREG), .RSTTYPE(RSTTYPE))
        OP1_REG (.in(OPMODE[6]), .clk(clk), .en(CEOPMODE), .rst(RSTOPMODE), .out(op1));

        Pipeline_Mux #(.WIDTH(1), .PIPELINE_ENABLE(OPMODREG), .RSTTYPE(RSTTYPE))
        OP2_REG (.in(OPMODE[4]), .clk(clk), .en(CEOPMODE), .rst(RSTOPMODE), .out(op2));

        Pipeline_Mux #(.WIDTH(1), .PIPELINE_ENABLE(OPMODREG), .RSTTYPE(RSTTYPE))
        OP3_REG (.in(OPMODE[5]), .clk(clk), .en(CEOPMODE), .rst(RSTOPMODE), .out(op3));

        Pipeline_Mux #(.WIDTH(2), .PIPELINE_ENABLE(OPMODREG), .RSTTYPE(RSTTYPE))
        OP4_REG (.in(OPMODE[1:0]), .clk(clk), .en(CEOPMODE), .rst(RSTOPMODE), .out(op4));

        Pipeline_Mux #(.WIDTH(2), .PIPELINE_ENABLE(OPMODREG), .RSTTYPE(RSTTYPE))
        OP5_REG (.in(OPMODE[3:2]), .clk(clk), .en(CEOPMODE), .rst(RSTOPMODE), .out(op5));

        Pipeline_Mux #(.WIDTH(1), .PIPELINE_ENABLE(OPMODREG), .RSTTYPE(RSTTYPE))
        OP6_REG (.in(OPMODE[7]), .clk(clk), .en(CEOPMODE), .rst(RSTOPMODE), .out(op6));

        // -------> Stage 2 <----------
        always @(*) begin
            if(op1) begin
                w5 = w1 - w2;
            end
            else begin
                w5 = w1 + w2;
            end
        end
        always @(*) begin
            if(op2) begin
                w6 = w5;
            end
            else begin
                w6 = w2;
            end
        end

        // -------> Stage 3 <----------
        Pipeline_Mux #(.WIDTH(18), .PIPELINE_ENABLE(B1REG), .RSTTYPE(RSTTYPE))
        B1_REG (.in(w6), .clk(clk), .en(CEB), .rst(RSTB), .out(w7));

        Pipeline_Mux #(.WIDTH(18), .PIPELINE_ENABLE(A1REG), .RSTTYPE(RSTTYPE))
        A1_REG (.in(w3), .clk(clk), .en(CEA), .rst(RSTA), .out(w8));

        always @(*) begin
            w9 = {w1[11:0],w8,w7};
        end

        assign w10 = w7 * w8;
        assign BCOUT = w7;

        assign w11 = (CARRYINSEL == "OPMOD5")? op3 : CARRYIN;

        // -------> Stage 4 <----------
        Pipeline_Mux #(.WIDTH(36), .PIPELINE_ENABLE(MREG), .RSTTYPE(RSTTYPE))
        M_REG (.in(w10), .clk(clk), .en(CEM), .rst(RSTM), .out(w12));

        Pipeline_Mux #(.WIDTH(1), .PIPELINE_ENABLE(CARRYINREG), .RSTTYPE(RSTTYPE))
        CYI_REG (.in(w11), .clk(clk), .en(CECARRYIN), .rst(RSTCARRYIN), .out(w13_CIN));

        Buffer M_BUF (.in(w12),.enable(1),.out(M));

        // -------> Stage 5 <----------
        always @(*) begin
            case(op4)
                2'b00 : x_select = 0;
                2'b01 : x_select = w12;
                2'b10 : x_select = P;
                2'b11 : x_select = w9;
            endcase
        end

        always @(*) begin
            case(op5)
                2'b00 : z_select = 0;
                2'b01 : z_select = PCIN;
                2'b10 : z_select = P;
                2'b11 : z_select = w4;
            endcase
        end

        // -------> Stage 6 <----------
        always @(*) begin
            if(op6) begin
                {w15,w14} = z_select - (x_select+w13_CIN);
            end
            else begin
                {w15,w14} = z_select + x_select + w13_CIN;
            end
        end

        Pipeline_Mux #(.WIDTH(1), .PIPELINE_ENABLE(CARRYOUTREG), .RSTTYPE(RSTTYPE))
        CYO_REG (.in(w15), .clk(clk), .en(CECARRYIN), .rst(RSTCARRYIN), .out(CARRYOUT));

        assign CARRYOUTF = CARRYOUT;

        Pipeline_Mux #(.WIDTH(48), .PIPELINE_ENABLE(PREG), .RSTTYPE(RSTTYPE))
        P_REG (.in(w14), .clk(clk), .en(CEP), .rst(RSTP), .out(P));

        assign PCOUT = P;

    endgenerate
endmodule