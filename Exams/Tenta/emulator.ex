defmodule Emulator do

  def test() do
    instructions = {

      {:addi,  1,  0, 10},
      {:addi,  3,  0,  1},
      {:out,   3},
      {:addi,  1,  1, -1},
      {:addi,  4,  3,  0},
      {:add,   3,  2,  3},
      {:out,   3},
      {:beq,   1,  0,  3},
      {:addi,  2,  4,  0},
      {:beq,   0,  0, -6},
      {:halt}
  }

    #initial values
    registers = {0, 0, 0, 0, 0, 0}
    pc = 0
    outputs = {[0], [0], [0], [0], [0], [0]}
    next_instr(instructions, registers, pc, outputs)

  end

  def get_reg(registers, index) do
    elem(registers, index)
  end

  def update_reg(registers, index, new_val) do
    registers = put_elem(registers, index, new_val)
  end


  def next_instr(instructions, registers, pc, outputs) do
    instr = get_reg(instructions, pc)
    emulate(instructions, instr, registers, pc, outputs)
  end

  def emulate(instructions, {:addi, d, x, const}, registers, pc, outputs) do
    x_value = get_reg(registers, x)

    d_value = x_value + const
    updated = update_reg(registers, d, d_value) #update d value

    #save latest value of output in outputlist
    outputlst = get_reg(outputs, d)
    updated_outputs = update_reg(outputs, d, [d_value|outputlst])

    next_instr(instructions, updated, pc+1, updated_outputs)
  end

  def emulate(instructions ,{:add, d, x, y}, registers, pc, outputs) do
    x_val = get_reg(registers, x)
    y_val = get_reg(registers, y)

    d_value = x_val + y_val
    updated = update_reg(registers, d, d_value) #update d value

    outputlst = get_reg(outputs, d)
    updated_outputs = update_reg(outputs, d, [d_value|outputlst])

    next_instr(instructions, updated, pc+1, updated_outputs)
  end

  def emulate(instructions, {:out, x}, registers, pc, outputs) do
    #returns latest output
    output_val = get_reg(registers, x)
    IO.puts("Outputvalue for register #{x} is #{output_val}")
    next_instr(instructions, registers, pc+1, outputs)
  end

  def emulate(instructions, {:beq, x, y, offset}, registers, pc, output)  do

    x_val = get_reg(registers, x)
    y_val = get_reg(registers, y)

    if x_val == y_val do
      pc = pc + offset
      next_instr(instructions, registers, pc, output)
    else
      next_instr(instructions, registers, pc+1, output)
    end

  end

  def emulate(_, {:halt}, registers, _, outputs) do
    {registers, outputs}
  end

end
