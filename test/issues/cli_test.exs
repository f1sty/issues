defmodule IssuesCLITest do
  use ExUnit.Case
  import Issues.CLI, only: [parse_args: 1]
  doctest Issues

  test ":help returned by parser given an -h or --help options" do
    assert parse_args(["-h", "somearg"]) == :help
    assert parse_args(["--help", "somearg"]) == :help
  end

  test "three args given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "two args given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
