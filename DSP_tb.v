module DSP_tb();

    reg [17:0] A, B, D;
    reg [47:0] C;
    reg [47:0] PCIN;
    reg [17:0] BCIN;
    reg clk, CARRYIN;
    reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
    reg [7:0] OPMODE;
    wire [35:0] M;
    wire [47:0] P;
    wire [17:0] BCOUT;
    wire [47:0] PCOUT;
    wire CARRYOUT, CARRYOUTF;

    reg [35:0] M_expected;
    reg [47:0] P_expected;
    reg [17:0] BCOUT_expected;
    reg [47:0] PCOUT_expected;
    reg CARRYOUT_expected, CARRYOUTF_expected;

    DSP dut(
        .A(A), .B(B), .D(D), .C(C), .PCIN(PCIN), .BCIN(BCIN),
        .CARRYIN(CARRYIN), .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF),
        .clk(clk), 
        .CEA(CEA), .CEB(CEB), .CEC(CEC), .CECARRYIN(CECARRYIN), 
        .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
        .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), 
        .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
        .OPMODE(OPMODE), .M(M), .P(P), .BCOUT(BCOUT), .PCOUT(PCOUT)
    );

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    initial begin
        // Test 1
        RSTA = 1; RSTB = 1; RSTC = 1;
        RSTD = 1; RSTM = 1; RSTP = 1;
        RSTOPMODE = 1; RSTCARRYIN = 1;

        A = $random; B = $random; C = $random; D = $random;
        CARRYIN = $random; PCIN = $random; BCIN = $random;
        CEA = $random; CEB = $random; CEC = $random; CECARRYIN = $random;
        CED = $random; CEM = $random; CEOPMODE = $random; CEP = $random;
        OPMODE = $random;

        M_expected = 0; P_expected = 0;
        BCOUT_expected = 0; PCOUT_expected = 0;
        CARRYOUT_expected = 0; CARRYOUTF_expected = 0;

        @(negedge clk);

        if ({M_expected, P_expected, BCOUT_expected, PCOUT_expected, CARRYOUT_expected, CARRYOUTF_expected} != 
            {M, P, BCOUT, PCOUT, CARRYOUT, CARRYOUTF}) begin
            $display("ERROR: Initial values not zero");
            $stop;
        end

        // Test 2
        RSTA = 0; RSTB = 0; RSTC = 0;
        RSTD = 0; RSTM = 0; RSTP = 0;
        RSTOPMODE = 0; RSTCARRYIN = 0;

        CEA = 1; CEB = 1; CEC = 1; CECARRYIN = 1; CED = 1; CEM = 1;
        CEOPMODE = 1; CEP = 1;

        OPMODE = 8'b11011101;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        M_expected = 'h12c; P_expected = 'h32;
        BCOUT_expected = 'hf; PCOUT_expected = 'h32;
        CARRYOUT_expected = 0; CARRYOUTF_expected = 0;
        @(negedge clk);

        if ({M_expected, P_expected, BCOUT_expected, PCOUT_expected, CARRYOUT_expected , CARRYOUTF_expected} != 
            {M, P, BCOUT, PCOUT, CARRYOUT , CARRYOUTF}) begin
            $display("ERROR: Initial values not zero");
            $stop;
        end
    

        // Test 3
        OPMODE = 8'b00010000;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        M_expected = 'h2bc; P_expected = 0;
        BCOUT_expected = 'h23; PCOUT_expected = 0;
        CARRYOUT_expected = 0; CARRYOUTF_expected = 0;
        @(negedge clk);

        if({M_expected,P_expected,BCOUT_expected,PCOUT_expected,CARRYOUT_expected,CARRYOUTF_expected} != {M,P,BCOUT,PCOUT,CARRYOUT,CARRYOUTF}) begin
            $display("ERROR: Initial values not zero");
            $stop;
        end

        // Test 4
        OPMODE = 8'b00001010;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        M_expected = 'hc8; P_expected = 0;
        BCOUT_expected = 'ha; PCOUT_expected = 0;
        CARRYOUT_expected = 0; CARRYOUTF_expected = 0;
        @(negedge clk);

        if({M_expected,P_expected,BCOUT_expected,PCOUT_expected,CARRYOUT_expected,CARRYOUTF_expected} != {M,P,BCOUT,PCOUT,CARRYOUT,CARRYOUTF}) begin
            $display("ERROR: Initial values not zero");
            $stop;
        end

        // Test 5
        OPMODE = 8'b10100111;
        A = 5; B = 6; C = 350; D = 25; PCIN = 3000;
        BCIN = $random; CARRYIN = $random;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        M_expected = 'h1e; P_expected = 'hfe6fffec0bb1;
        BCOUT_expected = 'h6; PCOUT_expected = 'hfe6fffec0bb1;
        CARRYOUT_expected = 1; CARRYOUTF_expected = 1;
        @(negedge clk);

        if({M_expected,P_expected,BCOUT_expected,PCOUT_expected,CARRYOUT_expected,CARRYOUTF_expected} != {M,P,BCOUT,PCOUT,CARRYOUT,CARRYOUTF}) begin
            $display("ERROR: Initial values not zero");
            $stop;
        end

        $stop;
    end
endmodule

