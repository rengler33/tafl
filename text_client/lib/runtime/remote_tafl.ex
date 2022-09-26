defmodule TextClient.Runtime.RemoteTafl do
  @remote_server_name "tafl"

  def connect() do
    connect(get_local_host_name())
  end

  def connect(hostname) do
    :rpc.call(hostname, Tafl, :new_game, [])
  end

  defp get_local_host_name() do
    {:ok, hostname} = :inet.gethostname()

    (@remote_server_name <> "@" <> List.to_string(hostname))
    |> String.to_atom()
  end
end
