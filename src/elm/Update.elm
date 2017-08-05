module Update exposing (..)

import Model exposing (..)


-- UPDATE


type Msg
    = AddItems Item
    | ToggleCart


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddItems item ->
            { model
                | cartItems = model.cartItems + 1
                , items = model.items ++ [ item ]
            }

        ToggleCart ->
            if model.hideCart then
                { model | hideCart = False }
            else
                { model | hideCart = True }
