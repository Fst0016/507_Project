`timescale 1ns / 1ps

module tb_picorv32_vec_all_program_top;

    reg clk;
    reg resetn;

    wire trap;
    wire test_done;
    wire [31:0] result_vadd8;
    wire [31:0] result_vsub8;
    wire [31:0] result_vand;
    wire [31:0] result_vor;

    picorv32_vec_all_program_top uut (
        .clk(clk),
        .resetn(resetn),
        .trap(trap),
        .test_done(test_done),
        .result_vadd8(result_vadd8),
        .result_vsub8(result_vsub8),
        .result_vand(result_vand),
        .result_vor(result_vor)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("tb_picorv32_vec_all_program_top.vcd");
        $dumpvars(0, tb_picorv32_vec_all_program_top);

        clk = 0;
        resetn = 0;

        #20;
        resetn = 1;

        wait(test_done);

        #20;

        if (result_vadd8 == 32'h06080A0C)
            $display("VADD8 passed: result = %h", result_vadd8);
        else
            $display("VADD8 failed: expected 06080A0C, got %h", result_vadd8);

        if (result_vsub8 == 32'h04040404)
            $display("VSUB8 passed: result = %h", result_vsub8);
        else
            $display("VSUB8 failed: expected 04040404, got %h", result_vsub8);

        if (result_vand == 32'h01020300)
            $display("VAND passed: result = %h", result_vand);
        else
            $display("VAND failed: expected 01020300, got %h", result_vand);

        if (result_vor == 32'h0506070C)
            $display("VOR passed: result = %h", result_vor);
        else
            $display("VOR failed: expected 0506070C, got %h", result_vor);

        if (
            result_vadd8 == 32'h06080A0C &&
            result_vsub8 == 32'h04040404 &&
            result_vand  == 32'h01020300 &&
            result_vor   == 32'h0506070C
        ) begin
            $display("All custom instruction execution tests passed.");
        end else begin
            $display("One or more custom instruction execution tests failed.");
        end

        $finish;
    end

endmodule