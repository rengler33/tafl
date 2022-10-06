defmodule Tafl.Type do
  @type state :: :initializing | :waiting | :over | :invalid_move
  @type player :: :p1 | :p2
  @type rc_loc :: {integer(), integer()}
  @type spaces :: %{required(rc_loc()) => Space.t()}

  @type render :: %{
          spaces: spaces(),
          state: state(),
          message: String.t(),
          turn: player()
        }
end
