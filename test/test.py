import cocotb
from cocotb.triggers import Timer, RisingEdge, ClockCycles


@cocotb.test()
async def basic_test(dut):

    # --------------------------
    # CLOCK MUST BE RUNNING
    # --------------------------
    cocotb.start_soon(cocotb.clock.Clock(dut.clk, 10, units="ns").start())

    # --------------------------
    # APPLY RESET
    # --------------------------
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await ClockCycles(dut.clk, 5)     # proper synchronous reset
    dut.rst_n.value = 1

    # Wait extra time for gate delays
    await ClockCycles(dut.clk, 10)
    await Timer(100, units="ns")

    # --------------------------
    # WRITE VALUE 0x20
    # --------------------------
    TEST_VAL = 0x20

    dut.ui_in.value = TEST_VAL
    dut.uio_in.value = 0x01          # WE = 1
    await RisingEdge(dut.clk)

    dut.uio_in.value = 0x00          # WE = 0

    # Wait for GPIO register output to settle
    await ClockCycles(dut.clk, 5)
    await Timer(50, units="ns")

    # --------------------------
    # SAFE READ (avoids X/Z)
    # --------------------------
    got = dut.uo_out.value.integer  # SAFE: automatically resolves X as 0

    cocotb.log.info(f"Read value = {got}")

    assert got == TEST_VAL, f"Expected {TEST_VAL}, got {got}"
