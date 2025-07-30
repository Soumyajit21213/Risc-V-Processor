# 🧠 RISC-V 32-bit Processor (5-Stage Pipelined Architecture)

This project is a Verilog-based implementation of a **32-bit RISC-V processor** with a 5-stage pipelined architecture. It supports a subset of RISC-V instructions and simulates instruction execution with register updates.

## 🚀 Features

- ✅ **5-Stage Pipeline**: IF, ID, EX, MEM, WB
- ✅ **Register File**: 32 general-purpose registers
- ✅ **Instruction Support**:
  - R-type: `add`, `sub`, `and`, `or`
  - I-type: `addi`, `lw`
  - S-type: `sw`
  - Branch: `beq`
- ✅ **Forwarding Unit** to reduce data hazards
- ✅ **Hazard Detection Unit** for load-use stalls
- ✅ Minimal control hazard handling for branches
- ✅ Verilog testbench provided for validation

## 📂 Project Structure

```
🔌 code.v             # Main RISC-V processor implementation
🔌 testbench1.v       # Testbench to simulate instruction execution
🔌 README.md          # This file
```

## 🧪 Sample Output

Sample register output from simulation:

```
R[00000000] : 2801000a
R[00000001] : 28020014
R[00000002] : 28030019
R[00000003] : 0ce77800
R[00000004] : 0ce77800
R[00000005] : 00222000
R[00000006] : 0ce77800
R[00000007] : 00832800
```

## 📌 What I Learned

- Designed and debugged pipelined architectures
- Gained deeper insight into Verilog RTL modeling
- Understood instruction formats and control signal generation
- Tackled hazards using forwarding and stalling mechanisms

## 🛠️ Tools Used

- Verilog HDL
- Icarus Verilog / ModelSim (Simulation)
- GTKWave (Optional - Waveform Analysis)
- Visual Studio Code (Editor)

## 👨‍💻 Author

**Soumyajit Samanta**  
Undergraduate @ IIT Dhanbad  
📬 [Connect with me on LinkedIn](https://www.linkedin.com/in/soumyajit-samanta/)  
📂 [GitHub Profile](https://github.com/Soumyajit21213)

---

⭐ If you found this interesting, feel free to star the repo and connect!
