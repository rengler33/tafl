defmodule Tafl.Impl.WinConditions do
  def check(game) do
    checks = [
      &king_in_corner/1,
      &king_has_been_captured/1
    ]

    check_win(checks, game)
  end

  defp check_win([], _game) do
    {false, nil}
  end

  defp check_win([head | tail], game) do
    case head.(game) do
      {true, player} -> {true, player}
      _ -> check_win(tail, game)
    end
  end

  #########################################

  defp king_in_corner(game) do
    # TODO Make this function unaware of struct structure?
    winner =
      game.board.spaces
      |> Map.values()
      |> Enum.filter(&(&1.kind == :corner and Map.get(&1.piece, :kind, nil) == :king))
      |> Enum.any?()

    case winner do
      true -> {true, :p1}
      _ -> false
    end
  end

  defp king_has_been_captured(game) do
    king_still_in_play =
      game.board.spaces
      |> Map.values()
      |> Enum.filter(&(Map.get(&1.piece, :kind, nil) == :king))
      |> Enum.any?()

    case king_still_in_play do
      true -> false
      false -> {true, :p2}
    end
  end
end
