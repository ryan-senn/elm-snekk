module Tests exposing (suite)

import Test exposing (Test, describe, test)
import Expect exposing (Expectation, equal)

import Model exposing (Snekk, Coord, oppositeDirection)


suite : Test
suite =
    describe "test the snekk"
        [ test "" <| always testMoveNorth
        ]


snekk : Snekk
snekk =
    List.map (Coord 3) (List.range 2 6)


testMoveNorth : Expectation
testMoveNorth =
