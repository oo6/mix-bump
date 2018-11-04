defmodule MixBump.Command.Shell do
  @moduledoc """
  A `MixBump.Command` adapter that sends commands to the shell.
  """
  @behaviour MixBump.Command.Adapter

  @impl true
  def execute(command) do
    if Mix.Shell.IO.cmd(command) == 0, do: :ok, else: :error
  end

  @impl true
  def task(task) do
    Mix.Task.run(task)
  end

end
