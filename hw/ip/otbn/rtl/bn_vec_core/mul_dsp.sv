// 7-Series (DSP48E1) multimode multiplier with full column cascades.
// Modes:
//   mode=2'b00 : 1 × (64x64  -> 128b)
//   mode=2'b01 : 4 × (32x32  ->  64b)
//   mode=2'b10 : 16× (16x16  ->  32b)
//
// Single-cycle: all DSP regs disabled. Unsigned arithmetic.
//
// \begin{tabular}{lrrrrrr}
// \hline
//  top\_module   &   LUT &   DSP &   CARRY4 &   FF &   BRAM &   Fmax \\
// \hline
//  mul\_dsp      &   715 &    16 &       52 &    0 &      0 &     85 \\
// \hline
// \end{tabular}
//
module mul_dsp (
    input  logic [1:0] mode,         // 00:64x64, 01:4x32, 10:16x16

    // 64x64 inputs
    input  logic [63:0] a64,
    input  logic [63:0] b64,

    // 4× 32x32 inputs
    input  logic [3:0][31:0] a32,
    input  logic [3:0][31:0] b32,

    // 16× 16x16 inputs
    input  logic [15:0][15:0] a16,
    input  logic [15:0][15:0] b16,

    // Outputs
    output logic [127:0]       p64,
    output logic [3:0][63:0]   p32,
    output logic [15:0][31:0]  p16
);

    localparam logic [6:0] OPMODE_M_ONLY       = 7'b0000001; // P = M
    localparam logic [6:0] OPMODE_M_PLUS_PCIN  = 7'b0010001; // P = M + PCIN
    localparam logic [3:0] ALU_ADD             = 4'b0000;

    // -------- split inputs --------
    // 64×64 into 16-bit tiles A64[i], B64[j], i,j in 0..3
    logic [15:0] A64 [0:3], B64 [0:3];
    assign {A64[3],A64[2],A64[1],A64[0]} = a64;
    assign {B64[3],B64[2],B64[1],B64[0]} = b64;

    // 4×32×32 halves (per tile g = {0:TL,1:TR,2:BL,3:BR})
    logic [15:0] A32h [0:3][0:1];
    logic [15:0] B32h [0:3][0:1];
    for (genvar g=0; g<4; g++) begin : SPLIT32
        assign A32h[g][0] = a32[g][15:0];
        assign A32h[g][1] = a32[g][31:16];
        assign B32h[g][0] = b32[g][15:0];
        assign B32h[g][1] = b32[g][31:16];
    end

    // -------- per-DSP selected 16×16 inputs (runtime) --------
    // DSP indices k = 0..15 laid out as 4×4 grid: k = 4*i + j (i=row, j=col).
    logic [15:0] dspA16 [0:15];
    logic [15:0] dspB16 [0:15];

    always_comb begin
      for (int k=0; k<16; k++) begin
        int i = k/4; int j = k%4;          // grid indices
        int gg = (i/2)*2 + (j/2);          // tile index 0..3 (TL,TR,BL,BR)
        int ii = i%2; int jj = j%2;        // 2×2 local row/col inside tile

        unique case (mode)
        2'b00: begin // 64×64
            dspA16[k] = A64[i];
            dspB16[k] = B64[j];
        end
        2'b01: begin // 4×32×32 mapped by tiles
            dspA16[k] = A32h[gg][ii];      // A0/A1
            dspB16[k] = B32h[gg][jj];      // B0/B1
        end
        default: begin // 2'b10: 16×16 independent
            dspA16[k] = a16[k];
            dspB16[k] = b16[k];
        end
        endcase
      end
    end

    logic [47:0] P     [0:15];
    logic [47:0] PCOUT [0:15];

    function automatic logic [6:0] op_for(input logic [1:0] m, input int idx);
      unique case (m)
        2'b10: op_for = OPMODE_M_ONLY;                                     // 16×16
        2'b01: op_for = (idx==4 || idx==6 || idx==12 || idx==14) ? OPMODE_M_PLUS_PCIN
                                           : OPMODE_M_ONLY;                // 32×32
        default: op_for = (idx==4 || idx==6 || idx==12 || idx==14 || idx==2 || idx==5  || idx==9  || idx==13  || idx== 10) 
                          ? OPMODE_M_PLUS_PCIN : OPMODE_M_ONLY;   // 64×64
      endcase
    endfunction

    `define DSP_CELL(idx, pcin_wire) \
      DSP48E1 #(.USE_MULT("MULTIPLY"), .USE_SIMD("ONE48"), \
                .AREG(0), .BREG(0), .MREG(0), .PREG(0), \
                .ACASCREG(0), .BCASCREG(0), .CREG(0), .DREG(0), .ADREG(0), \
                .INMODEREG(0), .ALUMODEREG(0), .OPMODEREG(0), \
                .CARRYINREG(0), .CARRYINSELREG(0)) \
      u_dsp``idx ( \
          .CLK(1'b0), \
          .A({14'b0, dspA16[idx]}), \
          .B({2'b0, dspB16[idx]}), \
          .C(48'd0), \
          .P(P[idx]), \
          .PCIN(pcin_wire), \
          .PCOUT(PCOUT[idx]), \
          .OPMODE(op_for(mode, idx)), \
          .ALUMODE(4'b0000), \
          .INMODE(5'b00000), \
          .ACIN(30'd0), .BCIN(18'd0), \
          .CARRYIN(1'b0), .CARRYINSEL(3'b000), \
          .CEA1(1'b0), .CEA2(1'b0), .CEB1(1'b0), .CEB2(1'b0), \
          .CEC(1'b0), .CEM(1'b0), .CEP(1'b0), \
          .RSTA(1'b0), .RSTB(1'b0), .RSTC(1'b0), .RSTM(1'b0), .RSTP(1'b0), \
          .RSTINMODE(1'b0), .RSTALLCARRYIN(1'b0), .RSTALUMODE(1'b0), .RSTCTRL(1'b0) );

    /* verilator lint_off PINMISSING */
    `DSP_CELL(0,  48'd0)
    `DSP_CELL(1,  48'd0)
    `DSP_CELL(4,  PCOUT[1])
    `DSP_CELL(5,  PCOUT[2])

    `DSP_CELL(2,  PCOUT[8])
    `DSP_CELL(3,  48'd0)
    `DSP_CELL(6,  PCOUT[3])
    `DSP_CELL(7,  48'd0)

    `DSP_CELL(8,  48'd0)
    `DSP_CELL(9,  PCOUT[6])
    `DSP_CELL(12, PCOUT[9])
    `DSP_CELL(13, PCOUT[7])

    `DSP_CELL(10, PCOUT[13])
    `DSP_CELL(11, 48'd0)
    `DSP_CELL(14, PCOUT[11])
    `DSP_CELL(15, 48'd0)
    /* verilator lint_on PINMISSING */

    // Final 64×64 sum across diagonals
    logic [127:0] sum64;

    logic [111:0] x;
    logic [111:0] y;
    logic [111:0] z;
    logic [111:0] sum;
    logic [111:0] carry;

    // 3:2 compressor input
    assign x = {{15'b0}, P[14][32:0], {14'd0}, P[ 5][33:0], P[0][31:16]};
    assign y = {P[15][31:0], P[10][31:0], {15'd0}, P[ 4][32:0]};
    assign z = (mode == 2'b00) ? {{30'b0}, P[10][33:32],{14'd0}, P[12][33:0], {32'b0}} : {112'b0};

    // 3:2 compressor
    always_comb begin
        for (int i = 0; i < 112; i++) begin
            sum[i]   = x[i] ^ y[i] ^ z[i];
            carry[i] = (x[i] & y[i]) | (y[i] & z[i]) | (z[i] & x[i]);
        end
    end

    assign sum64[15:0] = P[0][15:0];
    assign sum64[127:16] = sum + {carry[110:0], 1'b0};

    assign p64 = sum64;

    always_comb begin
      p32[1][15:0] = P[2][15:0];
      p32[1][63:16]  = {P[7][31:0], P[2][31:16]};
      p32[1][63:16] += {15'd0, P[6][32:0]};

      p32[2][15:0] = P[8][15:0];
      p32[2][63:16]  = {P[13][31:0], P[8][31:16]};
      p32[2][63:16] += {15'd0, P[12][32:0]};
    end

    assign p32[0] = sum64[0+:64];
    assign p32[3] = sum64[64+:64];

    for (genvar t=0; t<16; t++) begin : P16_OUT
      always_comb p16[t] = P[t][31:0];
    end

endmodule

