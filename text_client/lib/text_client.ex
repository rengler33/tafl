defmodule TextClient do
  @spec start() :: :ok
  def start do
    TextClient.Runtime.RemoteTafl.connect()
    |> TextClient.Impl.Play.start()
  end
end
