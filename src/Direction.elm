module Direction exposing (Direction(..), decoder, oppositeDirection)

import Json.Decode as Decode exposing (Decoder)


type Direction
    = North
    | East
    | South
    | West


oppositeDirection : Direction -> Direction
oppositeDirection direction =
    case direction of
        North ->
            South

        East ->
            West

        South ->
            North

        West ->
            East


decoder : Decoder Direction
decoder =
    Decode.field "key" Decode.string
        |> Decode.andThen decodeDirection


decodeDirection : String -> Decoder Direction
decodeDirection key =
    case key of
        "ArrowTop" ->
            Decode.succeed North

        "ArrowRight" ->
            Decode.succeed East

        "ArrowBottom" ->
            Decode.succeed South

        "ArrowLeft" ->
            Decode.succeed West

        _ ->
            Decode.fail "Not a valid Direction key."
