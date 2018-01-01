defmodule MixBump.Git do
  alias MixBump.Command

  def commit(message) do
    Command.execute("git commit -o mix.exs -m '#{message}' -q")
  end

  def tag(name) do
    Command.execute("git tag #{name}")
  end
end
