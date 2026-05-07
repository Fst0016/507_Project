`timescale 1ns / 1ps

module tb_picorv32_vec_program_top;

    reg clk;
    reg resetn;

    wire trap;
    wire test_done;
    wire [31:0] test_result;

    picorv32_vec_program_top uut (
        .clk(clk),
        .resetn(resetn),
        .trap(trap),
        .test_done(test_done),
        .test_result(test_result)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_picorv32_vec_program_top.vcd");
        $dumpvars(0, tb_picorv32_vec_program_top);

        clk = 0;
        resetn = 0;

        #20;
        resetn = 1;

        wait(test_done);

        #20;

        if (test_result == 32'h06080A0C) begin
            $display("Custom instruction execution test passed.");
            $display("VADD8 result = %h", test_result);
        end else begin
            $display("Custom instruction execution test failed.");
            $display("Expected = 06080A0C, Got = %h", test_result);
        end

        $finish;
    end

endmodule