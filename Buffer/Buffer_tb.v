module Buffer_tb();
    reg [35:0] in;
    reg enable;
    wire [35:0] out;
    Buffer bf(.in(in), .enable(enable), .out(out));

    integer i;
    initial begin
        enable = 0;
        #1;
        enable = 1;
        for(i = 0; i < 75; i = i + 1) begin
            in = $random;
            #1;
        end
    end
endmodule