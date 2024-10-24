defmodule Tafl.Type do
  @type game_type :: :basic
  @type state :: :initializing | :waiting | :over | :invalid_move
  @type player_indicator :: :p1 | :p2
  @type rc_loc :: {integer(), integer()}
  @type move :: {rc_loc(), rc_loc()}
end
