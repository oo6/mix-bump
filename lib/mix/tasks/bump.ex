defmodule Mix.Tasks.Bump do
  use Mix.Task

  @moduledoc """
  Prints Bump tasks and their information.
      mix bump [major | minor | patch | <newversion>]

      options
        -p, --publish    Publish package to hex
  """

  @version_regex ~r/version:\s*"(\d+).(\d+).(\d+)"/

  def run(args) do
    {options, args, _} = OptionParser.parse(args, switches: [publish: :boolean], aliases: [p: :publish])
    process_args(args, options)
  end

  defp process_args([], _options) do
    Mix.shell.info "This is a simple mix task to version bump a mix project."
  end

  defp process_args(args, _options) when length(args) > 1 do
    Mix.shell.error "usage: mix bump [major | minor | patch | <newversion>]"
  end

  defp process_args([version], options) do
    with {:ok, file} <- load_mix_file("mix.exs"),
         {:ok, file} <- bump_version(file, version),
         {:ok, _path} <- save_mix_file(file, "mix.exs")
    do
      if Keyword.get(options, :publish) do
        Mix.Task.run("hex.publish")
        "Congrats on publishing a new package!"
        |> rainbow
        |> Mix.shell.info
      else
        "Bump version to " <> get_version(file)
        |> rainbow
        |> Mix.shell.info
      end
    end
  end

  defp load_mix_file(path) do
    if File.exists?(path) do
      {:ok, File.read!(path)}
    else
      Mix.shell.error "No mix.exs file found"
    end
  end

  defp bump_version(file, "major") do
    file = Regex.replace(@version_regex, file, fn _, major, minor, patch ->
      "version: \"#{String.to_integer(major) + 1}.#{minor}.#{patch}\""
    end)

    {:ok, file}
  end

  defp bump_version(file, "minor") do
    file = Regex.replace(@version_regex, file, fn _, major, minor, patch ->
      "version: \"#{major}.#{String.to_integer(minor) + 1}.#{patch}\""
    end)

    {:ok, file}
  end

  defp bump_version(file, "patch") do
    file = Regex.replace(@version_regex, file, fn _, major, minor, patch ->
      "version: \"#{major}.#{minor}.#{String.to_integer(patch) + 1}\""
    end)

    {:ok, file}
  end

  defp bump_version(file, version) do
    replacement = "version: \"#{version}\""

    if Regex.match?(@version_regex, replacement) do
      {:ok, Regex.replace(@version_regex, file, replacement)}
    else
      Mix.shell.error "Invalid version: #{version}"
    end
  end

  defp save_mix_file(file, path), do: {:ok, File.write!(path, file)}

  defp get_version(file) do
    case Regex.run(@version_regex, file) do
      nil ->
        Mix.shell.error "No version config found"
      result ->
        result |> hd |> String.split |> Enum.at(1)
    end
  end

  defp rainbow(text) when is_binary(text) do
    colors = [:black, :red, :green, :yellow, :blue, :magenta, :cyan, :white]

    text
    |> String.split("")
    |> Enum.map(fn char -> [Enum.random(colors), char] end)
    |> IO.ANSI.format
  end

  defp rainbow(text), do: text
end
