defmodule MixBump.Command.Adapter do
  @moduledoc """
  A small adapter for the execution of shell commands.
  """

  @callback execute(String.t) :: :ok | :error

  @callback task(String.t) :: any()
end


