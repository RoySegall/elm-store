module Update exposing (..)

import Config exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Model exposing (..)


-- UPDATE


type Msg
    = AddItems Item
    | HideCart
    | ToggleCart
    | GetItems


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

        HideCart ->
            { model | hideCart = True }

        GetItems ->
            Http.get (backend_address ++ "/api/items") decodeGifUrl


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string
