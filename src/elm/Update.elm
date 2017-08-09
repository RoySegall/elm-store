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
    | GetItems (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddItems item ->
            ( { model
                | cartItems = model.cartItems + 1
                , items = model.items ++ [ item ]
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

        GetItems (Ok newUrl) ->
            ( { model | items = [] }, Cmd.none )

        GetItems (Err _) ->
            Debug.log "error occured" (toString Err) |> always ( model, Cmd.none )


getItems : Cmd Msg
getItems =
    let
        url =
            backend_address ++ "/api/items"
    in
    Http.send
        GetItems
        (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string
