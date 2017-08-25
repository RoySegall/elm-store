module Update exposing (..)

import Config exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Model exposing (..)
import Ports exposing (addItemToStorage)


-- UPDATE


type Msg
    = AddItems Item
    | HideCart
    | ToggleCart
    | GetItems (Result Http.Error (List Item))
    | InitItems (List Item)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddItems item ->
            ( { model
                | cartItems = model.cartItems + 1
                , cartItemsList = model.cartItemsList ++ [ item ]
              }
            , addItemToStorage item
            )

        ToggleCart ->
            if model.hideCart then
                ( { model | hideCart = False }, Cmd.none )
            else
                ( { model | hideCart = True }, Cmd.none )

        HideCart ->
            ( { model | hideCart = True }, Cmd.none )

        GetItems (Ok backendItems) ->
            ( { model | items = backendItems }, Cmd.none )

        GetItems (Err error) ->
            Debug.log "error occured" (toString error)
                |> always ( model, Cmd.none )

        InitItems items ->
            ( { model | cartItemsList = items }, Cmd.none )


getItems : Cmd Msg
getItems =
    let
        url =
            backend_address ++ "/api/items"
    in
    Http.send
        GetItems
        (Http.get url collectionDecoder)


collectionDecoder : Decode.Decoder (List Item)
collectionDecoder =
    Decode.at [ "data" ] <| Decode.list <| memberDecoder


memberDecoder : Decode.Decoder Item
memberDecoder =
    Decode.map5 Item
        (field "Id" Decode.string)
        (field "Title" Decode.string)
        (field "Description" Decode.string)
        (field "Price" Decode.float)
        (field "Image" Decode.string)
