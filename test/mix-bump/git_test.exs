defmodule MixBump.GitTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias MixBump.Git

  test "Git.commit creates a commit with only the mix.exs file, using the provided message" do
    assert capture_io(fn ->
             Git.commit("IT IS DONE!")
           end) =~ ~s(git commit -o mix.exs -m 'IT IS DONE!' -q)
  end

  test "Git.tag will create annotated tags when annotated tagging is enabled" do
    assert capture_io(fn ->
             Git.tag("v1.0.0", %{message: "first release", annotated: true})
           end) =~ ~s(git tag -a 'v1.0.0' -m 'first release')
  end

  test "Git.tag will create simple tags when annotated tagging is disabled" do
    assert capture_io(fn ->
             Git.tag("v1.0.0", %{message: "first release", annotated: false})
           end) =~ ~s(git tag 'v1.0.0')
  end
end
