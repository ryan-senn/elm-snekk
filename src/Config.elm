module Config exposing (gridSize, isOutOfBoundaries, speed)

import Coord exposing (Coord)


gridSize : Int
gridSize =
    12


speed : Float
speed =
    200


isOutOfBoundaries : Coord -> Bool
isOutOfBoundaries coord =
    coord.y > gridSize || coord.y < 0 || coord.x > gridSize || coord.x < 0
