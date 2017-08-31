module Update exposing (..)

import Config exposing (..)
import Http
import Json.Decode as Decode exposing (..)
import Model exposing (..)
import Navigation
import Ports exposing (addItemToStorage, removeItemsFromCart, removeItemsFromStorage)


-- UPDATE


type alias Data =
    { data : List Item
    , items : Int
    , perpage : Int
    }


type Msg
    = AddItems Item
    | HideCart
    | ClearCart Model
    | ToggleCart
    | GetItems (Result Http.Error Data)
    | InitItems (List Item)
    | RemoveItemFromCart Item
    | GetItemsAtPage Int
    | UrlChange Navigation.Location


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

        GetItems (Ok backendData) ->
            ( { model
                | items = backendData.data
                , itemsNumber = backendData.items
                , perpage = backendData.perpage
              }
            , Cmd.none
            )

        GetItems (Err error) ->
            Debug.log "error occured" (toString error)
                |> always ( model, Cmd.none )

        GetItemsAtPage page ->
            ( model, getItemsAtPage page )

        InitItems items ->
            ( { model | cartItems = items }, Cmd.none )

        RemoveItemFromCart item ->
            ( removeItemFromCart item model, removeItemsFromCart item )

        UrlChange location ->
            ( { model | currentPage = location.hash }
            , Cmd.none
            )


getItems : Cmd Msg
getItems =
    let
        url =
            backend_address ++ "/api/items"
    in
    Http.send
        GetItems
        (Http.get url itemsDecoder)


getItemsAtPage : Int -> Cmd Msg
getItemsAtPage page =
    let
        url =
            backend_address ++ "/api/items?page=" ++ toString page
    in
    Http.send
        GetItems
        (Http.get url itemsDecoder)


itemsDecoder : Decode.Decoder Data
itemsDecoder =
    Decode.map3 Data
        (field "data" <| Decode.list <| memberDecoder)
        (field "items" Decode.int)
        (field "perpage" Decode.int)


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
