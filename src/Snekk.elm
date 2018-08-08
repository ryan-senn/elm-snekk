module Snekk exposing (Snekk, initialSnekk)

import List.Nonempty exposing (Nonempty (Nonempty))

import Config
import Coord exposing (Coord)


type alias Snekk =
    Nonempty Coord


initialSnekk : Snekk
initialSnekk =
    Nonempty (Coord 3 (Config.gridSize - 1)) [(Coord 2 (Config.gridSize - 1)), (Coord 1 (Config.gridSize - 1))]