port module Ports exposing (..)

import Models.Models exposing (Item)


port addItemToStorage : Item -> Cmd msg


port getItemsFromStorage : (List Item -> msg) -> Sub msg


port removeItemsFromStorage : () -> Cmd msg


port removeItemsFromCart : Item -> Cmd msg
