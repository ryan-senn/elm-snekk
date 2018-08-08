module Config exposing (gridSize, speed)

import Time exposing (Time)


gridSize : Int
gridSize =
    12


speed : Time
speed =
    Time.millisecond * 200