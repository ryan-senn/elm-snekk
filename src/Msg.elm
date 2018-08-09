module Msg exposing (Msg (..))

import Keyboard

import Coord exposing (Coord)


type Msg
    = StartGame
    | StartGamePress Keyboard.KeyCode
    | SetFood Coord
    | Tick
    | SetDirection Keyboard.KeyCode