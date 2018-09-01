module Subs exposing (subscriptions)

import Browser.Events as Events
import Config
import Direction
import Json.Decode as Decode exposing (Decoder)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Time


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ ticks model.gameState
        , setDirection model.gameState
        , startGame model.gameState
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
            Events.onKeyDown <| Decode.map Msg.SetDirection Direction.decoder

        _ ->
            Sub.none


startGame : Model.GameState -> Sub Msg
startGame gameState =
    case gameState of
        Model.NotStarted ->
            Events.onKeyDown startGameDecoder

        Model.GameOver _ ->
            Events.onKeyDown startGameDecoder

        _ ->
            Sub.none


startGameDecoder : Decoder Msg
startGameDecoder =
    Decode.field "key" Decode.string
        |> Decode.andThen
            (\key ->
                if key == "Space" then
                    Decode.succeed StartGame

                else
                    Decode.fail "Not a valid StartGame key."
            )
