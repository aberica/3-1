`timescale 1ns/10ps

module Alloc;

reg [5:0] Out;
reg [3:0] In1;
wire [3:0] Wire;

initial begin
    In1 = 4'b1000; // In1의 초기값을 4비트로 변경
    Out = 6'b0; // Out의 초기값을 설정
    Out[3:0] = In1; // 비트 범위를 수정

    // always 블록 내에서 $display 사용
    $display("%b", Out);
    
    #30
    $display("%b", Wire);
end

assign Wire = In1;

endmodule