module Config exposing (gridSize, speed, isOutOfBoundaries)

import Time exposing (Time)

import Coord exposing (Coord)


gridSize : Int
gridSize =
    12


speed : Time
speed =
    Time.millisecond * 200


isOutOfBoundaries : Coord -> Bool
isOutOfBoundaries coord =
    coord.y > gridSize || coord.y < 0 || coord.x > gridSize || coord.x < 0