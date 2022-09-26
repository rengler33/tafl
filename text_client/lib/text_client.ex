defmodule TextClient do
  @spec start() :: :ok
  def start do
    TextClient.Runtime.RemoteTafl.connect()
    |> TextClient.Impl.Play.start()
  end

  def start(hostname) do
    TextClient.Runtime.RemoteTafl.connect(hostname)
    |> TextClient.Impl.Play.start()
  end
end
