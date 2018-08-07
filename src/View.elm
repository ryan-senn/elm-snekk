module View exposing (view)

import Styles as Css
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (..)

import List.Nonempty as Nonempty

import Msg exposing (Msg)
import Model exposing (Model)


view : Model -> Html Msg
view model =
    div
        [ Css.layout ]
        [ case model.gameState of
            Model.NotStarted ->
                notStarted

            Model.Loading ->
                loading

            Model.Started gameModel ->
                game gameModel

            Model.GameOver ->
                gameOver
        ]


notStarted : Html Msg
notStarted =
    div
        []
        [ button
            [ onClick Msg.StartGame ]
            [ text "Start Game!" ]
        ]


loading : Html Msg
loading =
    div
        []
        [ text "loading ..."
        ]


game : Model.GameModel -> Html Msg
game gameModel =
    div
        [ Css.grid ]
        ( List.map (row gameModel) (List.range 0 Model.gridSize |> List.reverse) )


row : Model.GameModel -> Int -> Html Msg
row gameModel y =
    div
        [ Css.row ]
        ( List.map (\x -> square gameModel  <| Model.Coord x y) (List.range 0 Model.gridSize) )


square : Model.GameModel -> Model.Coord -> Html Msg
square gameModel coord =
    div
        [ Css.square (Nonempty.member coord gameModel.snekk) (coord == gameModel.food) ]
        []


gameOver : Html Msg
gameOver =
    div
        []
        [ div
            []
            [ text "Game Over :("]
        , button
            [ onClick Msg.StartGame ]
            [ text "Try Again!" ]
        ]
