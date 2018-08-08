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
            { model | gameState = Model.Loading }
                ! [ generateFood model.gameState ]

        SetFood food ->
            { model | gameState = setFood model.gameState food } ! []

        Tick ->
            case model.gameState of
                Model.Started gameModel ->
                    let
                        newSnekk =
                            move gameModel.desiredDirection gameModel.snekk

                    in
                        case isOutOfBoundaries (Nonempty.head newSnekk) || Nonempty.member (Nonempty.head newSnekk) (Nonempty.pop newSnekk) of
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

                _ ->
                    model ! []

        SetDirection keyCode ->
            case model.gameState of
                Model.Started gameModel ->
                    case (keyCodeDirection keyCode, Just (oppositeDirection gameModel.lastTickDirection) == keyCodeDirection keyCode) of
                        (_, True) ->
                            model ! []

                        (Just desiredDirection, False) ->
                            { model | gameState = Model.Started { gameModel | desiredDirection = desiredDirection } } ! []

                        _ ->
                            model ! []

                _ ->
                    model ! []


generateFood : Model.GameState -> Cmd Msg
generateFood gameState =
    foodGenerator gameState
        |> Random.generate SetFood


foodGenerator : Model.GameState -> Random.Generator (Int, Int)
foodGenerator gameState =
    Random.pair (Random.int 0 Config.gridSize) (Random.int 0 Config.gridSize)
        |> Random.andThen (\(x, y) -> if Nonempty.member (Coord x y) (Helpers.getSnekk gameState) then foodGenerator gameState else Random.map (\_ -> (x, y)) Random.bool)


setFood : Model.GameState -> (Int, Int) -> Model.GameState
setFood gameState (x, y) =
    case gameState of
        Model.Started gameModel ->
            Model.Started { gameModel | food = Coord x y }

        _ ->
            Model.Started <| Model.initialGameModel (x, y)


move : Direction -> Snekk -> Snekk
move direction snekk =
    let
        head =
            snekk
                |> Nonempty.head

        newHead =
            case direction of
                North -> { head | y = head.y + 1 }
                East -> { head | x = head.x + 1 }
                South -> { head | y = head.y - 1 }
                West -> { head | x = head.x - 1 }

    in
        snekk
            |> Nonempty.reverse
            |> Nonempty.pop
            |> Nonempty.reverse
            |> Nonempty.append (Nonempty.fromElement newHead)


isOutOfBoundaries : Coord -> Bool
isOutOfBoundaries coord =
    coord.y > Config.gridSize || coord.y < 0 || coord.x > Config.gridSize || coord.x < 0


keyCodeDirection : Int -> Maybe Direction
keyCodeDirection keyCode =
    case keyCode of
        38 -> Just North
        39 -> Just East
        40 -> Just South
        37 -> Just West
        _  -> Nothing