module Direction exposing (Direction (..), oppositeDirection)


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