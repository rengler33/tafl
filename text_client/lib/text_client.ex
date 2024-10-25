defmodule TextClient do
  @spec start(String.t()) :: :ok
  def start(server_name) do
    TextClient.Runtime.RemoteTafl.connect(server_name)
    TextClient.Impl.Play.start(server_name)
  end

  def start(hostname, server_name) do
    TextClient.Runtime.RemoteTafl.connect(hostname, server_name)
    TextClient.Impl.Play.start(server_name)
  end
end
