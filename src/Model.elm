module Model exposing
    ( Model, initialModel
    , GameState (..), Snekk
    , GameModel, initialGameModel
    , Direction (..), oppositeDirection, Coord
    , gridSize, speed
    )

import Time exposing (Time)
import List.Nonempty as Nonempty exposing (Nonempty (Nonempty))


type alias Model =
    { gameState : GameState
    }


initialModel : Model
initialModel =
    { gameState = NotStarted
    }


type GameState
    = NotStarted
    | Loading
    | Started GameModel
    | GameOver


type alias GameModel =
    { snekk : Snekk
    , direction : Direction
    , food : Coord
    }


initialGameModel : (Int, Int) -> GameModel
initialGameModel (x, y) =
    { snekk = Nonempty (Coord 1 1) [(Coord 1 2), (Coord 1 3)]
    , direction = East
    , food = Coord x y
    }


type alias Snekk =
    Nonempty Coord


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


type alias Coord =
    { x : Int
    , y : Int
    }


gridSize : Int
gridSize =
    16


speed : Time
speed =
    Time.millisecond * 200