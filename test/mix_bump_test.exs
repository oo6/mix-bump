defmodule MixBumpTest do
  use ExUnit.Case

  test "bump_version(major) resets minor and patch to 0" do
    {:ok, _file, version} =
      "version: \"0.1.2\""
      |> MixBump.bump_version("major")

    assert version === "1.0.0"
  end

  test "bump_version(minor) resets patch to 0" do
    {:ok, _file, version} =
      "version: \"0.1.2\""
      |> MixBump.bump_version("minor")

    assert version === "0.2.0"
  end

  test "bump_version(patch) does not affect major and minor" do
    {:ok, _file, version} =
      "version: \"0.1.2\""
      |> MixBump.bump_version("patch")

    assert version === "0.1.3"
  end
end
