defmodule Mix.Tasks.SecretEntrance do
  use Mix.Task

  def run(args) when args == ["1"] do
    SecretEntrance.count_dial_at_zero("lib/day1_secret_entrance/inputs/day1.txt")
    |> IO.puts()
  end

  def run(args) when args == ["2"] do
    SecretEntrance.count_dial_past_zero("lib/day1_secret_entrance/inputs/day1.txt")
    |> IO.puts()
  end
end
