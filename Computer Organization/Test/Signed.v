`timescale 1 ns/10 ps

module Signed;

/*reg [3:0] a;
reg [3:0] b;
reg [5:0] signed_sum;
reg [5:0] unsigned_sum;
initial begin
    a = 4'd10;
    b = 4'd2;
    signed_sum = $signed(a)+$signed(b);
    unsigned_sum = a+b;
    $display("a        : %6b, %3d", a, a);
    $display("b        : %6b, %3d", b, b);
    $display("s(a)     : %6b, %3d", $signed(a), $signed(a));
    $display("s(b)     : %6b, %3d", $signed(b), $signed(b));
    $display("a+b      : %6b, %3d", a+b, a+b);
    $display("sig(a+b) : %6b, %3d", $signed(a+b), $signed(a+b));
    $display("s(a)+s(b): %6b, %3d", $signed(a)+$signed(b), $signed(a)+$signed(b));
    $display("s_sum    : %6b, %3d", signed_sum, signed_sum);
    $display("s_sum    : %6b, %3d", signed_sum, $signed(signed_sum));
    $display("uns_sum  : %6b, %3d", unsigned_sum, unsigned_sum);
end*/

reg [1:0] A;
reg [3:0] B;
reg [3:0] C;

wire [3:0] t;

initial begin
    A = 2'b10;
    B = {A[1], A[0]};
    C = $signed({A[1], A[0]});
    $display("%b", B);
    $display("%b", C);

    t = A;
    B = t;
    C = $signed(t);
    $display("%b", B);
    $display("%b", C);
end

// display_bits d1(.data(signed_sum));
// display_bits d2(.data(unsigned_sum));

endmodule