defmodule Tafl.Impl.Player do
  alias Tafl.Type

  @type t :: %__MODULE__{
          id: String.t(),
          indicator: Type.player_indicator()
        }
  defstruct [:id, :indicator]

  @spec new(String.t(), Type.player_indicator()) :: t()
  def new(id, indicator) do
    %__MODULE__{id: id, indicator: indicator}
  end
end
