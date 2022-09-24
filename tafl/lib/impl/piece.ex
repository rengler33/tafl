defmodule Tafl.Impl.Piece do
  defstruct [:owner, :kind]
  # owner: p1, p2
  # kind: pawn, king

  def make_piece(owner, kind) do
    %__MODULE__{owner: owner, kind: kind}
  end

  #########################################
  def render(piece) do
    case {piece.owner, piece.kind} do
      {:p1, :pawn} -> "+"
      {:p2, :pawn} -> "o"
      {_, :king} -> "K"
      # this actually means an error
      {_, _} -> "?"
    end
  end
end
