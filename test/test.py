import cocotb
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def basic_test(dut):
    dut.rst_n.value = 0
    await Timer(20, units="ns")
    dut.rst_n.value = 1

    # Write 0x20
    dut.ui_in.value = 0x20
    dut.uio_in.value = 0x01
    await RisingEdge(dut.clk)
    dut.uio_in.value = 0x00

    await Timer(20, units="ns")

    got = int(dut.uo_out.value)
    assert got == 0x20, f"Expected 0x20 but got {got}"
