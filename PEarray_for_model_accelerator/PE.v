`timescale 1ns/10ps
`include "MAC.v"

// module PE(
//     input clk,
//     input rst,
//     input [7:0] ifmap_noc,
//     input ifmap_enable,
//     input [7:0] weight_noc,
//     input weight_enable,
//     input [23:0] ipsum_noc,
//     input ipsum_enable, 
//     input [3:0] iw_size,    // kernel size
//     input [3:0] c,         // channel num
//     input [3:0] f,          // filter num
//     input [3:0] n,          // ifmap num
//     input [3:0] o,          // each row output psum pixel num 
//     input opsum_ready,
//     output ifmap_ready,
//     output weight_ready,
//     output ipsum_ready,
//     output reg opsum_enable,
//     output reg [23:0] opsum_noc
// );
// // registers to store the input feature map and weight data
// reg [7:0] ifmap_reg [15:0];
// reg [7:0] weight_reg [15:0];
// // registers to store the partial sum and partial sum input
// reg [23:0] psum = 24'b0;
// reg [23:0] ipsum_reg;
// // wire signals to select the read and write register indexes
// wire [4:0] read_reg_sel = ifmap_enable ? n : 5'b0;
// wire [4:0] write_reg_sel = weight_enable ? f : 5'b0;
// // wire signals to select the kernel size and output pixel number
// wire [4:0] sel1 = iw_size;
// wire [4:0] sel2 = o;

// integer i, j, k, l;

// always @(posedge rst or posedge clk) begin
//     if (rst) begin
//         for (i = 0; i < 16; i = i + 1) begin
//             ifmap_reg[i] = 8'b0;
//             weight_reg[i] = 8'b0;
//         end 
//         ipsum_reg = 24'b0;
//     end
//     else begin
//         if (ifmap_enable) begin
//             ifmap_reg[read_reg_sel] = ifmap_noc;
//         end

//         if (weight_enable) begin
//             weight_reg[write_reg_sel] = weight_noc;
//         end

//         if (ipsum_enable) begin
//             ipsum_reg = ipsum_noc;
//         end

//         if (opsum_ready) begin
//             psum = 24'b0;
//             // Iterate through each kernel element
//             for (i = 0; i < sel1; i = i + 1) begin
//                 for (j = 0; j < sel1; j = j + 1) begin
//                     // Iterate through each channel of the input feature map and weight tensor
//                     for (k = 0; k < c; k = k + 1) begin
//                         // Compute the partial sum for the current kernel element
//                         psum = psum + ifmap_reg[((n*c)+(k*sel1)+i)*sel2+j] * weight_reg[((f*c)+(k*sel1)+i)*sel1+j];
//                     end
//                 end
//             end
//             // Add the input partial sum to the computed partial sum
//             opsum_noc = psum + ipsum_reg;
//             // Enable output partial sum
//             opsum_enable = 1'b1;
//         end
//         else begin
//             // Disable output partial sum
//             opsum_enable = 1'b0;
//         end
//     end
// end

// assign ifmap_ready = ~ifmap_enable;
// assign weight_ready = ~weight_enable;
// assign ipsum_ready = ~ipsum_enable;

// endmodule


module PE(
    input clk,
    input rst,
    input [7:0] ifmap_noc,
    input ifmap_enable,
    input [7:0] weight_noc,
    input weight_enable,
    input [23:0] ipsum_noc,
    input ipsum_enable, 
    input [3:0] iw_size,    // kernel size
    input [3:0] c,         // channel num
    input [3:0] f,          // filter num
    input [3:0] n,          // ifmap num
    input [3:0] o,          // each row output psum pixel num 
    input opsum_ready,
    output reg ifmap_ready,
    output weight_ready,
    output ipsum_ready,
    output opsum_enable,
    output [23:0] opsum_noc
);

//input pin
wire bottom;
wire filter_en;	
wire ifmap_en;			
wire psum_en;
wire [7:0] filter_in;
wire [7:0] ifmap_in;
wire [23:0] psum_in;
wire [3:0] con_size;
wire [3:0] C;
wire [3:0] F;
wire [3:0] M;
wire [3:0] O;

