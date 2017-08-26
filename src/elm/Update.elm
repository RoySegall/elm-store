module Update exposing (..)

import Config exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Model exposing (..)
import Ports exposing (addItemToStorage, removeItemsFromCart, removeItemsFromStorage)


-- UPDATE


type Msg
    = AddItems Item
    | HideCart
    | ClearCart Model
    | ToggleCart
    | GetItems (Result Http.Error (List Item))
    | InitItems (List Item)
    | RemoveItemFromCart Item


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddItems item ->
            ( { model
                | cartItems = model.cartItems ++ [ item ]
              }
            , addItemToStorage item
            )

        ClearCart model ->
            ( { model | cartItems = [] }, removeItemsFromStorage () )

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
            ( { model | cartItems = items }, Cmd.none )

        RemoveItemFromCart item ->
            ( removeItemFromCart item model, removeItemsFromCart item )


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


removeItemFromCart : Item -> Model -> Model
removeItemFromCart item model =
    { model
        | cartItems =
            List.filter (\i -> not (i.id == item.id)) model.cartItems
    }
