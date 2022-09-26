defmodule Tafl.Impl.WinConditions do
  def check(game) do
    checks = [
      &king_in_corner/1
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
    winner =
      game.spaces
      |> List.flatten()
      |> Enum.filter(&(&1.kind == :corner and Map.get(&1.piece, :kind, nil) == :king))
      |> Enum.any?()

    case winner do
      true -> {true, :p1}
      _ -> false
    end
  end
end
