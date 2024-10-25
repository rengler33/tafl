defmodule TextClient.Runtime.RemoteTafl do
  @remote_server_name "tafl"

  def connect(server_name) do
    connect(get_local_host_name(), server_name)
  end

  def connect(hostname, server_name) do
    new_game(hostname, server_name)
    :global.sync()
  end

  def new_game(hostname, server_name) do
    # rpc.call does not crash the process if game already exists b/c it catches error
    :rpc.call(hostname, Tafl, :new_game, [server_name])
  end

  defp get_local_host_name() do
    {:ok, hostname} = :inet.gethostname()

    (@remote_server_name <> "@" <> List.to_string(hostname))
    |> String.to_atom()
    |> IO.inspect()
  end
end
