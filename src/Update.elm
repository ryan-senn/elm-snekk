module Update exposing (update)

import Random
import List.Nonempty as Nonempty

import Msg exposing (Msg (..))
import Model exposing (Model)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =

    case msg of
        StartGame ->
            { model | gameState = Model.Loading }
                ! [ Random.generate SetFood <| Random.pair (Random.int 5 Model.gridSize) (Random.int 5 Model.gridSize) ]

        SetFood food ->
            { model | gameState = setFood model.gameState food } ! []

        Tick ->
            case model.gameState of
                Model.Started gameModel ->
                    let
                        newSnekk =
                            move gameModel.direction gameModel.snekk

                    in
                        case isOutOfBoundaries <| Nonempty.head newSnekk of
                            True ->
                                { model
                                    | gameState = Model.GameOver
                                } ! []

                            False ->
                                { model
                                    | gameState = Model.Started <| { gameModel | snekk = if Nonempty.head newSnekk == gameModel.food then Nonempty.append newSnekk (Nonempty.fromElement (Nonempty.reverse newSnekk |> Nonempty.head)) else newSnekk }
                                } !
                                    [ if Nonempty.head newSnekk == gameModel.food
                                        then Random.generate SetFood <| Random.pair (Random.int 5 Model.gridSize) (Random.int 5 Model.gridSize)
                                        else Cmd.none
                                    ]

                _ ->
                    model ! []

        SetDirection keyCode ->
            case model.gameState of
                Model.Started gameModel ->
                    case (keyCodeDirection keyCode, Just (Model.oppositeDirection gameModel.direction) == keyCodeDirection keyCode) of
                        (_, True) ->
                            model ! []

                        (Just direction, False) ->
                            { model | gameState = Model.Started <| { gameModel | direction = direction } } ! []

                        _ ->
                            model ! []

                _ ->
                    model ! []


setFood : Model.GameState -> (Int, Int) -> Model.GameState
setFood gameState (x, y) =
    case gameState of
        Model.Started gameModel ->
            Model.Started { gameModel | food = Model.Coord x y }

        _ ->
            Model.Started <| Model.initialGameModel (x, y)


move : Model.Direction -> Model.Snekk -> Model.Snekk
move direction snekk =
    let
        head =
            snekk
                |> Nonempty.head

        newHead =
            case direction of
                Model.North -> { head | y = head.y + 1 }
                Model.East -> { head | x = head.x + 1 }
                Model.South -> { head | y = head.y - 1 }
                Model.West -> { head | x = head.x - 1 }

    in
        snekk
            |> Nonempty.reverse
            |> Nonempty.pop
            |> Nonempty.reverse
            |> Nonempty.append (Nonempty.fromElement newHead)


isOutOfBoundaries : Model.Coord -> Bool
isOutOfBoundaries coord =
    coord.y > Model.gridSize || coord.y < 0 || coord.x > Model.gridSize || coord.x < 0


keyCodeDirection : Int -> Maybe Model.Direction
keyCodeDirection keyCode =
    case keyCode of
        38 -> Just Model.North
        39 -> Just Model.East
        40 -> Just Model.South
        37 -> Just Model.West
        _  -> Nothing