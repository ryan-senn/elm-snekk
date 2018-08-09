module Styles exposing (..)

import Css exposing (..)
import Html.Styled exposing (Attribute)
import Html.Styled.Attributes exposing (css)

import Msg exposing (Msg)
import Model


layout : Attribute Msg
layout =
    css
        [ displayFlex
        , flexDirection column
        , justifyContent center
        , alignItems center
        ]


button : Attribute Msg
button =
    css
        [ border3 (px 1) solid (hex "999999")
        , padding2 (Css.rem 0.4) (Css.rem 0.8)
        , borderRadius (px 2)
        , cursor pointer
        ]


grid : Attribute Msg
grid =
    css
        [ displayFlex
        , flexDirection column
        , border3 (px 1) solid (hex "cccccc")
        ]


github : Attribute Msg
github =
    css
        [ marginBottom (Css.rem 2)
        ]


score : Attribute Msg
score =
    css
        [ textAlign right
        ]


row : Attribute Msg
row =
    css
        [ displayFlex
        ]


square : Bool -> Bool -> Attribute Msg
square isSnekk isFood =
    css
        [ flexGrow <| int 1
        , width <| Css.rem 1.5
        , height <| Css.rem 1.5
        , border3 (px 1) solid (hex "efefef")
        , backgroundColor <| if isSnekk then hex "cccccc" else if isFood then hex "666666" else hex "ffffff"
        ]


gameOver : Attribute Msg
gameOver =
    css
        [ displayFlex
        , alignItems center
        , justifyContent center
        , flexDirection column
        ]


tryAgain : Attribute Msg
tryAgain =
    css
        [ marginTop (Css.rem 1)
        ]