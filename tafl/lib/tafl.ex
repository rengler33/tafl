defmodule Tafl do
  def new_game do
    {:ok, pid} = Tafl.Runtime.Application.start_game()
    pid
  end

  def make_move(game_pid, old_loc, new_loc) do
    GenServer.call(game_pid, {:make_move, old_loc, new_loc})
  end

  def show_board(game_pid) do
    GenServer.cast(game_pid, {:show_board})
  end
end
