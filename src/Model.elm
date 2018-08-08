module Model exposing
    ( Model, initialModel
    , GameState (..), GameModel, initialGameModel
    )

import Snekk exposing (Snekk, initialSnekk)
import Direction exposing (Direction (East))
import Coord exposing (Coord)


type alias Model =
    { gameState : GameState
    , highestScore : Int
    }


initialModel : Model
initialModel =
    { gameState = NotStarted
    , highestScore = 0
    }


type GameState
    = NotStarted
    | Loading
    | Started GameModel
    | GameOver Int


type alias GameModel =
    { snekk : Snekk
    , lastTickDirection : Direction
    , desiredDirection : Direction
    , food : Coord
    }


initialGameModel : (Int, Int) -> GameModel
initialGameModel (x, y) =
    { snekk = initialSnekk
    , lastTickDirection = East
    , desiredDirection = East
    , food = Coord x y
    }