defmodule Tafl do
  alias Tafl.Impl.Renderer
  alias Tafl.Type

  @spec new_game() :: pid()
  def new_game() do
    {:ok, pid} = Tafl.Runtime.Application.start_game()
    pid
  end

  def add_player_one(game_pid, id) do
    GenServer.call(game_pid, {:add_player, :p1, id})
  end

  def add_player_two(game_pid, id) do
    GenServer.call(game_pid, {:add_player, :p2, id})
  end

  @spec make_move(pid(), Type.rc_loc(), Type.rc_loc(), String.t()) :: Renderer.t()
  def make_move(game_pid, old_loc, new_loc, player_id) do
    GenServer.call(game_pid, {:make_move, old_loc, new_loc, player_id})
  end

  @spec show_board(pid()) :: Renderer.t()
  def show_board(game_pid) do
    GenServer.call(game_pid, {:show_board})
  end
end
