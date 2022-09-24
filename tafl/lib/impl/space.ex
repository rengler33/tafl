defmodule Tafl.Impl.Space do
  defstruct(kind: nil, piece: nil)
  # kind: corner, edge, basic, center

  alias Tafl.Impl.Piece

  def make_space(kind) do
    %__MODULE__{kind: kind}
  end

  def make_space(kind, piece) do
    %__MODULE__{kind: kind, piece: piece}
  end

  def place_piece(space, piece) do
    %__MODULE__{space | piece: piece}
  end

  def remove_piece(space) do
    %__MODULE__{space | piece: nil}
  end

  #########################################
  def render(space) do
    case {space.kind, space.piece} do
      {:corner, nil} -> "X"
      {:center, nil} -> "X"
      {_, nil} -> " "
      {_, piece} -> Piece.render(piece)
    end
  end
end
