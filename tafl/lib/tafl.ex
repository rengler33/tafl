defmodule Tafl do
  alias Tafl.Impl.Renderer
  alias Tafl.Type

  @spec new_game(String.t()) :: pid()
  # TODO maybe want to gracefully handle re-connecting here too (like when game already exists)
  def new_game(server_name) do
    {:ok, pid} = Tafl.Runtime.Application.start_game(server_name)
    pid
  end

  @spec add_player_one(String.t(), String.t()) :: Renderer.t()
  def add_player_one(server_name, id) do
    GenServer.call({:global, server_name}, {:add_player, :p1, id})
  end

  @spec add_player_two(String.t(), String.t()) :: Renderer.t()
  def add_player_two(server_name, id) do
    GenServer.call({:global, server_name}, {:add_player, :p2, id})
  end

  @spec make_move(String.t(), Type.rc_loc(), Type.rc_loc(), String.t()) :: Renderer.t()
  def make_move(server_name, old_loc, new_loc, player_id) do
    GenServer.call({:global, server_name}, {:make_move, old_loc, new_loc, player_id})
  end

  @spec show_board(String.t()) :: Renderer.t()
  def show_board(server_name) do
    GenServer.call({:global, server_name}, {:show_board})
  end
end
