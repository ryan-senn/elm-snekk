module Subs exposing (subscriptions)

import Time
import Keyboard

import Msg exposing (Msg (..))
import Model exposing (Model)

import Config


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ ticks model.gameState
        , setDirection model.gameState
        ]


ticks : Model.GameState -> Sub Msg
ticks gameState =
    case gameState of
        Model.Started _ ->
            Time.every Config.speed (always Tick)

        _ ->
            Sub.none


setDirection : Model.GameState -> Sub Msg
setDirection gameState =
    case gameState of
        Model.Started _ ->
            Keyboard.downs SetDirection

        _ ->
            Sub.none