assign bottom = 1'd0;
assign filter_en = weight_enable && weight_ready;
assign ifmap_en = ifmap_enable && ifmap_ready;
assign psum_en = ipsum_enable && ipsum_ready;
assign filter_in = weight_noc;
assign ifmap_in = ifmap_noc;
assign psum_in = ipsum_noc;
assign con_size = iw_size;
assign C = c;
assign F = f;
assign M = n;
assign O = o;

//output pin
reg filter_ready;		
reg psum_in_ready;
reg [23:0] opsum;
reg opsum_en;

assign weight_ready = filter_ready;
assign ipsum_ready = psum_in_ready;
assign opsum_noc = opsum;
assign opsum_enable = opsum_en;
	
// state 
reg [2:0] current_state;
reg [2:0] next_state;
parameter IDLE = 3'd0;
parameter DataIn = 3'd1; //filter_in ifmap_in
parameter Convolution = 3'd2;
parameter Accumulation = 3'd3;
parameter PsumOut = 3'd4;

// ScratchPad
wire [3:0] ifmap_spad_width;
assign ifmap_spad_width = (con_size + O);

// logic [7:0] filter_spad [F:0][con_size:0][C:0];
// logic [7:0] ifmap_spad [M:0][ifmap_spad_width:0][C:0];
// logic [23:0] psum_spad [M:0][F:0][O:0]; 
reg [7:0] filter_spad [1:0][2:0][2:0];
reg [7:0] ifmap_spad [1:0][3:0][2:0];
reg [23:0] psum_spad [1:0][1:0][1:0];
reg [3:0] filter_spad_ptr_0;
reg [3:0] filter_spad_ptr_1;
reg [3:0] filter_spad_ptr_2;
reg [3:0] ifmap_spad_ptr_0;
reg [3:0] ifmap_spad_ptr_1;
reg [3:0] ifmap_spad_ptr_2;
reg [3:0] psum_spad_ptr_0;
reg [3:0] psum_spad_ptr_1;
reg [3:0] psum_spad_ptr_2;
reg [3:0] acc_ptr_0;
reg [3:0] acc_ptr_1;
reg [3:0] acc_ptr_2;

reg filter_en_save;
reg ifmap_en_save;
reg [7:0]filter_save;
reg [7:0]ifmap_save;

integer  f2, f1, f0, m2, m1, m0, p2, p1, p0, b;

// Convolution PE multiplication  
reg [7:0] ifmap_MAC;
reg [7:0] filter_MAC;
reg [3:0] filter_MAC_ptr_0;
reg [3:0] filter_MAC_ptr_1;
reg [3:0] filter_MAC_ptr_2;
reg [3:0] ifmap_MAC_ptr_0;
reg [3:0] ifmap_MAC_ptr_1;
reg [3:0] ifmap_MAC_ptr_2;
reg [23:0] psum_MAC;
wire [23:0] updated_psum;

//Convolution step record 
reg 		con_done;
reg 		con_step;
reg 		reset_acc;
reg [3:0] con_column;	//column
reg [3:0] con_ch;
reg [3:0] con_round;
reg [3:0] con_filter;
reg [3:0] con_ifmap;
reg [3:0] con_round_reg;
reg [3:0] con_filter_reg;
reg [3:0] con_ifmap_reg;

//save psum 
reg [3:0] i_psum;
reg [23:0] psum_out_save[3:0];
reg [23:0] psum_Acc;
reg [23:0] opsum_reg;
reg acc_step;
reg acc_done;
reg [23:0]psum_in_reg;
reg psum_in_accu;

//track that conv finish or not 
//1:N or not start / 0:Y
wire filter_track;
wire ifmap_track;
assign filter_track = (filter_spad_ptr_0 > con_ch || filter_spad_ptr_1 > con_column || filter_spad_ptr_2 > con_filter);
assign ifmap_track = (ifmap_spad_ptr_0 > con_ch || ifmap_spad_ptr_1 > con_column || ifmap_spad_ptr_2 > con_ifmap );

// state 
always @(posedge clk or posedge rst) begin
    if(rst) 
        current_state <= IDLE;
    else 
        current_state <= next_state;
end

