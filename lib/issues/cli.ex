defmodule Issues.CLI do
  @moduledoc false
  @default_count 4

  def run(argv) do
    argv |> parse_args |> process 
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response |> sort |> Enum.take(count)
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    IO.puts "Error fetching from GitHub: #{Map.get(error, "message", "unknown")}"
    System.halt(2)
  end

  def sort(items) do
    Enum.sort(items, fn a, b -> a["created_at"] <= b["created_at"] end)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, String.to_integer(count)}
      {_, [user, project], _} -> {user, project, @default_count}
      _ -> :help
    end
  end
end
