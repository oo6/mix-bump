defmodule Mix.Tasks.BumpTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Mix.Tasks.Bump

  @version Mix.Project.config()[:version]

  # capturing IO, rather than running the command. 
  # Commands that shell out end in a new line, so we can check the command end
  # by including it.

  test "bump with annotated tags by default" do
    assert capture_io(fn ->
             Bump.run([@version])
           end) =~ ~s(git tag -a 'v#{@version}' -m 'Bump version to #{@version}'\n)
  end

  test "bump uses simple tags when specified" do
    assert capture_io(fn ->
             Bump.run([@version, "--no-annotated"])
           end) =~ ~s(git tag 'v#{@version}'\n)
  end

  test "bump uses a custom tag value when specified" do
    assert capture_io(fn ->
             Bump.run([@version, "--no-annotated", "--tag", "custom"])
           end) =~ ~s(git tag 'custom'\n)
  end

  test "bump uses a custom commit message when specified" do
    assert capture_io(fn ->
             Bump.run([@version, "--message", "custom"])
           end) =~ ~s(git commit -o mix.exs -m 'custom' -q\n)
  end

  test "bump commits, then tags" do
    assert capture_io(fn ->
             Bump.run([@version])
           end) =~ ~s(git commit -o mix.exs -m 'Bump version to #{@version}' -q\ngit tag)
  end

  test "bump publishes when specified" do
    assert capture_io(fn ->
             Bump.run([@version, "--publish"])
           end) =~ ~s(hex.publish)
  end
end
