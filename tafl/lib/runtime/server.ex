defmodule Tafl.Runtime.Server do
  alias Tafl.Impl.Game

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new()}
  end

  def handle_call({:make_move, old_loc, new_loc}, _from, game) do
    updated_game = Game.make_move(game, old_loc, new_loc)
    {:reply, updated_game, updated_game}
  end

  def handle_cast({:show_board}, game) do
    # TODO this is not ideal, need to eventually build text client
    Game.print(game)
    {:noreply, game}
  end
end
