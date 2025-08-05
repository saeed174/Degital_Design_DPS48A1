module Pipeline_Mux_tb3();

    reg [3 : 0] in;
    reg clk, en , rst;
    wire [3 : 0] out;
    reg [3 : 0] out_expected;

    Pipeline_Mux #(.WIDTH(4),.PIPELINE_ENABLE(0),.RSTTYPE("SYNC")) pm(.in(in),.clk(clk),.en(en) , .rst(rst),.out(out));


    integer i;
    initial begin
        rst = 1;
        in = 0; en = 0; out_expected=0;
        #5;
        rst = 0;
        for(i = 0 ; i < 100 ; i = i+1) begin
            in = $random;
            en = $random;
            out_expected = in;
            #2;
        end
        $stop;
    end

    always @(in) begin
        #1;
        if(out != out_expected) begin
            $display("Error: out = %b, expected %b", out, out_expected);
            $stop;
        end
    end
endmodule