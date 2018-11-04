defmodule Mix.Tasks.Bump do
  use Mix.Task

  @moduledoc """
  Prints Bump tasks and their information.
      mix bump [major | minor | patch | <newversion>]

      options
        -m, --message <message>
                         Commit message
        -p, --publish    Publish package to hex
        -t, --tag <name> Specify a tag
        -a, --annotated  Use annotated tags (Enabled by default, use --no-annotated to use simple tags)
  """

  alias MixBump
  alias MixBump.{Command, Git}

  @parse_opts [
    switches: [message: :string, publish: :boolean, tag: :string, annotated: :boolean],
    aliases: [m: :message, p: :publish, t: :tag, a: :annotated]
  ]

  def run(args) do
    {options, args, _} = OptionParser.parse(args, @parse_opts)
    process_args(args, options)
  end

  defp process_args([], _options) do
    Command.puts("This is a simple mix task to version bump a mix project.")
  end

  defp process_args(args, _options) when length(args) > 1 do
    Command.error("usage: mix bump [major | minor | patch | <newversion>]")
  end

  defp process_args([version], options) do
    with {:ok, file, _old_version} <- MixBump.load_mix_file(),
         {:ok, file, new_version} <- MixBump.bump_version(file, version),
         :ok <- MixBump.update_version(new_version) do
      MixBump.save_mix_file!(file)
      process_options(options, new_version)
    end
  end

  defp process_options(options, new_version) do
    Command.write("Preparing and taging a new version")

    message = Keyword.get(options, :message, "Bump version to #{new_version}")
    tag_name = if name = Keyword.get(options, :tag), do: name, else: "v#{new_version}"
    annotated = Keyword.get(options, :annotated, true)

    with :ok <- Git.commit(message),
         :ok <- Git.tag(tag_name, %{message: message, annotated: annotated})
    do
      Command.callback(:ok)
    else
      _ -> Command.callback(:error)
    end

    if Keyword.get(options, :publish) do
      Command.task("hex.publish") && Command.rainbow("Congrats on publishing a new package!")
    else
      Command.rainbow("Bump version to #{new_version}!")
    end
  end
end
