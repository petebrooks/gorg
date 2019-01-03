defmodule Gorg.CLI do
  def main(argv) do
    argv
    |> parse_argv
    |> run
  end

  def run({:help}) do
    IO.puts("sorry")
  end

  def run({:init, [name]}) do
    if File.exists?("./.gorg/config") && no?("Overwrite existing project?") do
      log("Init abandoned.")
    else
      json = Poison.encode!(%{name: name})

      case File.mkdir("./.gorg") do
        :ok -> nil
        {:error, :eexist} -> nil
        {:error, error} -> log("Unknown error '#{error}'.")
      end

      case File.write("./.gorg/config", json, [:utf8]) do
        :ok -> log("Initialized project '#{name}'.")
        {:error, :eexist} -> log("Project already exists.")
        {:error, error} -> log("Unknown error '#{error}'.")
      end
    end
  end

  defp parse_argv(argv) do
    parsed =
      OptionParser.parse(
        argv,
        strict: [help: :boolean],
        aliases: [h: :help]
      )

    case parsed do
      {[help: true], _, _} -> {:help}
      {_, [cmd | args], _} -> {String.to_atom(cmd), args}
      {_, _, _} -> {:help}
    end
  end

  defp log(nil), do: nil

  defp log(message) do
    IO.puts(message)
  end

  # TODO: Move to another module/library.
  defp yes?(message) do
    Enum.member?(["yes", "y"], ask(message))
  end

  defp no?(message) do
    Enum.member?(["no", "n"], ask(message))
  end

  defp ask(message) do
    format(IO.gets("#{message} "))
  end

  @spec format(String.t) :: String.t
  defp format(input) do
    String.downcase(String.replace(input, "\n", ""))
  end
end
