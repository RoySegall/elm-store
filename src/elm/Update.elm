module Update exposing (..)

import Config exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Model exposing (..)
import Models.Models exposing (Item)
import Ports exposing (addItemToStorage, removeItemsFromCart, removeItemsFromStorage)


removeItemFromCart : Item -> Model -> Model
removeItemFromCart item model =
    { model
        | cartItems =
            List.filter (\i -> not (i.id == item.id)) model.cartItems
    }
