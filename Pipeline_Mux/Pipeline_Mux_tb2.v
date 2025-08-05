module Pipeline_Max_tb2();
    reg [3 : 0] in;
    reg clk, en, rst;
    wire [3 : 0] out;
    reg [3 : 0] out_expected;

    Pipeline_Max #( .WIDTH(4), .PIPELINE_ENABLE(1), .RSTTYPE("ASYNC") ) pm(.in(in), .clk(clk), .en(en), .rst(rst), .out(out));

    initial begin
        clk = 0;
        in = 0;
        out_expected = 0;
        en = 0;
    forever begin
        #1 clk = ~clk;
    end
    end

    integer i;
    initial begin
        rst = 1;
        @(posedge clk);
        rst = 0;
        for(i = 0 ; i < 10 ; i = i+1) begin
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
    end

    always @(negedge clk) begin
        if(out != out_expected)
            $display("Error: out = %b, expected %b", out, out_expected);
    end
endmodule