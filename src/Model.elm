module Model exposing
    ( GameModel
    , GameState(..)
    , Model
    , initialGameModel
    , initialModel
    )

import Coord exposing (Coord)
import Direction exposing (Direction(..))
import Snekk exposing (Snekk, initialSnekk)


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


initialGameModel : Coord -> GameModel
initialGameModel foodCoord =
    { snekk = initialSnekk
    , lastTickDirection = East
    , desiredDirection = East
    , food = foodCoord
    }
