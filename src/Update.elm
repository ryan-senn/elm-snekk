module Update exposing (update)

import Config
import Coord exposing (Coord)
import Direction exposing (Direction(..), oppositeDirection)
import Helpers
import List.Nonempty as Nonempty
import Model exposing (Model)
import Msg exposing (Msg(..))
import Random
import Snekk exposing (Snekk)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartGame ->
            ( { model | gameState = Model.Loading }
            , generateFood model.gameState
            )

        SetFood foodCoord ->
            ( { model | gameState = Model.Started <| setFood model.gameState foodCoord }
            , Cmd.none
            )

        Tick ->
            case model.gameState of
                Model.Started gameModel ->
                    tick model gameModel

                _ ->
                    (model, Cmd.none)

        SetDirection direction ->
            case model.gameState of
                Model.Started gameModel ->
                    ( { model | gameState = Model.Started <| setDirection direction gameModel }
                    , Cmd.none
                    )

                _ ->
                    (model, Cmd.none)


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
        |> Random.andThen
            (\( x, y ) ->
                if Nonempty.member (Coord x y) (Helpers.getSnekk gameState) then
                    foodGenerator gameState

                else
                    Random.constant <| Coord x y
            )


tick : Model -> Model.GameModel -> ( Model, Cmd Msg )
tick model gameModel =
    let
        newSnekk =
            Snekk.move gameModel.desiredDirection gameModel.snekk
    in
    case Config.isOutOfBoundaries (Nonempty.head newSnekk) || Nonempty.member (Nonempty.head newSnekk) (Nonempty.pop newSnekk) of
        True ->
            ( { model
                | gameState = Model.GameOver (Nonempty.length newSnekk - 3)
                , highestScore =
                    if Nonempty.length newSnekk > model.highestScore then
                        Nonempty.length newSnekk - 3

                    else
                        model.highestScore
              }
            , Cmd.none
            )

        False ->
            ( { model
                | gameState =
                    Model.Started
                        { gameModel
                            | snekk =
                                if Nonempty.head newSnekk == gameModel.food then
                                    Nonempty.append newSnekk (Nonempty.fromElement (Nonempty.reverse newSnekk |> Nonempty.head))

                                else
                                    newSnekk
                            , lastTickDirection = gameModel.desiredDirection
                        }
              }
            , if Nonempty.head newSnekk == gameModel.food then
                generateFood model.gameState

              else
                Cmd.none
            )


setDirection : Direction -> Model.GameModel -> Model.GameModel
setDirection desiredDirection gameModel =
    if desiredDirection == oppositeDirection gameModel.lastTickDirection then
        gameModel

    else
        { gameModel | desiredDirection = desiredDirection }
