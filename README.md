# PFC_ROMAN_CARDENAS_RODRIGUEZ

This repository contains all the VHDL files developed during my BSc thesis.

The current structure of the respository is:

- EARTH ROTATIONAL DELAY: Directory which contains different designs that handle the effect of the Earth Rotational Delay.
  - Resampler1: Based on 'Resampler_sinPipeline'. Uses several multiplexors in order to operate satisfactorily the input samples considering the effect of the Earth Rotational Delay, with maximum frequency of 142 MHz.
  - Resampler1-conPipeline: Follows the same structure of 'Resampler1' adding several stages of pipeline to increase the maximum frequency up to 369 MHz.
  - Resampler2: Based on 'Resampler_sinPipeline'. The way it determines the actual phase required to calculate propperly the output samples takes into account the Earth Rotational Delay, with maximum frequency of 123 MHz.
  - Resampler2-conPipeline: Follows the same structure of 'Resampler2' adding several stages of pipeline to increase the maximum frequency up to 381 MHz.

  - Resampler-MUX: The resampler calculates 8 samplessimultaneously, increasing the working frequency up to 800 MHz. This directory contains only the "slow part", able to work at 132 MHz. If finally the design requires a high working frequency, a FIFO system must be designed for it in order to provide to the slow system 15 consecutive samples in a row.

  - Resampler3: First approach to a Re-Sampler able to do both up and down sampling. The ISE project contains two different modules that tackles the objective in different ways.
    - top1: One only clock domain. Not all the output values are valid. This module is able to work at 379.571 MHz
    - top2: Two clock domains. All the output values are valid. This module is able to work at 379.571 MHz (The fastest module) and 319.662 MHz(The slowest one). In order to get efficiency on its performance the frequency relation must be less than 1.187413
- Resampler_IP: This project contains a module able to do up and down sampling. Now FOE and WR_CONT are input signals of the design, in order to make possible a behaviour change on the fly. The maximum working frequency is 365 MHz.
- GeneratedIP: This directory will contain all the generated IPs
  - ReSampler: IP module that emulates Resampler_IP behaviour. It does not support AXI4 interface.
  - etsit.upm.es_user_ResamplerAXI4_1.0 : zip file, it contains the IP module that supports AXI4 Interface.
