module Main exposing (main)

import Browser
import Html.Styled as Html
import Model exposing (Model, initialModel)
import Msg exposing (Msg)
import Subs exposing (subscriptions)
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.document
        { init =
            always
                ( initialModel
                , Cmd.none
                )
        , update = update
        , subscriptions = subscriptions
        , view =
            \model ->
                { title = "Snekk Game in Elm"
                , body = [ view model |> Html.toUnstyled ]
                }
        }
