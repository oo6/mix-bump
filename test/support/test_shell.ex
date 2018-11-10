defmodule MixBump.Command.TestShell do
  @moduledoc """
  A `MixBump.Command` adapter that sends commands to stdout, enabling them to 
  be captured in tests
  """
  @behaviour MixBump.Command.Adapter

  @impl true
  def execute(message) do
    IO.puts(message)
    :ok
  end

  @impl true
  def task(message) do
    IO.puts(message)
    :ok
  end
end
