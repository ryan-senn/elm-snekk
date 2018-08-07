import Html exposing (program)

import Html.Styled as Html

import Update exposing (update)
import View exposing (view)
import Msg exposing (Msg)
import Model exposing (Model, initialModel)
import Subs exposing (subscriptions)


main : Program Never Model Msg
main =
    program
        { init = initialModel ! []
        , update = update
        , subscriptions = subscriptions
        , view = view >> Html.toUnstyled
        }