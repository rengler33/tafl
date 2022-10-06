defmodule Tafl.Impl.Space do
  alias Tafl.Impl.Piece
  @type space_kind :: :corner | :edge | :basic | :center

  @type t :: %__MODULE__{
          kind: space_kind() | nil,
          piece: Piece.t()
        }
  defstruct(kind: nil, piece: %Piece{})

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
end
