import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, ClockCycles


@cocotb.test()
async def basic_test(dut):

    # Start clock (10 ns period)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Reset
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    await ClockCycles(dut.clk, 10)

    # Write 0x20
    TEST_VAL = 0x20

    dut.ui_in.value = TEST_VAL
    dut.uio_in.value = 0x01    # write enable
    await RisingEdge(dut.clk)
    dut.uio_in.value = 0x00

    # Allow time for gpio_reg to update
    await ClockCycles(dut.clk, 5)
    await Timer(20, units="ns")

    # Read output safely
    got = dut.uo_out.value.integer

    cocotb.log.info(f"GPIO Read = {got}")

    assert got == TEST_VAL, f"Expected {TEST_VAL}, got {got}"
