defmodule Tafl.Impl.Utils do
  alias Tafl.Type

  @spec other_player(Type.player()) :: Type.player()
  def other_player(:p1), do: :p2
  def other_player(:p2), do: :p1
end
