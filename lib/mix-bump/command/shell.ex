defmodule MixBump.Command.Shell do
  @moduledoc """
  A `MixBump.Command` adapter that sends commands to the shell.
  """
  @behaviour MixBump.Command.Adapter

  @doc """
  Executes the given command.
  """
  @impl true
  def execute(command) do
    if Mix.Shell.IO.cmd(command) == 0, do: :ok, else: :error
  end

  @doc """
  Runs a `task`.
  """
  @impl true
  def task(task) do
    Mix.Task.run(task)
  end
end
