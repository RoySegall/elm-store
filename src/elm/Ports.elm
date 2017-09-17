port module Ports exposing (..)

import Model exposing (..)


port addItemToStorage : Item -> Cmd msg


port getItemsFromStorage : (List Item -> msg) -> Sub msg


port removeItemsFromStorage : () -> Cmd msg


port setItemInLocalStorage : List Item -> Cmd msg


port removeItemsFromCart : Item -> Cmd msg


port setAccessToken : SuccessLogin -> Cmd msg


port logOut : () -> Cmd msg


port changeCheckoutStep : Int -> Cmd msg
