port module Ports exposing (..)

import Model exposing (..)


port addItemToStorage : Item -> Cmd msg


port getItemsFromStorage : (List Item -> msg) -> Sub msg
