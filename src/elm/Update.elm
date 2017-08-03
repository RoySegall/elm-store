module Update exposing (..)

import Model exposing (..)


-- UPDATE


type Msg
    = AddItems


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddItems ->
            { model | cartItems = model.cartItems + 1 }
