defmodule TextClient.Runtime.RemoteTafl do
  # TODO update this??
  @remote_server :"tafl@rubs-lap"

  def connect() do
    :rpc.call(@remote_server, Tafl, :new_game, [])
  end
end
