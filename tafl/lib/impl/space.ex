defmodule Tafl.Impl.Space do
  alias Tafl.Impl.Piece

  defstruct(kind: nil, piece: %Piece{})
  # kind: corner, edge, basic, center

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
    %__MODULE__{space | piece: %Piece{}}
  end

  #########################################

  def render(space) do
    empty = %Piece{}

    case {space.kind, space.piece} do
      {:corner, ^empty} -> "X"
      {:center, ^empty} -> "X"
      {_, ^empty} -> " "
      {_, piece} -> Piece.render(piece)
    end
  end
end
