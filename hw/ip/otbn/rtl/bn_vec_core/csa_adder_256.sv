module csa_adder_256 (
    input  logic [255:0] A,
    input  logic [255:0] B,
    input  logic [1:0]   data_type,   // 00: scalar, 01: vec32, 10: vec16
    input  logic         cin,    // scalar data_type only
    output logic [255:0] sum,
    output logic         cout    // scalar data_type only
);

    // Block configuration
    localparam BLOCK_WIDTH = 16;
    localparam NUM_BLOCKS  = 256 / BLOCK_WIDTH;

    // Internals
    logic [BLOCK_WIDTH-1:0] sum0   [NUM_BLOCKS];
    logic [BLOCK_WIDTH-1:0] sum1   [NUM_BLOCKS];
    logic [NUM_BLOCKS-1:0]  carry0;
    logic [NUM_BLOCKS-1:0]  carry1;
    logic [NUM_BLOCKS-1:0]  use_carry1;
    logic [NUM_BLOCKS-1:0]  carry_out;
    logic [NUM_BLOCKS-1:0]  select_carry;

    // Carry-in to each block
    logic [NUM_BLOCKS-1:0] carry_in;

    logic [BLOCK_WIDTH-1:0] a;
    logic [BLOCK_WIDTH-1:0] b;


    integer i;
    integer j;

    // Determine carry gating mask
    always_comb begin
        for (j = 0; j < NUM_BLOCKS; j++) begin
            case (data_type)
                2'b00: use_carry1[j] = (j != 0);                        // scalar: all blocks chained
                2'b01: use_carry1[j] = (j % (32 / BLOCK_WIDTH) != 0);  // vec32: every 32-bit block
                2'b10: use_carry1[j] = (j % (16 / BLOCK_WIDTH) != 0);  // vec16: every 16-bit block
                default: use_carry1[j] = 1'b0;
            endcase
        end
    end


    // Generate each block
    always_comb begin
        carry_in[0] = (data_type == 2'b00) ? cin : 1'b0;

    // Default initialize carry_out
    for (i = 0; i < NUM_BLOCKS; i++) begin
        carry_out[i] = 1'b0; // temporary default
    end

        for (i = 0; i < NUM_BLOCKS; i++) begin
            a = A[i*BLOCK_WIDTH +: BLOCK_WIDTH];
            b = B[i*BLOCK_WIDTH +: BLOCK_WIDTH];

            // Precompute for carry-in = 0
            {carry0[i], sum0[i]} = a + b;

            // Precompute for carry-in = 1
            {carry1[i], sum1[i]} = a + b + 1'b1;

            // Select actual carry-in
            if (i > 0)
                carry_in[i] = (use_carry1[i]) ? carry_out[i-1] : 1'b0;

            // Select appropriate sum/carry
            sum[i*BLOCK_WIDTH +: BLOCK_WIDTH] = (carry_in[i]) ? sum1[i] : sum0[i];
            carry_out[i] = (carry_in[i]) ? carry1[i] : carry0[i];
        end
    end

    // Final carry-out (only valid in scalar data_type)
    assign cout = (data_type == 2'b00) ? carry_out[NUM_BLOCKS-1] : 1'b0;

endmodule

