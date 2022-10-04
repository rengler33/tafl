defmodule Tafl.Impl.Piece do
  defstruct [:owner, :kind]
  # owner: p1, p2
  # kind: pawn, king

  def make_piece(owner, kind) do
    %__MODULE__{owner: owner, kind: kind}
  end
end
