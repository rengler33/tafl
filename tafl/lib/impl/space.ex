defmodule Tafl.Impl.Space do
  alias Tafl.Impl.Piece
  @type space_kind :: :corner | :edge | :basic | :center

  @type t :: %__MODULE__{
          kind: space_kind() | nil,
          piece: Piece.t()
        }
  defstruct(kind: nil, piece: %Piece{})

  @spec make_space(space_kind(), Piece.t()) :: t()
  def make_space(kind) do
    %__MODULE__{kind: kind}
  end

  def make_space(kind, piece) do
    %__MODULE__{kind: kind, piece: piece}
  end

  @spec place_piece(t(), Piece.t()) :: t()
  def place_piece(space, piece) do
    %__MODULE__{space | piece: piece}
  end

  @spec remove_piece(t()) :: t()
  def remove_piece(space) do
    %__MODULE__{space | piece: %Piece{}}
  end

  @spec get_piece(t()) :: Piece.t()
  def get_piece(space) do
    space
    |> Map.get(:piece)
  end
end
