# Floating-point-MAC-verilog

In this project, 
I implemented the modified Booth algorithm to design the 8-bit unsigned multiplier. 
It is an optimization of Booth's multiplication algorithm that reduces the number of additions required to perform the multiplication. 
The algorithm takes advantage of the patterns that occur when a multiplier is shifted in binary representation.

Here are the steps to perform multiplication:
1. Convert the multiplier and the multiplicand to a signed binary representation, with the same number of bits.

2. Follow the rules.
    1 ← 0 => −1
   
    0 ← 0 => 0
   
    1 ← 1 => 0
   
    0 ← 1 => +1
   
    𝑒𝑖 𝑐𝑜𝑛𝑠𝑖𝑑𝑒𝑟 𝑏𝑖 & 𝑏𝑖−1
   
    𝑒𝑖+1 𝑐𝑜𝑛𝑠𝑖𝑑𝑒𝑟 𝑏𝑖+1 & 𝑏𝑖
   
    𝑤 = 𝑒𝑖+1 ∗ 21 + 𝑒𝑖 ∗ 20

   Then prepare the table as below:
   
      | 𝑏𝑖+1 | 𝑏𝑖 | 𝑏𝑖−1 | 𝑒𝑖+1 | 𝑒𝑖 | 𝑤  |
      | ------ | ---- | ------ | ------ | ---- | --- |
      | 0      | 0    | 0      | 0      | 0    | 0   |
      | 0      | 0    | 1      | 0      | +1   | 1   |
      | 0      | 1    | 0      | +1     | \-1  | 1   |
      | 0      | 1    | 1      | +1     | 0    | 2   |
      | 1      | 0    | 0      | \-1    | 0    | \-2 |
      | 1      | 0    | 1      | \-1    | +1   | \-1 |
      | 1      | 1    | 0      | 0      | \-1  | \-1 |
      | 1      | 1    | 1      | 0      | 0    | 0   |

3. Add a 0 at the end of the multiplier, and fetch 3 bits at a time, with a gap of
    2 bits between each set, to perform a check.
   
4. Add a sign extension to the front of these products. Note that when the
    multiplicand is -128, it may cause conflicts due to its representation in two's
    complement. Therefore, it needs to be handled separately.

5. Accumulate the products then we can get the answer.


After we get the multiplied product, we should make a sign extension to 24 bits
which corresponds to the psum input then the result can be derived.

⚫ Waveform explanation with two examples

1. Ifmap = 90, filter = 1, psum = - 5592406 , updated_psum = - 5592316

![圖片](https://github.com/YeeHaoSu/AI-ON-CHIP-FOR-MACHINE-LEARNING-AND-INFERENCE/assets/90921571/35e44d29-16fd-427f-ba84-59c21eaf1eb1)


2. Ifmap = -90, filter = - 1 , psum = 5592405 , updated_psum = 5592395

![圖片](https://github.com/YeeHaoSu/AI-ON-CHIP-FOR-MACHINE-LEARNING-AND-INFERENCE/assets/90921571/f569e981-6d1c-444e-82d0-6a8aefa7c5fa)

⚫ Introduce the function of each module.

I designed three modules in this LAB, including Booth_Mux, Adder, and MAC.
Booth_Mux is 8 bits modified Booth unsigned multiplier whose input are two
8bits unsigned number and output is a 16bits product,
Adder is a 24 bits adder whose input is a 16bits product and a 24bits partial sum,
and the output is a 24-bit updated_psum.
MAC uses the two modules to complete the LAB 3 required.
