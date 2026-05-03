`timescale 1ns / 1ps

module tb_picorv32_vec_top;

    reg clk;
    reg resetn;
    wire trap;

    picorv32_vec_top uut (
        .clk(clk),
        .resetn(resetn),
        .trap(trap)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_picorv32_vec_top.vcd");
        $dumpvars(0, tb_picorv32_vec_top);

        clk = 0;
        resetn = 0;

        #20;
        resetn = 1;

        #500;

        $display("PicoRV32 and PCPI vector unit integration simulation finished.");
        $finish;
    end

endmodule