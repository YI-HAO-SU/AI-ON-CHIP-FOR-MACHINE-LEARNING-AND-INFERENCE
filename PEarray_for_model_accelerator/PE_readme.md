# PEarray_for_model_accelerator

## 1. Describe PE work.
   - IDLE state
     
       In this state, the data will be judged if it is ready or not. If it is ready, it will
       enter the DataIn state, otherwise, it will proceed to the next judgment which
       will check whether ready to do convolution. If it is ready, it will enter the
       Convolution state, otherwise it will be in the IDLE loop.
       If the ipsum is ready, the reg will save the ipsum then ready to use.
     
   - DataIn state
     
       In this state, data will be judged whether the data be loaded in reg. If starts,
       it will check the next data has already loaded in reg then get into
       Convolution state, otherwise it will stay in the DataIn loop. If not, it will check
       if the convolution is already started or ready to start. The former will check whether the
       data is valid or not, valid data will be sent to the Convolution state, and invalid
       data will stay in the DataIn state. The latter will check whether the next
       data has already loaded in reg and then get into the Convolution state, if not, it will
       state in the DataIn state.
       Here, it will make sure every data is loaded in the correct reg and wait
       for the convolution state.
     
   - Convolution state
   
      In this state, it will first check whether the PE working now is the bottom one or not.
      If it is, it should be processed as an exception. If not, it will check whether the
      convolution done, and the result is already be saved. If both conditions
      achieved, it would get into the Accumulation state. If the former is achieved
      but the latter is not, it will get back to the IDLE state. If both conditions are not
      achieved, meaning the convolution has not been done, would stay in this state.
      Here, it will do the MAC operation to do 1D matrix multiplication and
      return the convolution done signal.
    
   - Accumulation & PsumOut state
     
       In these two states, it will check whether the accumulation is done or is
       bottom PE or not. Achieving both conditions will back to the IDLE state,
       otherwise will stay in the same state.


## 2. Explain the result by waveform.

![圖片](https://github.com/YeeHaoSu/AI-ON-CHIP-FOR-MACHINE-LEARNING-AND-INFERENCE/assets/90921571/020fbbd2-d78e-4b0b-9bf6-5581bb2a8ef9)

![圖片](https://github.com/YeeHaoSu/AI-ON-CHIP-FOR-MACHINE-LEARNING-AND-INFERENCE/assets/90921571/813bd395-3240-40d9-bcb3-8098df289e93)

Most of my answer is 0, I think that is due to the initialization part having some
error, which I did not consider in every situation.

## 3. From fig(a) and fig(b), please try to explain 

![圖片](https://github.com/YeeHaoSu/AI-ON-CHIP-FOR-MACHINE-LEARNING-AND-INFERENCE/assets/90921571/6a858519-2730-406c-9f94-a56a56c40d79)


In fig(a), we can observe that Filter1 be reused to do multiplications, which
wastes memory access and decreases efficiency. To solve the problem, the
ifmaps which correspond to the reused filter can concatenate in the same
dimension and then be multiplied by the origin filter where the result Psum can
be derived in concatenation. As a result, the memory can reduce one time
to access the reused filter.

![圖片](https://github.com/YeeHaoSu/AI-ON-CHIP-FOR-MACHINE-LEARNING-AND-INFERENCE/assets/90921571/d4b8e0d1-e6d6-440f-bbff-dcf269b3812f)

In fig(b), the Ifmap is reused. To solve the problem, the filter can
be concatenated then rearrange the new filter in intervals which can
generated the desired Psum also in intervals; however, memory can reduce
to access Ifmap one time.

![圖片](https://github.com/YeeHaoSu/AI-ON-CHIP-FOR-MACHINE-LEARNING-AND-INFERENCE/assets/90921571/ba1f15a1-6cba-4835-9bee-cccb6e89c800)

