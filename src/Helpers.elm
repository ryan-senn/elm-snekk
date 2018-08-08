module Helpers exposing (getSnekk)

import Model
import Snekk exposing (Snekk, initialSnekk)


getSnekk : Model.GameState -> Snekk
getSnekk gameState =
    case gameState of
        Model.Started gameModel ->
            gameModel.snekk

        _ ->
            initialSnekk