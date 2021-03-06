defmodule MixBump.Command do
  @adapter Application.get_env(:mix_bump, :command_adapter, MixBump.Command.Shell)

  defdelegate execute(message), to: @adapter

  defdelegate task(message), to: @adapter

  def write(message), do: IO.write(message)

  def puts(message), do: IO.puts(message)

  def error(message) do
    Mix.Shell.IO.error(message)
    System.halt(1)
  end

  def callback(:ok), do: [:green, " \u2713"] |> IO.ANSI.format() |> IO.puts()

  def callback(:error) do
    [:red, " \u2717"] |> IO.ANSI.format() |> IO.puts()
    System.halt(1)
  end

  def rainbow(text) do
    colors = [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white]

    text
    |> String.split("")
    |> Enum.map(fn char -> [Enum.random(colors), char] end)
    |> IO.ANSI.format()
    |> IO.puts()
  end
end
