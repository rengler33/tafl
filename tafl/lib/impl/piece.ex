defmodule Tafl.Impl.Piece do
  alias Tafl.Type
  @type piece_kind :: :pawn | :king

  @type t :: %__MODULE__{
          kind: piece_kind() | nil,
          owner: Type.player_indicator() | nil
        }

  defstruct [:kind, :owner]

  @spec make_piece(Type.player_indicator(), piece_kind()) :: t()
  def make_piece(owner, kind) do
    %__MODULE__{owner: owner, kind: kind}
  end
end
