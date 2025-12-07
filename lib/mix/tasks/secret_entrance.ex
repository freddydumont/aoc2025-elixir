defmodule Mix.Tasks.SecretEntrance do
  use Mix.Task

  def run(_args) do
    SecretEntrance.count_dial_at_zero("lib/day1_secret_entrance/inputs/day1.txt")
    |> IO.puts()
  end
end
