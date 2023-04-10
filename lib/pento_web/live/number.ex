defmodule Number do
  @doc """
  iex(1)> list = [1,2,3]
  [1, 2, 3]
  iex(2)> total = Number.new("0")
  0
  iex(3)> reducer = &Number.add(&2, &1)
  #Function<41.3316493/2 in :erl_eval.expr/6>
  iex(4)> converter = &Number.to_string/1
  &Number.to_string/1
  iex(5)> Enum.reduce(list, total, reducer) |> converter.()
  "6"

  """
  def new(string), do: Integer.parse(string) |> elem(0)

  def add(number, addend), do: number + addend

  def to_string(number), do: Integer.to_string(number)
end
