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
        , justifyContent center
        , alignItems center
        ]


grid : Attribute Msg
grid =
    css
        [ displayFlex
        , flexDirection column
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