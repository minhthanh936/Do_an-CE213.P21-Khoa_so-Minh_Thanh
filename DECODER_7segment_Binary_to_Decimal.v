module DECODER_7segment_Binary_to_Decimal(
input wire [3:0]IN,
output wire [6:0]OUT
);
/*always @ (IN) begin
    case (IN)
        4'h0: OUT = 7'b1000000;
        4'h1: OUT = 7'b1111001;
        4'h2: OUT = 7'b0100100;
        4'h3: OUT = 7'b0110000;
        4'h4: OUT = 7'b0011001;
        4'h5: OUT = 7'b0010010;
        4'h6: OUT = 7'b0000010;
        4'h7: OUT = 7'b1111000;
        4'h8: OUT = 7'b0000000;
        4'h9: OUT = 7'b0010000;
        4'hA: OUT = 7'b0001000;
        4'hB: OUT = 7'b0000011;
        4'hC: OUT = 7'b1000110;
        4'hD: OUT = 7'b0100001;
        4'hE: OUT = 7'b0000110;
        4'hF: OUT = 7'b0001110;
        default: OUT = 7'b1111111;
    endcase
end*/
assign OUT = (IN==4'b0000)?7'b1000000:((IN==4'b0001)?7'b1111001:((IN==4'b0010)?7'b0100100:((IN==4'b0011)?7'b0110000:
((IN==4'b0100)?7'b0011001:((IN==4'b0101)?7'b0010010:((IN==4'b0110)?7'b0000010:((IN==4'b0111)?7'b1111000:
((IN==4'b1000)?7'b0000000:((IN==4'b1001)?7'b0010000:7'b1111111)))))))));
endmodule