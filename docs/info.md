## How it works

This design implements a small digital peripheral consisting of three blocks:

### 1. GPIO Register (8-bit)
- The input bus `ui_in[7:0]` provides an 8-bit value.
- When `uio_in[0]` (write enable) is high during a clock edge, this value is written into an internal register.
- The stored value is always visible on the output bus `uo_out[7:0]`.

### 2. PWM Generator
- The PWM duty cycle is directly controlled by the stored GPIO value.
- A higher register value increases the ON-time of the waveform.
- The PWM output is routed to `uio[7]`.

### 3. 7-Segment Display Decoder
- The lower 4 bits of the GPIO register (`gpio_out[3:0]`) select which hexadecimal digit to display.
- A standard 7-segment pattern is generated.
- Display outputs are mapped to `uio[6:1]`.

All outputs are continuously active when the design is enabled.  
No internal tri-state or latches are used — fully synthesizable for TinyTapeout Sky130 flow.

---

## How to test

### **Simulation**
1. Go to the `test/` directory.
2. Run:
   ```bash
   make
