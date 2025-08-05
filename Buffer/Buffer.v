module Buffer(in, enable, out);
    parameter WIDTH = 36;
    input [WIDTH-1:0] in;
    input enable;
    output [WIDTH-1:0] out;
    assign out = enable ? in : {WIDTH{1'bz}};
endmodule