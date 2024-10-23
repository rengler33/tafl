defmodule Tafl.Runtime.Server do
  alias Tafl.Impl.{Game, Renderer}

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Game.new()}
  end

  def handle_call({:make_move, old_loc, new_loc, player_id}, _from, game) do
    updated_game = Game.make_move(game, old_loc, new_loc, player_id)
    {:reply, Renderer.render_game(updated_game), updated_game}
  end

  def handle_call({:show_board}, _from, game) do
    render = Renderer.render_game(game)
    {:reply, render, game}
  end

  def handle_call({:add_player, indicator, id}, _from, game) do
    updated_game = Game.set_player(game, indicator, id)
    {:reply, Renderer.render_game(updated_game), updated_game}
  end

  def handle_call({:game}, _from, game) do
    # for debugging assistance
    {:reply, game, game}
  end
end
