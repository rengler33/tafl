defmodule Tafl.Impl.WinConditions do
  alias Tafl.Impl.Game
  alias Tafl.Type

  @type win_response :: {boolean(), Type.player()}

  @spec check(Game.t()) :: win_response()
  def check(game) do
    with false <- king_in_corner(game),
         false <- king_has_been_captured(game) do
      {false, nil}
    else
      {true, player} -> {true, player}
    end
  end

  #########################################

  defp king_in_corner(game) do
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
