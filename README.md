# ASCON-128 Cryptographic Core (SystemVerilog)

This project is a hardware implementation of the **ASCON-128** authenticated encryption and hashing algorithm, written entirely in **SystemVerilog**. ASCON is a lightweight cryptographic algorithm selected as the primary recommendation for lightweight authenticated encryption by the [NIST Lightweight Cryptography Standardization Process](https://csrc.nist.gov/Projects/lightweight-cryptography).

---

## 🔐 What is ASCON-128?

ASCON-128 is part of the ASCON family of lightweight cryptographic algorithms designed for constrained environments such as IoT devices and embedded systems. It offers:

- **Authenticated encryption with associated data (AEAD)**
- **128-bit key**
- **128-bit nonce**
- **128-bit tag**

ASCON prioritizes **performance**, **simplicity**, and **resistance to side-channel attacks**, making it suitable for both hardware and software implementations.

---

## 🧠 Project Description

This repository includes a complete hardware design of the **ASCON-128 AEAD** core, implemented in **SystemVerilog**.

### ✅ Implemented Features

- ASCON permutation core (based on the 12-round `p12` permutation)
- AEAD encryption and decryption modes
- Key and nonce handling
- Tag generation and verification
- Modular and synthesizable SystemVerilog design
- Testbenches for core modules

---

## 🛠️ Tools Used

- **Language**: SystemVerilog (IEEE 1800)
- **Simulation**: ModelSim / Verilator / Icarus Verilog

