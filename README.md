# Synchronous-FIFO-using-SVA
Synchronous FIFO Design & Verification
Overview
This project implements a Synchronous First-In-First-Out (FIFO) memory buffer using SystemVerilog and verifies its correctness using SystemVerilog Assertions (SVA).
A synchronous FIFO stores data in sequential order and operates under a single clock domain for both read and write operations. It is widely used in digital systems for data buffering, flow control, and clock domain synchronization when clocks are the same.

Design Features
Single Clock Domain for read and write operations.

Configurable FIFO Depth and Data Width using parameters.

Status Flags:

full – Indicates FIFO is full (no further writes possible).

empty – Indicates FIFO is empty (no further reads possible).

almost_full and almost_empty – Optional thresholds for flow control.

Synchronous Reset support.

Pointer-based Implementation for efficient read/write tracking.

Verification Approach
Testbench:

Self-checking testbench in SystemVerilog.

Stimulus generation for different scenarios (normal operation, overflow, underflow).

SystemVerilog Assertions (SVA):

Checked for FIFO protocol correctness.

Assertions for no read when empty and no write when full.

Pointer update and flag correctness validation.

Functional Coverage to ensure all corner cases are tested.

Results
All SVA checks passed, confirming the FIFO meets the design specification.

Achieved 100% functional coverage for defined scenarios.
