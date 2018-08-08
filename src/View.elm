module View exposing (view)

import Styles as Css
import Html.Styled exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (..)

import List.Nonempty as Nonempty

import Msg exposing (Msg)
import Model exposing (Model)

import Config
import Coord exposing (Coord)


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
                game model.highestScore gameModel

            Model.GameOver score ->
                gameOver model.highestScore score
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


game : Int -> Model.GameModel -> Html Msg
game highestScore gameModel =
    div
        []
        [ div
            []
            [ div
                []
                [ text <| "Score: " ++ toString (Nonempty.length gameModel.snekk - 3) ]
            , div
                []
                [ text <| "Highest Score: " ++ toString highestScore ]
            ]
        , div
            [ Css.grid ]
            ( List.map (row gameModel) (List.range 0 Config.gridSize |> List.reverse) )
        ]


row : Model.GameModel -> Int -> Html Msg
row gameModel y =
    div
        [ Css.row ]
        ( List.map (\x -> square gameModel <| Coord x y) (List.range 0 Config.gridSize) )


square : Model.GameModel -> Coord -> Html Msg
square gameModel coord =
    div
        [ Css.square (Nonempty.member coord gameModel.snekk) (coord == gameModel.food) ]
        []


gameOver : Int -> Int -> Html Msg
gameOver highestScore score =
    div
        []
        [ div
            []
            [ text <| "Game Over! Score: " ++ toString score ++ " Highest Score: " ++ toString highestScore ]
        , button
            [ onClick Msg.StartGame ]
            [ text "Try Again!" ]
        ]