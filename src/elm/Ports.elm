port module Ports exposing (..)

import Model exposing (Item)


port addItemToStorage : Item -> Cmd msg
