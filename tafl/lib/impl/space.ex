defmodule Tafl.Impl.Space do
  defstruct(kind: nil, piece: %{})
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
    %__MODULE__{space | piece: %{}}
  end

  #########################################

  def render(space) do
    empty_map = %{}

    case {space.kind, space.piece} do
      {:corner, ^empty_map} -> "X"
      {:center, ^empty_map} -> "X"
      {_, ^empty_map} -> " "
      {_, piece} -> Piece.render(piece)
    end
  end
end
