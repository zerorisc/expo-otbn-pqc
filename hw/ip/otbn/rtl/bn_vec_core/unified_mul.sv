module unified_mul #(
    parameter int WLEN = 256,
    parameter int DLEN = 64,
    parameter int SLEN = 32,
    parameter int HLEN = 16
) (
    input  logic [1:0]             data_type,            // 00 = 64x64, 01 = 4x32x32, 10 = 16x16x16
    input  logic [$clog2(WLEN/DLEN)-1:0] word_sel_A,
    input  logic [$clog2(WLEN/DLEN)-1:0] word_sel_B,
    input  logic                   half_sel,
    input  logic                   lane_mode,
    input  logic [3:0]             lane_index,
    input  logic [WLEN-1:0]        A,
    input  logic [WLEN-1:0]        B,
    input  logic [1:0]             data_type_64_shift,
    output logic [2*WLEN-1:0]      result
);

    localparam int NHALF = WLEN / HLEN;  // 16
//    localparam int NSING = WLEN / SLEN;  // 8
    localparam int NDOUB = WLEN / DLEN;  // 4

    // -------------------------------------------------------------------
    // Input and intermediate arrays
    // -------------------------------------------------------------------
    logic [HLEN-1:0] A16 [0:NHALF-1];
    logic [HLEN-1:0] B16 [0:NHALF-1];
    logic [2*HLEN-1:0] products [0:NHALF-1];
    logic [2*SLEN-1:0] partial32 [0:NDOUB-1];

    localparam MODE_64 = 2'b00;
    localparam MODE_32 = 2'b01;
    localparam MODE_16 = 2'b10;

    // -------------------------------------------------------------------
    // Input Decomposition
    // -------------------------------------------------------------------
    always_comb begin
        case (data_type)
            MODE_16: begin
                for (int i = 0; i < NHALF; i++) begin
                    A16[i] = A[HLEN*i +: HLEN];
                    B16[i] = (lane_mode == 1'b0) ? B[HLEN*i +: HLEN] : B[HLEN*lane_index +: HLEN];
                end
            end

            MODE_32: begin
                for (int i = 0; i < NDOUB; i++) begin
                    logic [SLEN-1:0] A32 = A[SLEN*(2*i + (half_sel ? 1 : 0)) +: SLEN];
                    logic [SLEN-1:0] B32 = (lane_mode == 1'b0) ? B[SLEN*(2*i + (half_sel ? 1 : 0)) +: SLEN] : B[SLEN*lane_index +: SLEN];
                    A16[4*i + 0] = A32[HLEN-1:0];
                    A16[4*i + 1] = A32[HLEN-1:0];
                    A16[4*i + 2] = A32[SLEN-1:HLEN];
                    A16[4*i + 3] = A32[SLEN-1:HLEN];

                    B16[4*i + 0] = B32[HLEN-1:0];
                    B16[4*i + 1] = B32[SLEN-1:HLEN];
                    B16[4*i + 2] = B32[HLEN-1:0];
                    B16[4*i + 3] = B32[SLEN-1:HLEN];
                end
            end

            MODE_64: begin
                logic [DLEN-1:0] A64 = A[DLEN*word_sel_A +: DLEN];
                logic [DLEN-1:0] B64 = B[DLEN*word_sel_B +: DLEN];

                logic [SLEN-1:0] A32 [4] = '{A64[SLEN*(0) +: SLEN], A64[SLEN*(0) +: SLEN], A64[SLEN*(1) +: SLEN], A64[SLEN*(1) +: SLEN]};
                logic [SLEN-1:0] B32 [4] = '{B64[SLEN*(0) +: SLEN], B64[SLEN*(1) +: SLEN], B64[SLEN*(0) +: SLEN], B64[SLEN*(1) +: SLEN]};
    
                for (int i = 0; i < NDOUB; i++) begin
                    A16[4*i + 0] = A32[i][HLEN-1:0];
                    A16[4*i + 1] = A32[i][HLEN-1:0];
                    A16[4*i + 2] = A32[i][SLEN-1:HLEN];
                    A16[4*i + 3] = A32[i][SLEN-1:HLEN];
                                                       
                    B16[4*i + 0] = B32[i][HLEN-1:0];
                    B16[4*i + 1] = B32[i][SLEN-1:HLEN];
                    B16[4*i + 2] = B32[i][HLEN-1:0];
                    B16[4*i + 3] = B32[i][SLEN-1:HLEN];
                end
            end

            default: begin
                for (int i = 0; i < NHALF; i++) begin
                    A16[i] = '0;
                    B16[i] = '0;
                end
            end
        endcase
    end

    // -------------------------------------------------------------------
    // Shared 16x16 Multipliers
    // -------------------------------------------------------------------
    generate
        for (genvar i = 0; i < NHALF; i++) begin : gen_mults
            /* verilator lint_off UNUSEDSIGNAL */
            logic [2*HLEN:0] product_full;  // "2*HLEN:0" to circumvent Verilator bug
            /* verilator lint_on UNUSEDSIGNAL */
            assign product_full = A16[i] * B16[i];
            assign products[i] = product_full[2*HLEN-1:0];
        end
    endgenerate

    // -------------------------------------------------------------------
    // Output Reconstruction
    // -------------------------------------------------------------------
    logic [2*HLEN*NHALF-1:0] result_16;
    logic [2*SLEN*NDOUB-1:0] result_32;
    logic [2*DLEN-1:0]       result_64;

    // -- 16x16 results --
    generate
        for (genvar i = 0; i < NHALF; i++) begin : gen_output_16
            assign result_16[2*HLEN*i +: 2*HLEN] = (data_type == MODE_16) ? products[i] : '0;
        end
    endgenerate

    // -- 32x32 grouped reconstruction --
    always_comb begin
        result_32 = '0;
        for (int i = 0; i < NDOUB; i++) begin
            logic [2*HLEN-1:0] p0 = products[4*i + 0];
            logic [2*HLEN-1:0] p1 = products[4*i + 1];
            logic [2*HLEN-1:0] p2 = products[4*i + 2];
            logic [2*HLEN-1:0] p3 = products[4*i + 3];


            partial32[i] = {{(SLEN){1'b0}}, p0} +
                           {{(HLEN){1'd0}}, p1, {(HLEN){1'd0}}} + 
                           {{(HLEN){1'd0}}, p2, {(HLEN){1'd0}}} +
                           {p3, {(SLEN){1'd0}}};

            if (data_type == MODE_32)
                result_32[2*SLEN*i +: 2*SLEN] = partial32[i];
        end
    end

    // -- 64x64 reconstruction using the 32x32 results --
    always_comb begin
        result_64 = '0;
        if (data_type == MODE_64) begin
            result_64 = {{DLEN{1'b0}}, partial32[0]} +
                        {{SLEN{1'b0}}, partial32[1], {SLEN{1'b0}}} +
                        {{SLEN{1'b0}}, partial32[2], {SLEN{1'b0}}} +
                        {partial32[3], {DLEN{1'b0}}};
        end
    end

    // -------------------------------------------------------------------
    // Unified Output Selection
    // -------------------------------------------------------------------
    always_comb begin
        unique case (data_type)
            MODE_64: //result = {{(2*WLEN-2*DLEN){1'b0}}, result_64};
                begin
                  unique case (data_type_64_shift)
                    2'd0: result = {{WLEN {1'b0}}, {DLEN * 2{1'b0}}, result_64};
                    2'd1: result = {{WLEN {1'b0}}, {DLEN{1'b0}}, result_64, {DLEN{1'b0}}};
                    2'd2: result = {{WLEN {1'b0}}, result_64, {DLEN * 2{1'b0}}};
                    2'd3: result = {{WLEN {1'b0}}, result_64[63:0], {DLEN * 3{1'b0}}};
                  endcase
                end
            MODE_32: //result = {{(2*WLEN-2*SLEN*NDOUB){1'b0}}, result_32};
                begin
                  unique case (half_sel)
                    1'd0:
                      begin
			 result[  0 +: 64] = result_32[  0 +: 64];
                         result[ 64 +: 64] = 64'b0;
			 result[128 +: 64] = result_32[ 64 +: 64];
                         result[192 +: 64] = 64'b0;
			 result[256 +: 64] = result_32[128 +: 64];
                         result[320 +: 64] = 64'b0;
			 result[384 +: 64] = result_32[192 +: 64];
                         result[448 +: 64] = 64'b0;
                      end
                    1'd1:
                      begin
			 result[  0 +: 64] = 64'b0;
                         result[ 64 +: 64] = result_32[  0 +: 64];
			 result[128 +: 64] = 64'b0;
                         result[192 +: 64] = result_32[ 64 +: 64];
			 result[256 +: 64] = 64'b0;
                         result[320 +: 64] = result_32[128 +: 64];
			 result[384 +: 64] = 64'b0;
                         result[448 +: 64] = result_32[192 +: 64];
                      end
                  endcase
                end
            MODE_16: result = result_16;
            default: result = '0;
        endcase
    end

endmodule

