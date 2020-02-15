defmodule MixBump.Git do
  alias MixBump.Command

  @doc """
  Commits the modified mix file, with a custom message. You can specify this
  message with `--message` or `-m` when running the CLI. Default message is
  `Bump version to NEW_VERSION`.
  """
  @spec commit(String.t()) :: :ok | :error
  def commit(message) do
    Command.execute("git commit -o mix.exs -m '#{message}' -q")
  end

  @doc """
  Tags the release. In the CLI, the flags `--annotated` and `--no-annotated`
  determines if tagging will be simple, or annotated. Defaults to annotated.
  """
  @type tag_options :: map
  @type tag_name :: String.t()

  @spec tag(tag_name, tag_options) :: :ok | :error
  def tag(name, options \\ %{})

  def tag(name, %{message: message, annotated: true}) do
    Command.execute("git tag -a '#{name}' -m '#{message}'")
  end

  def tag(name, _options) do
    Command.execute("git tag '#{name}'")
  end
end
