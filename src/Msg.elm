module Msg exposing (Msg(..))

import Coord exposing (Coord)
import Direction exposing (Direction)


type Msg
    = StartGame
    | SetFood Coord
    | Tick
    | SetDirection Direction
