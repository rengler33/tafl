defmodule Tafl.Impl.GameConfiguration do
  alias Tafl.Impl.{Piece, Space}

  def new_game_spaces(setup) do
    game_components(setup)
    |> Enum.map(&make_row(&1))
  end

  def game_components(:basic) do
    king = Piece.make_piece(:p1, :king)
    pawn1 = Piece.make_piece(:p1, :pawn)
    pawn2 = Piece.make_piece(:p2, :pawn)

    [
      [{:corner, 1}, {:edge, 2}, {:edge, 5, pawn2}, {:edge, 2}, {:corner, 1}],
      [{:edge, 1}, {:basic, 4}, {:basic, 1, pawn2}, {:basic, 4}, {:edge, 1}],
      [{:edge, 1}, {:basic, 9}, {:edge, 1}],
      [{:edge, 1, pawn2}, {:basic, 4}, {:basic, 1, pawn1}, {:basic, 4}, {:edge, 1, pawn2}],
      [{:edge, 1, pawn2}, {:basic, 3}, {:basic, 3, pawn1}, {:basic, 3}, {:edge, 1, pawn2}],
      [
        {:edge, 2, pawn2},
        {:basic, 1},
        {:basic, 2, pawn1},
        {:center, 1, king},
        {:basic, 2, pawn1},
        {:basic, 1},
        {:edge, 2, pawn2}
      ],
      [{:edge, 1, pawn2}, {:basic, 3}, {:basic, 3, pawn1}, {:basic, 3}, {:edge, 1, pawn2}],
      [{:edge, 1, pawn2}, {:basic, 4}, {:basic, 1, pawn1}, {:basic, 4}, {:edge, 1, pawn2}],
      [{:edge, 1}, {:basic, 9}, {:edge, 1}],
      [{:edge, 1}, {:basic, 4}, {:basic, 1, pawn2}, {:basic, 4}, {:edge, 1}],
      [{:corner, 1}, {:edge, 2}, {:edge, 5, pawn2}, {:edge, 2}, {:corner, 1}]
    ]
  end

  defp make_row(components) do
    components
    |> Enum.map(&make_spaces(&1))
    |> List.flatten()
  end

  defp make_spaces({kind, quantity}) do
    for _ <- 1..quantity, do: Space.make_space(kind)
  end

  defp make_spaces({kind, quantity, piece}) do
    for _ <- 1..quantity, do: Space.make_space(kind, piece)
  end
end
