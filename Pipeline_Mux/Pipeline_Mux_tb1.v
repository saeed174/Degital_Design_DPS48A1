module Pipeline_Mux_tb1();

    reg [3 : 0] in;
    reg clk, en , rst;
    wire [3 : 0] out;
    reg [3 : 0] out_expected;

    Pipeline_Mux #(.WIDTH(4), .PIPELINE_ENABLE(1), .RSTTYPE("SYNC")) 
        pm(.in(in), .clk(clk), .en(en), .rst(rst), .out(out));

    initial begin
        clk = 0;
        in = 0;
        out_expected = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    integer i;
    initial begin
        rst = 1;
        @(posedge clk);
        rst = 0;
        for(i = 0; i < 100; i = i+1) begin
            in = $random;
            en = $random;
            @(posedge clk);
            if(en) begin
                out_expected = in;
            end
            else begin
                out_expected = 0;
            end
        end
        $stop;
    end

    always @(negedge clk) begin
        if(out != out_expected) begin
            $display("Error: out = %b, expected %b", out, out_expected);
            $stop;
        end
    end

endmodule
