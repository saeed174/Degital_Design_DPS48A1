module Pipeline_Mux(in,clk,out,en,rst);

    parameter WIDTH = 18;
    parameter PIPELINE_ENABLE = 1;
    parameter RSTTYPE = "SYNC";

    input [WIDTH-1 : 0] in;
    input clk , en , rst;
    output reg [WIDTH-1 : 0] out;

    generate
        if(PIPELINE_ENABLE) begin
            if(RSTTYPE == "SYNC") begin
                always @(posedge clk) begin
                    if(rst) begin
                        out <= 0;
                    end
                    else if(en) begin
                        out <= in;
                    end
                end
            end
            else begin
                always @(posedge clk or posedge rst) begin
                    if(rst) begin
                        out <= 0;
                    end
                    else if(en) begin
                        out <= in;
                    end
                end
            end
        end
        else begin
            always @(*) begin
                out = in;
            end
        end
    endgenerate

endmodule