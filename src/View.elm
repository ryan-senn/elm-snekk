module View exposing (view)

import Config
import Coord exposing (Coord)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import List.Nonempty as Nonempty
import Model exposing (Model)
import Msg exposing (Msg)
import Styles as Css


view : Model -> Html Msg
view model =
    div
        [ Css.layout ]
        [ h1
            []
            [ text "Snake Game in Elm" ]
        , a
            [ Css.github, href "https://github.com/ryan-senn/elm-snekk", target "_blank" ]
            [ text "Source Code on Github" ]
        , div
            []
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
        ]


notStarted : Html Msg
notStarted =
    div
        []
        [ button
            [ Css.button, onClick Msg.StartGame ]
            [ text "Start Game! (Or press Space)" ]
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
            [ Css.score ]
            [ div
                []
                [ text <| "Highest Score: " ++ String.fromInt highestScore ]
            , div
                []
                [ text <| "Score: " ++ String.fromInt (Nonempty.length gameModel.snekk - 3) ]
            ]
        , div
            [ Css.grid ]
            (List.map (row gameModel) (List.range 0 Config.gridSize |> List.reverse))
        ]


row : Model.GameModel -> Int -> Html Msg
row gameModel y =
    div
        [ Css.row ]
        (List.map (\x -> square gameModel <| Coord x y) (List.range 0 Config.gridSize))


square : Model.GameModel -> Coord -> Html Msg
square gameModel coord =
    div
        [ Css.square (Nonempty.member coord gameModel.snekk) (coord == gameModel.food) ]
        []


gameOver : Int -> Int -> Html Msg
gameOver highestScore score =
    div
        [ Css.gameOver ]
        [ div
            []
            [ text <| "Game Over! Score: " ++ String.fromInt score ++ " Highest Score: " ++ String.fromInt highestScore ]
        , button
            [ Css.button, Css.tryAgain, onClick Msg.StartGame ]
            [ text "Try Again! (Or press Space)" ]
        ]
