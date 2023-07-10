module tt_um_neuron (
    // 8 pins in, 8 pins out, 8 pins bidirectional
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n     // low to trigger reset
);

    assign in_current = ui_in [5:0];
    assign uo_out [0] = spike;
    assign uo_out [6:1] = state;

    reg [5:0] threshold;
    reg [5:0] decay_rate;
    reg [5:0] state_hist;

    wire reset != rst_n;

    //// () syntax -> multiplexer
    // assign state_hist = in_current + (spike ? 0 : (state * decay_rate));
    assign state_hist = in_current + (spike ? 0 : (state >> 1));            // scale by 1/2

    always @(posedge clk) begin 
        if (reset) begin
            threshold <= 32;
            state <= 0;
            spike <= 0;
        end else begin
            state <= state_hist;
            spike <= (state >= threshold);
        end
    end

endmodule
