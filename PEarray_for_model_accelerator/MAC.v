// module MAC(
//     input [7:0] ifmap,   // Input feature map
//     input [7:0] filter,  // Filter
//     input [23:0] psum,   // Partial sum
//     output reg [23:0] updated_psum  // Updated partial sum
// );

//     reg  [15:0] p, ans;
//     reg  [7:0] neg_ifmap;
//     reg [23:0] prod;
//     integer i, lookup_tbl, operate;
    
//     always @(*) begin
//         p = 16'b0;
//         ans = 16'b0;
  
//         // Two's complement of a negative number
//         assign neg_ifmap = (~ifmap) + 1;

//         for (i = 1; i <= 7; i = i + 2) begin
//             if (i == 1)
//                 lookup_tbl = 0;
//             else
//                 lookup_tbl = filter[i-2];

//             lookup_tbl = lookup_tbl + 4*filter[i] + 2*filter[i-1];

//             if (lookup_tbl == 0 || lookup_tbl == 7)
//                 operate = 0;
//             else if (lookup_tbl == 3 || lookup_tbl == 4)
//                 operate = 2;
//             else
//                 operate = 1;

//             if (filter[i] == 1) 
//                operate = -1*operate;
                
//             case (operate)
//             1: begin
//                 ans = {{8{ifmap[7]}}, ifmap};
//                 ans = ans << (i-1);
//                 p = p + ans;
//             end
//             2: begin
//                 ans = {{8{ifmap[7]}}, ifmap} << 1;
//                 ans = ans << (i-1);
//                 p = p + ans;
//             end
//             -1: begin
//                 if (ifmap==(8'b10000000))
//                     ans = {{8{1'b0}}, neg_ifmap};
//                 else
//                     ans = {{8{neg_ifmap[7]}}, neg_ifmap};
//                 ans = ans << (i-1);
//                 p = p + ans;
//             end
//             -2: begin
//                 if (ifmap==(8'b10000000))
//                     ans = {{8{1'b0}}, neg_ifmap} << 1;
//                 else
//                     ans = {{8{neg_ifmap[7]}}, neg_ifmap} << 1;
//                 ans = ans << (i - 1);
//                 p = p + ans;
//             end
//             endcase

//         end

//         prod = {{8{p[15]}}, p};
//         updated_psum <= prod + psum;
//     end
// endmodule
`timescale 1ns/10ps

module MAC(
    input [7:0] ifmap,   // Input feature map
    input [7:0] filter,  // Filter
    input [23:0] psum,   // Partial sum
    output [23:0] updated_psum  // Updated partial sum
);
wire [15:0] product;
Booth_Mux mux(ifmap, filter, product);
Adder add(product, psum, updated_psum);

endmodule 

`timescale 1ns/10ps

module Booth_Mux(
    input [7:0] ifmap,   // Input feature map
    input [7:0] filter,  // Filter
    output reg [15:0] p  // Updated partial sum
);

    reg  [15:0] ans;
    reg  [7:0] neg_ifmap;
    integer i, lookup_tbl, operate;
    
    always @(*) begin
        p = 16'b0;
        ans = 16'b0;
  
        // Two's complement of a negative number
        assign neg_ifmap = (~ifmap) + 1;

        for (i = 1; i <= 7; i = i + 2) begin
            if (i == 1)
                lookup_tbl = 0;
            else
                lookup_tbl = filter[i-2];

            lookup_tbl = lookup_tbl + 4*filter[i] + 2*filter[i-1];

            if (lookup_tbl == 0 || lookup_tbl == 7)
                operate = 0;
            else if (lookup_tbl == 3 || lookup_tbl == 4)
                operate = 2;
            else
                operate = 1;

            if (filter[i] == 1) 
               operate = -1*operate;
                
            case (operate)
            1: begin
                ans = {{8{ifmap[7]}}, ifmap};
                ans = ans << (i-1);
                p = p + ans;
            end
            2: begin
                ans = {{8{ifmap[7]}}, ifmap} << 1;
                ans = ans << (i-1);
                p = p + ans;
            end
            -1: begin
                if (ifmap==(8'b10000000))
                    ans = {{8{1'b0}}, neg_ifmap};
                else
                    ans = {{8{neg_ifmap[7]}}, neg_ifmap};
                ans = ans << (i-1);
                p = p + ans;
            end
            -2: begin
                if (ifmap==(8'b10000000))
                    ans = {{8{1'b0}}, neg_ifmap} << 1;
                else
                    ans = {{8{neg_ifmap[7]}}, neg_ifmap} << 1;
                ans = ans << (i - 1);
                p = p + ans;
            end
            endcase

        end
        
    end
endmodule

`timescale 1ns/10ps

module Adder(
    input [15:0] p,      // Input product
    input [23:0] psum,   // Partial sum
    output  reg [23:0] updated_psum  // Updated partial sum
);
    reg [23:0] prod;

always @(*) begin
    assign prod = {{8{p[15]}}, p};
    updated_psum <= prod + psum;
end

endmodule 
