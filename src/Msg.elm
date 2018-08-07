module Msg exposing (Msg (..))

import Keyboard


type Msg
    = StartGame
    | SetFood (Int, Int)
    | Tick
    | SetDirection Keyboard.KeyCode