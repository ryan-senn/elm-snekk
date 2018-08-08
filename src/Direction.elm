module Direction exposing (Direction (..), oppositeDirection, fromKeyCode)


type Direction
    = North
    | East
    | South
    | West


oppositeDirection : Direction -> Direction
oppositeDirection direction =
    case direction of
        North -> South
        East -> West
        South -> North
        West -> East


fromKeyCode : Int -> Maybe Direction
fromKeyCode keyCode =
    case keyCode of
        38 -> Just North
        39 -> Just East
        40 -> Just South
        37 -> Just West
        _  -> Nothing