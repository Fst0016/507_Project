`timescale 1ns / 1ps

module tb_pcpi_vec;

    reg clk;
    reg resetn;

    reg        pcpi_valid;
    reg [31:0] pcpi_insn;
    reg [31:0] pcpi_rs1;
    reg [31:0] pcpi_rs2;

    wire        pcpi_wr;
    wire [31:0] pcpi_rd;
    wire        pcpi_wait;
    wire        pcpi_ready;

    // Instantiate vector PCPI module
    picorv32_pcpi_vec uut (
        .clk(clk),
        .resetn(resetn),

        .pcpi_valid(pcpi_valid),
        .pcpi_insn(pcpi_insn),
        .pcpi_rs1(pcpi_rs1),
        .pcpi_rs2(pcpi_rs2),

        .pcpi_wr(pcpi_wr),
        .pcpi_rd(pcpi_rd),
        .pcpi_wait(pcpi_wait),
        .pcpi_ready(pcpi_ready)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Build custom instruction
    // opcode = custom-0 = 0001011
    function [31:0] make_instr;
        input [6:0] funct7;
        input [2:0] funct3;
        begin
            make_instr = {funct7, 5'd2, 5'd1, funct3, 5'd3, 7'b0001011};
        end
    endfunction

    initial begin
        $dumpfile("tb_pcpi_vec.vcd");
        $dumpvars(0, tb_pcpi_vec);

        clk = 0;
        resetn = 0;

        pcpi_valid = 0;
        pcpi_insn  = 32'h00000000;
        pcpi_rs1   = 32'h00000000;
        pcpi_rs2   = 32'h00000000;

        #20;
        resetn = 1;

        // -------------------------
        // Test 1: VADD8
        // rs1 = 01 02 03 04
        // rs2 = 05 06 07 08
        // result = 06 08 0A 0C
        // -------------------------
        pcpi_valid = 1;
        pcpi_insn  = make_instr(7'b0000000, 3'b000);
        pcpi_rs1   = 32'h01020304;
        pcpi_rs2   = 32'h05060708;

        #10;
        if (pcpi_ready && pcpi_wr && pcpi_rd == 32'h06080A0C)
            $display("Test 1 VADD8 passed");
        else
            $display("Test 1 VADD8 failed: pcpi_rd = %h", pcpi_rd);

        pcpi_valid = 0;
        #10;

        // -------------------------
        // Test 2: VSUB8
        // rs1 = 09 08 07 06
        // rs2 = 01 02 03 04
        // result = 08 06 04 02
        // -------------------------
        pcpi_valid = 1;
        pcpi_insn  = make_instr(7'b0000000, 3'b001);
        pcpi_rs1   = 32'h09080706;
        pcpi_rs2   = 32'h01020304;

        #10;
        if (pcpi_ready && pcpi_wr && pcpi_rd == 32'h08060402)
            $display("Test 2 VSUB8 passed");
        else
            $display("Test 2 VSUB8 failed: pcpi_rd = %h", pcpi_rd);

        pcpi_valid = 0;
        #10;

        // -------------------------
        // Test 3: VAND
        // -------------------------
        pcpi_valid = 1;
        pcpi_insn  = make_instr(7'b0000000, 3'b010);
        pcpi_rs1   = 32'hFF00FF00;
        pcpi_rs2   = 32'h0F0F0F0F;

        #10;
        if (pcpi_ready && pcpi_wr && pcpi_rd == 32'h0F000F00)
            $display("Test 3 VAND passed");
        else
            $display("Test 3 VAND failed: pcpi_rd = %h", pcpi_rd);

        pcpi_valid = 0;
        #10;

        // -------------------------
        // Test 4: VOR
        // -------------------------
        pcpi_valid = 1;
        pcpi_insn  = make_instr(7'b0000000, 3'b011);
        pcpi_rs1   = 32'hFF00FF00;
        pcpi_rs2   = 32'h0F0F0F0F;

        #10;
        if (pcpi_ready && pcpi_wr && pcpi_rd == 32'hFF0FFF0F)
            $display("Test 4 VOR passed");
        else
            $display("Test 4 VOR failed: pcpi_rd = %h", pcpi_rd);

        pcpi_valid = 0;
        #10;

        // -------------------------
        // Test 5: Invalid instruction
        // Should not respond
        // -------------------------
        pcpi_valid = 1;
        pcpi_insn  = 32'h00000033;   // normal R-type opcode, not custom-0
        pcpi_rs1   = 32'h11111111;
        pcpi_rs2   = 32'h22222222;

        #10;
        if (!pcpi_ready && !pcpi_wr)
            $display("Test 5 invalid instruction passed");
        else
            $display("Test 5 invalid instruction failed");

        pcpi_valid = 0;
        #10;

        $display("PCPI vector unit testbench finished");
        $finish;
    end

endmodule