always @(*) begin
    case(current_state)
        IDLE: begin
            if(filter_en || ifmap_en) 
                next_state = DataIn;
            else if (con_filter && con_ifmap) 
                next_state = Convolution;
            else 
                next_state = IDLE;
        end

        DataIn: begin
            //con_filter is 0
            if (!con_filter) begin
                //con_round is 0
                if (!con_round) begin
                    if (filter_track && ifmap_track)
                        next_state = Convolution;
                    else
                        next_state = DataIn;
                end else begin
                    //con_round is 1
                    if (ifmap_spad_ptr_0 > con_ch || (!ifmap_spad_ptr_0 && con_ch == C && con_column == con_size))
                        next_state = Convolution;
                    else
                        next_state = DataIn;
                end
            end else begin
                //con_filter is 1
				if(filter_spad_ptr_0 > con_ch || filter_spad_ptr_1 > con_column || filter_spad_ptr_2 > con_filter) 
                    next_state = Convolution;
                else 
                    next_state = DataIn;
            end
        end

        Convolution: begin
            if(bottom) begin
				if (con_done && i_psum != 4'd7) // 4'd7 = -4'd1 initial value
					next_state = PsumOut;
				else if (con_done)
					next_state = IDLE;
				else
					next_state = Convolution;
			end else begin // not bottom PE
				if (con_done && psum_in_accu)
					next_state = Accumulation;
				else if(con_done && (!psum_in_accu) )
					next_state = IDLE;
				else 
					next_state = Convolution;
			end	
        end

        Accumulation: begin
			if(acc_done)
				next_state = IDLE;
			else 
				next_state = Accumulation;
		end

        PsumOut: begin //for bottom
			if(i_psum == 4'd7)
				next_state = IDLE;
			else 
				next_state = PsumOut;
		end 

    endcase
end

//reset_acc //1: psum equals to 0 //0: add psum
always @(*) begin
    case(current_state)
        IDLE: begin
            // DataIn
            if (filter_spad_ptr_2 == (F + 4'd1))
                filter_ready = 1'd0;
            else
                filter_ready = 1'd1;
            if (ifmap_spad_ptr_2 == (M + 4'd1))
				ifmap_ready = 1'd0;
			else 
				ifmap_ready = 1'd1;
			if (con_column == con_size && con_ch == C)
                psum_in_ready = 1'd1;
            else
                psum_in_ready = 1'd0;
            
            //Convolution 
            reset_acc = 1'd1;
			con_done = 1'd0;
			ifmap_MAC_ptr_0 = con_ch;
			ifmap_MAC_ptr_1 = con_round + con_column;
			ifmap_MAC_ptr_2 = con_ifmap;
			filter_MAC_ptr_0 = con_ch;
			filter_MAC_ptr_1 = con_column;
			filter_MAC_ptr_2 = con_filter;

            //Accumulation
			opsum = 24'd0;
			opsum_en = 1'd0;
			acc_done = 1'd0;
        end 

        DataIn: begin
            //Convolution
            if (next_state == Convolution)begin
                filter_ready = 1'd0;
				ifmap_ready = 1'd0;
				psum_in_ready = 1'd0;
				if (!con_column && !con_ch)
                    reset_acc = 1'd1;
                else
                    reset_acc = 1'd0;
                ifmap_MAC_ptr_0 = con_ch;
                ifmap_MAC_ptr_1 = con_round + con_column;
                ifmap_MAC_ptr_2 = con_ifmap;
                filter_MAC_ptr_0 = con_ch;
                filter_MAC_ptr_1 = con_column;
                filter_MAC_ptr_2 = con_filter;
            end else begin //DataIn
				if(filter_spad_ptr_2 == (F + 4'd1))
					filter_ready = 1'd0;
				else  
					filter_ready = 1'd1; 
				if(ifmap_spad_ptr_2 == (M + 4'd1))
					ifmap_ready = 1'd0;
				else  
					ifmap_ready = 1'd1;
				psum_in_ready = 1'd0;
				reset_acc = 1'd1;
				ifmap_MAC_ptr_0 = con_ch;
				ifmap_MAC_ptr_1 = con_round + con_column;
				ifmap_MAC_ptr_2 = con_ifmap;
				filter_MAC_ptr_0 = con_ch;
				filter_MAC_ptr_1 = con_column;
				filter_MAC_ptr_2 = con_filter;
			end 
			
			con_done = 1'd0;
			
			//Accumulation
			opsum = 24'd0;
			opsum_en = 1'd0;
			acc_done = 1'd0;
        end

        Convolution: begin
			//DataIn
			filter_ready = 1'd0;
			ifmap_ready = 1'd0;
			//modified for LAB4
			/* if (con_column == con_size && con_ch == C) begin
				psum_in_ready = 1'd1;
			end else begin  */
				psum_in_ready = 1'd0;
			//end 
			//Convolution
			if (!con_column && !con_ch) begin
				reset_acc = 1'd1;
			end else begin 
				reset_acc = 1'd0;
			end
			
			if(!con_filter) begin	
				if(!con_round) begin
                    if(ifmap_spad_ptr_0 == con_ch && ifmap_spad_ptr_1 == (con_round + con_column) && ifmap_spad_ptr_2 == con_ifmap) 
                    //since ifmap arrives later
                        con_done = 1'd1;
                    else 
                        con_done = 1'd0; 
				end else begin
                    //?
					if((!filter_spad_ptr_0 && !filter_spad_ptr_1 && filter_spad_ptr_2 == 4'd1)
					&& (!ifmap_spad_ptr_0 && ifmap_spad_ptr_1 == 4'd3 && !ifmap_spad_ptr_2)) begin
						if(!con_ch && !con_column && !con_filter && !con_ifmap && con_round == 4'd1) 
							con_done = 1'd1;
						else 
							con_done = 1'd0;
					end else begin
						if(con_size == con_column && ifmap_spad_ptr_0 == con_ch)
							con_done = 1'd1;
						else 
							con_done = 1'd0;
					end 
				end
			//con_filter = 1 
			end else begin
				if((filter_spad_ptr_0 == con_ch && filter_spad_ptr_1 == con_column && filter_spad_ptr_2 == con_filter)
				|| (con_ch == C && con_column == con_size && con_step)) begin
				//since filter arrives later
					con_done = 1'd1;
				end else begin 
					con_done = 1'd0;
				end
			end 

			//calculate Convolution Spad ptr   
			ifmap_MAC_ptr_0 = con_ch;
			ifmap_MAC_ptr_1 = con_round + con_column;
			ifmap_MAC_ptr_2 = con_ifmap;
			filter_MAC_ptr_0 = con_ch;
			filter_MAC_ptr_1 = con_column;
			filter_MAC_ptr_2 = con_filter;
			
			//Accumulation
			opsum = 24'd0;
			opsum_en = 1'd0;
			acc_done = 1'd0;
		end
				
		Accumulation: begin
			//DataIn
			filter_ready = 1'd0;
			ifmap_ready = 1'd0;
			psum_in_ready = 1'd0;
			
			//Convolution
			reset_acc = 1'd1;
            con_done = 1'd0;
			ifmap_MAC_ptr_0 = 4'd0;
			ifmap_MAC_ptr_1 = 4'd0;
			ifmap_MAC_ptr_2 = 4'd0;
			filter_MAC_ptr_0 = 4'd0;
			filter_MAC_ptr_1 = 4'd0;
			filter_MAC_ptr_2 = 4'd0;
			
			//Accumulation
			if(opsum_ready && acc_step) begin
				opsum = (psum_in_reg + psum_Acc);
				opsum_en = 1'd1;
				acc_done = 1'd1;
			end else begin
				opsum = 24'd0;
				opsum_en = 1'd0;
				acc_done = 1'd0;
			end 
		end
		
		PsumOut: begin
			//DataIn
			filter_ready = 1'd0;
			ifmap_ready = 1'd0;
			psum_in_ready = 1'd0;
			
			//Convolution
			reset_acc = 1'd1;
			con_done = 1'd0;
			ifmap_MAC_ptr_0 = 4'd0;
			ifmap_MAC_ptr_1 = 4'd0;
			ifmap_MAC_ptr_2 = 4'd0;
			filter_MAC_ptr_0 = 4'd0;
			filter_MAC_ptr_1 = 4'd0;
			filter_MAC_ptr_2 = 4'd0;
			
			//Accumulation
			opsum = 24'd0;
			opsum_en = 1'd0;
			acc_done = 1'd0;
		end

    endcase
end

//IDLE
//save data for accumulation
always @(posedge clk or posedge rst) begin
    if(rst) begin
        psum_in_reg <= 24'd0;
        psum_in_accu <= 1'd0;
    end else if(current_state == IDLE) begin
		if(psum_en) begin
			psum_in_accu <= 1'd1;
			psum_in_reg  <= psum_in;
		end else begin
			psum_in_accu <= psum_in_accu;
			psum_in_reg  <=	psum_in_reg;		
		end 
	end else if(current_state == Accumulation && acc_step) begin
		psum_in_accu <= 1'd0;
		psum_in_reg  <= 24'd0;
	end else begin
		psum_in_reg   <= psum_in_reg;
		psum_in_accu   <= psum_in_accu;
	end
end

//Control scratchpad ptr
always @(posedge clk or posedge rst) begin
    if(rst) begin
		ifmap_spad_ptr_0  <=   4'd0;
		ifmap_spad_ptr_1  <=   4'd0;
		ifmap_spad_ptr_2  <=   4'd0;
		filter_spad_ptr_0 <=   4'd0;
		filter_spad_ptr_1 <=   4'd0;
		filter_spad_ptr_2 <=   4'd0;
		
		filter_en_save <= 1'd0;
		filter_save <= 8'd0;
		ifmap_en_save <= 1'd0;
		ifmap_save  <= 8'd0;
    end else if ((current_state == IDLE) || (current_state == DataIn)) begin
        if(filter_en) begin
			if(filter_spad_ptr_0 == C) begin
				filter_spad_ptr_0 <= 4'd0;
				if(filter_spad_ptr_1 == con_size)begin
					filter_spad_ptr_1 <= 4'd0;
					filter_spad_ptr_2 <= filter_spad_ptr_2 + 4'd1;
				end else begin
					filter_spad_ptr_1 <= filter_spad_ptr_1 + 4'd1;
					filter_spad_ptr_2 <= filter_spad_ptr_2;
				end 
			end else begin
				filter_spad_ptr_0 <= filter_spad_ptr_0 + 4'd1;
				filter_spad_ptr_1 <= filter_spad_ptr_1;
				filter_spad_ptr_2 <= filter_spad_ptr_2;
			end 
		end else begin 
			filter_spad_ptr_0 <= filter_spad_ptr_0;
			filter_spad_ptr_1 <= filter_spad_ptr_1;
			filter_spad_ptr_2 <= filter_spad_ptr_2;
		end

        if(ifmap_en) begin
			if(ifmap_spad_ptr_0 == C) begin
				ifmap_spad_ptr_0 <= 4'd0;
				if(ifmap_spad_ptr_1 == ifmap_spad_width)begin
					ifmap_spad_ptr_1 <= 4'd0;
					ifmap_spad_ptr_2 <= ifmap_spad_ptr_2 + 4'd1;
				end else begin
					ifmap_spad_ptr_1 <= ifmap_spad_ptr_1 + 4'd1;
					ifmap_spad_ptr_2 <= ifmap_spad_ptr_2;
				end 
			end else begin
				ifmap_spad_ptr_0 <= ifmap_spad_ptr_0 + 4'd1;
				ifmap_spad_ptr_1 <= ifmap_spad_ptr_1;
				ifmap_spad_ptr_2 <= ifmap_spad_ptr_2;
			end 
		end else begin 
			ifmap_spad_ptr_0 <= ifmap_spad_ptr_0;
			ifmap_spad_ptr_1 <= ifmap_spad_ptr_1;
			ifmap_spad_ptr_2 <= ifmap_spad_ptr_2;
		end 
            filter_en_save <= filter_en;
			ifmap_en_save  <= ifmap_en;
			filter_save  <= filter_in;
			ifmap_save <= ifmap_in;
	
	end else begin
		filter_spad_ptr_0 <= filter_spad_ptr_0;
		filter_spad_ptr_1 <= filter_spad_ptr_1;
		filter_spad_ptr_2 <= filter_spad_ptr_2;
		ifmap_spad_ptr_0 <= ifmap_spad_ptr_0;
		ifmap_spad_ptr_1 <= ifmap_spad_ptr_1;
		ifmap_spad_ptr_2 <= ifmap_spad_ptr_2;
		
		filter_en_save <= filter_en;
		ifmap_en_save  <= ifmap_en;
		filter_save <= filter_save;
		ifmap_save  <= ifmap_save;
	end
end

//DataIn put data into scratchpad
always @(posedge clk or posedge rst) begin
    if(rst) begin
		for(f2=0 ; f2<=1 ; f2 = f2 + 1)begin
			for(f1=0 ; f1<=2 ; f1 = f1 + 1)begin
				for(f0=0 ; f0<=2 ; f0 = f0 + 1)begin
					filter_spad[f2][f1][f0] <= 8'd0;
				end 
			end 
		end 
		for(m2=0 ; m2<=1 ; m2= m2 + 1)begin
			for(m1=0 ; m1<=3 ; m1 = m1 + 1)begin
				for(m0=0 ; m0<=2 ; m0 = m0 + 1)begin
					ifmap_spad[m2][m1][m0] <= 8'd0;
				end 
			end 
		end 
    end else if (next_state == DataIn || current_state == DataIn) begin 
		if (filter_en) begin
			filter_spad[filter_spad_ptr_2][filter_spad_ptr_1][filter_spad_ptr_0] <= filter_in;
		end else begin
			filter_spad[filter_spad_ptr_2][filter_spad_ptr_1][filter_spad_ptr_0] <= filter_spad[filter_spad_ptr_2][filter_spad_ptr_1][filter_spad_ptr_0];
		end
		if (ifmap_en) begin
			ifmap_spad[ifmap_spad_ptr_2][ifmap_spad_ptr_1][ifmap_spad_ptr_0]  <= ifmap_in;
		end else begin
			ifmap_spad[ifmap_spad_ptr_2][ifmap_spad_ptr_1][ifmap_spad_ptr_0]  <= ifmap_spad[ifmap_spad_ptr_2][ifmap_spad_ptr_1][ifmap_spad_ptr_0];
		end	
				
	end else begin
		for(f2=0 ; f2<=1 ; f2 = f2 + 1)begin
			for(f1=0 ; f1<=2 ; f1 = f1 + 1)begin
				for(f0=0 ; f0<=2 ; f0 = f0 + 1)begin
					filter_spad[f2][f1][f0] <= filter_spad[f2][f1][f0];
				end 
			end 
		end 
		for(m2=0 ; m2<=1 ; m2= m2 + 1)begin
			for(m1=0 ; m1<=3 ; m1 = m1 + 1)begin
				for(m0=0 ; m0<=2 ; m0 = m0 + 1)begin
					ifmap_spad[m2][m1][m0] <= ifmap_spad[m2][m1][m0];
				end 
			end 
		end
		// filter_spad[filter_spad_ptr_2][filter_spad_ptr_1][filter_spad_ptr_0] <= filter_spad[filter_spad_ptr_2][filter_spad_ptr_1][filter_spad_ptr_0];
		// ifmap_spad[ifmap_spad_ptr_2][ifmap_spad_ptr_1][ifmap_spad_ptr_0]  <= ifmap_spad[ifmap_spad_ptr_2][ifmap_spad_ptr_1][ifmap_spad_ptr_0];
	end
end

//use in state Convolution
MAC MAC0(
	.ifmap(ifmap_MAC),
	.filter(filter_MAC),
	.psum(psum_MAC),
	.updated_psum(updated_psum)
);

always @(posedge clk or posedge rst) begin
    if(rst) begin
		con_ch <= 4'd0;
		con_column <= 4'd0;
		con_round <= 4'd0;
		con_filter <= 4'd0;
		con_ifmap <= 4'd0;
    end else if (current_state == Convolution && !con_step)begin
		if(con_ch == C) begin
			con_ch <= 4'd0;
			if(con_column == con_size) begin
				con_column <= 4'd0; 
				if(con_round == O) begin
					con_round <= 4'd0;
					if(con_filter == F) begin
						con_filter <= 4'd0;
						con_ifmap <= con_ifmap + 4'd1;
					end else begin
						con_filter <= con_filter + 4'd1;
						con_ifmap <= con_ifmap;
					end 
				end else begin
					con_round <= con_round + 4'd1;
					con_filter <= con_filter;
					con_ifmap <= con_ifmap;
				end 
			end else begin
				con_column <= con_column + 4'd1;
				con_round <= con_round;
				con_filter <= con_filter;
				con_ifmap <= con_ifmap;
			end 						
		end else begin
			con_ch <= con_ch + 4'd1;
			con_column <= con_column ;
			con_round <= con_round;
			con_filter <= con_filter;
			con_ifmap <= con_ifmap;
		end
	end else begin
		con_column <= con_column;
	    con_ch <= con_ch;
	    con_round <= con_round;
	    con_filter <= con_filter;
	    con_ifmap <= con_ifmap;
	end 
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
		ifmap_MAC  <= 8'd0;
		filter_MAC <= 8'd0;
		psum_MAC <= 24'd0;
		con_round_reg <= 4'd0;
		con_ifmap_reg <= 4'd0;
		con_filter_reg <= 4'd0;
		con_step <= 1'd0;
    end else if(current_state == Convolution && !con_step) begin
		if(reset_acc) begin
			psum_MAC <= 24'd0;
		end else begin
			psum_MAC <= psum_spad [con_ifmap][con_filter][con_round];
		end
		ifmap_MAC  <= ifmap_spad [ifmap_MAC_ptr_2][ifmap_MAC_ptr_1][ifmap_MAC_ptr_0];
		filter_MAC <= filter_spad [filter_MAC_ptr_2][filter_MAC_ptr_1][filter_MAC_ptr_0];
		con_round_reg <= con_round;
		con_ifmap_reg <= con_ifmap;
		con_filter_reg <= con_filter;
		con_step <= 1'd1;
	end else begin
		ifmap_MAC  <= 8'd0;
		filter_MAC <= 8'd0;
		psum_MAC <= 24'd0;
		con_round_reg <= con_round_reg;
		con_ifmap_reg <= con_ifmap_reg;
		con_filter_reg <= con_filter_reg;
		con_step <= 1'd0;
	end
end

// PsumOut //Accumulation  
// address psum accumulation and delivery
always@(posedge clk or posedge rst) begin
	if(rst) begin
		psum_Acc <= 24'd0;
		acc_ptr_0 <= 4'd0;
		acc_ptr_1 <= 4'd0;
		acc_ptr_2 <= 4'd0;
		for(p0=0 ; p0<=1 ; p0 = p0 + 1)begin
			for(p1=0 ; p1<=1 ; p1 = p1 + 1)begin
				for(p2=0 ; p2<=1 ; p2 = p2 + 1)begin
					psum_spad[p2][p1][p0] <= 24'd0;
				end 
			end 
		end
		//for bottom
		// for (b = 0; b <= 3; b = b + 1)
		psum_out_save[0] <= 24'd0;
		psum_out_save[1] <= 24'd0;
		psum_out_save[2] <= 24'd0;
		psum_out_save[3] <= 24'd0;
		i_psum <= -4'd1;
		
	end else if(current_state == Convolution && con_step) begin
		psum_spad [con_ifmap_reg][con_filter_reg][con_round_reg] <= updated_psum; 
		
	end else if (!bottom) begin
		if (current_state == Accumulation) begin
			if(!acc_step)begin
				acc_step <= 1'd1;
				psum_Acc <= psum_spad [acc_ptr_2][acc_ptr_1][acc_ptr_0];
				for(p0=0 ; p0<=1 ; p0 = p0 + 1)begin
					for(p1=0 ; p1<=1 ; p1 = p1 + 1)begin
						for(p2=0 ; p2<=1 ; p2 = p2 + 1)begin
							psum_spad[p2][p1][p0] <= psum_spad[p2][p1][p0];
						end 
					end 
				end
			end else begin
				acc_step <= acc_step;
				psum_Acc <= psum_Acc;
				psum_spad [acc_ptr_2][acc_ptr_1][acc_ptr_0] <= (psum_in_reg + psum_Acc);
			end
			//renew accumulation schedule
			if(acc_done) begin
				if(acc_ptr_0 == O) begin
					acc_ptr_0 = 4'd0;
					if(acc_ptr_1 == F) begin
						acc_ptr_1 <= 4'd0;
						acc_ptr_2 <= acc_ptr_2 + 4'd1;
					end else begin
						acc_ptr_1 <= acc_ptr_1 + 4'd1;
						acc_ptr_2 <= acc_ptr_2;
					end 
				end else begin
					acc_ptr_0 <= acc_ptr_0 + 4'd1;
					acc_ptr_1 <= acc_ptr_1;
					acc_ptr_2 <= acc_ptr_2;
				end
			end else begin
				acc_ptr_0 <= acc_ptr_0;
				acc_ptr_1 <= acc_ptr_1;
				acc_ptr_2 <= acc_ptr_2;
			end	
		end else begin
			acc_step <= 1'd0;
			psum_Acc <= psum_Acc;
			for(p0=0 ; p0<=1 ; p0 = p0 + 1)begin
				for(p1=0 ; p1<=1 ; p1 = p1 + 1)begin
					for(p2=0 ; p2<=1 ; p2 = p2 + 1)begin
						psum_spad[p2][p1][p0] <= psum_spad[p2][p1][p0];
					end 
				end 
			end
			acc_ptr_0 <= acc_ptr_0;
			acc_ptr_1 <= acc_ptr_1;
			acc_ptr_2 <= acc_ptr_2;
		end 
	end else begin
		psum_Acc <= 24'd0;
		acc_ptr_0 <= acc_ptr_0;
		acc_ptr_1 <= acc_ptr_1;
		acc_ptr_2 <= acc_ptr_2;
		for(p0=0 ; p0<=1 ; p0 = p0 + 1)begin
			for(p1=0 ; p1<=1 ; p1 = p1 + 1)begin
				for(p2=0 ; p2<=1 ; p2 = p2 + 1)begin
					psum_spad[p2][p1][p0] <= psum_spad[p2][p1][p0];
				end 
			end 
		end
		i_psum <= i_psum;
	end
end

endmodule

module Spad_8bits(
    input wire [7:0] write_data,
    input wire [4:0] read_addr,
    input wire [4:0] write_addr,
    input wire w_en,
    input wire r_en,
    input wire clk,
    input wire reset,
    output [7:0] read_data
);

reg [7:0] reg_file [31:0];
wire [4:0] read_reg_sel = r_en ? read_addr : 5'b0;
wire [4:0] write_reg_sel = w_en ? write_addr : 5'b0;
integer i;

always @(posedge reset or posedge clk) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            reg_file[i] = 8'b0;
        end        
    end
    else begin
        if (w_en) begin
            reg_file[write_reg_sel] = write_data;
        end
    end
end

assign read_data = r_en ? reg_file[read_reg_sel] : 8'b0;

endmodule 


module Psum_Spad(
    input wire [31:0] write_data,
    input wire [4:0] read_addr,
    input wire [4:0] write_addr,
    input wire w_en,
    input wire r_en,
    input wire clk,
    input wire reset,
    output [31:0] read_data
);

reg [31:0] reg_file [31:0];
wire [4:0] read_reg_sel = r_en ? read_addr : 5'b0;
wire [4:0] write_reg_sel = w_en ? write_addr : 5'b0;
integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
            reg_file[i] = 32'b0;
        end 
end
always @(posedge reset or posedge clk) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            reg_file[i] = 32'b0;
        end        
    end
    else begin
        if (w_en) begin
            reg_file[write_reg_sel] = write_data;
        end
    end
end

assign read_data = r_en ? reg_file[read_reg_sel] : 32'b0;

endmodule 

// module MAC(
//     input [7:0] ifmap,
//     input [7:0] weight,
//     output [15:0] result
// );

// reg [15:0] prod;   // intermediate product
// reg [15:0] acc;    // accumulator

// initial begin
//     prod = 15'b0;
//     acc = 15'b0;
// end

// always @(*) begin
//     prod = ifmap * weight;
//     acc = acc + prod;  // accumulate the product
// end

// assign result = acc;

// endmodule

module Mux_mul_ipsum(
    input [15:0] prod,
    input [23:0] ipsum_noc,
    input ipsum_enable,
    output [23:0] result
);

assign result = ipsum_enable ? ipsum_noc : {8'b0, prod};

endmodule

module Mux_psum(
    input [23:0] psum,
    input opsum_enable,
    output [23:0] result
);

assign result = opsum_enable ? psum : 24'b0;

endmodule

module Adder(
    input [23:0] prod,
    input [23:0] psum,
    output [23:0] opsum_noc
);

assign opsum_noc = prod + psum;

endmodule

module PE_controller(

);

endmodule