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
    | GetItems (Result Http.Error (List Item))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddItems item ->
            ( { model
                | cartItems = model.cartItems + 1
                , cartItemsList = model.cartItemsList ++ [ item ]
              }
            , Cmd.none
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
    Decode.map4 Item
        (field "Id" Decode.string)
        (field "Title" Decode.string)
        (field "Price" Decode.float)
        (field "Image" Decode.string)
