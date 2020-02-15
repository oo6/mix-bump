defmodule MixBump do
  alias MixBump.Command

  @version_regex ~r/version:\s*"(\d+).(\d+).(\d+)"/

  def load_mix_file() do
    if File.exists?("mix.exs") do
      file = File.read!("mix.exs")
      {:ok, file, get_version!(file)}
    else
      Command.error("No mix.exs file found")
    end
  end

  def bump_version(file, "major") do
    file =
      Regex.replace(@version_regex, file, fn _, major, _minor, _patch ->
        "version: \"#{String.to_integer(major) + 1}.0.0\""
      end)

    {:ok, file, get_version!(file)}
  end

  def bump_version(file, "minor") do
    file =
      Regex.replace(@version_regex, file, fn _, major, minor, _patch ->
        "version: \"#{major}.#{String.to_integer(minor) + 1}.0\""
      end)

    {:ok, file, get_version!(file)}
  end

  def bump_version(file, "patch") do
    file =
      Regex.replace(@version_regex, file, fn _, major, minor, patch ->
        "version: \"#{major}.#{minor}.#{String.to_integer(patch) + 1}\""
      end)

    {:ok, file, get_version!(file)}
  end

  def bump_version(file, version) do
    replacement = "version: \"#{version}\""

    if Regex.match?(@version_regex, replacement) do
      {:ok, Regex.replace(@version_regex, file, replacement), version}
    else
      Command.error("Invalid version: #{version}")
    end
  end

  def save_mix_file!(file), do: File.write!("mix.exs", file)

  def update_version(new_version) do
    GenServer.call(
      Mix.ProjectStack,
      {:update_stack,
       fn [%{config: config}] = stack ->
         config = Keyword.put(config, :version, new_version)
         {:ok, [%{hd(stack) | config: config}]}
       end}
    )
  end

  defp get_version!(file) do
    case Regex.run(@version_regex, file) do
      nil ->
        Command.error("No version config found")

      result ->
        result |> tl |> Enum.join(".")
    end
  end
end
