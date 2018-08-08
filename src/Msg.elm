module Msg exposing (Msg (..))

import Keyboard

import Coord exposing (Coord)


type Msg
    = StartGame
    | SetFood Coord
    | Tick
    | SetDirection Keyboard.KeyCode