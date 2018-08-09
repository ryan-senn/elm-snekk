module Update exposing (update)

import Random
import List.Nonempty as Nonempty

import Msg exposing (Msg (..))
import Model exposing (Model)

import Config

import Coord exposing (Coord)
import Snekk exposing (Snekk)
import Direction exposing (Direction (..), oppositeDirection)
import Helpers


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =

    case msg of
        StartGame ->
            { model | gameState = Model.Loading } ! [ generateFood model.gameState ]

        StartGamePress keyCode ->
            case keyCode of
                32 ->
                    { model | gameState = Model.Loading } ! [ generateFood model.gameState ]

                _ ->
                    model ! []

        SetFood foodCoord ->
            { model | gameState = Model.Started <| setFood model.gameState foodCoord } ! []

        Tick ->
            case model.gameState of
                Model.Started gameModel ->
                    tick model gameModel

                _ ->
                    Debug.crash "No ticks subscription if game is not started."

        SetDirection keyCode ->
            case model.gameState of
                Model.Started gameModel ->
                    { model | gameState = Model.Started <| setDirection keyCode gameModel } ! []

                _ ->
                    Debug.crash "No direction subscription if game is not started."


setFood : Model.GameState -> Coord -> Model.GameModel
setFood gameState foodCoord =
    case gameState of
        Model.Started gameModel ->
            { gameModel | food = foodCoord }

        _ ->
            Model.initialGameModel foodCoord


generateFood : Model.GameState -> Cmd Msg
generateFood gameState =
    foodGenerator gameState
        |> Random.generate SetFood


foodGenerator : Model.GameState -> Random.Generator Coord
foodGenerator gameState =
    Random.pair (Random.int 0 Config.gridSize) (Random.int 0 Config.gridSize)
        |> Random.andThen (\(x, y) ->
            if Nonempty.member (Coord x y) (Helpers.getSnekk gameState)
                then foodGenerator gameState
                else Random.map (\_ -> Coord x y) Random.bool)


tick : Model -> Model.GameModel -> (Model, Cmd Msg)
tick model gameModel =
    let
        newSnekk =
            Snekk.move gameModel.desiredDirection gameModel.snekk

    in
        case Config.isOutOfBoundaries (Nonempty.head newSnekk) || Nonempty.member (Nonempty.head newSnekk) (Nonempty.pop newSnekk) of
            True ->
                { model
                    | gameState = Model.GameOver (Nonempty.length newSnekk - 3)
                    , highestScore =
                        if Nonempty.length newSnekk > model.highestScore
                            then Nonempty.length newSnekk - 3
                            else model.highestScore
                } ! []

            False ->
                { model | gameState =
                    Model.Started
                        { gameModel
                            | snekk = if Nonempty.head newSnekk == gameModel.food then Nonempty.append newSnekk (Nonempty.fromElement (Nonempty.reverse newSnekk |> Nonempty.head)) else newSnekk
                            , lastTickDirection = gameModel.desiredDirection
                        }
                } !
                    [ if Nonempty.head newSnekk == gameModel.food
                        then generateFood model.gameState
                        else Cmd.none
                    ]


setDirection : Int -> Model.GameModel -> Model.GameModel
setDirection keyCode gameModel =
    case (Direction.fromKeyCode keyCode, Just (oppositeDirection gameModel.lastTickDirection) == Direction.fromKeyCode keyCode) of
        (Just desiredDirection, False) ->
            { gameModel | desiredDirection = desiredDirection }

        -- keys we're not interested in or illegal direction (opposite direction)
        _ ->
            gameModel