module Snekk exposing (Snekk, initialSnekk, move)

import List.Nonempty as Nonempty exposing (Nonempty (Nonempty))

import Config
import Coord exposing (Coord)
import Direction exposing (Direction (..))


type alias Snekk =
    Nonempty Coord


initialSnekk : Snekk
initialSnekk =
    Nonempty (Coord 3 (Config.gridSize - 1)) [(Coord 2 (Config.gridSize - 1)), (Coord 1 (Config.gridSize - 1))]


move : Direction -> Snekk -> Snekk
move direction snekk =
    let
        head =
            snekk
                |> Nonempty.head

        newHead =
            case direction of
                North -> { head | y = head.y + 1 }
                East -> { head | x = head.x + 1 }
                South -> { head | y = head.y - 1 }
                West -> { head | x = head.x - 1 }

    in
        snekk
            |> Nonempty.reverse
            |> Nonempty.pop
            |> Nonempty.reverse
            |> Nonempty.append (Nonempty.fromElement newHead)