module FrontPage.Main exposing (..)

--import Model exposing (Item, Model)

import Config exposing (backend_address)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (..)
import Models.Models exposing (Item)
import RouteHash exposing (HashUpdate)
import RouteUrl.Builder exposing (Builder, builder, path, replacePath)
import String exposing (toInt)


type alias Model =
    { items : List Item
    , hideCart : Bool
    , text : String
    , itemsNumber : Int
    , perpage : Int
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { items = []
            , hideCart = True
            , text = ""
            , itemsNumber = 0
            , perpage = 0
            }
    in
    ( model
    , getItems
    )



-- UPDATE


type alias Data =
    { data : List Item
    , items : Int
    , perpage : Int
    }


type Msg
    = GetItems (Result Http.Error Data)
      --    | InitItems (List Item)
    | GetItemsAtPage Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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



--
--        InitItems items ->
--            ( { model | cartItems = items }, Cmd.none )


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



-- VIEW


view : Model -> Html Msg
view model =
    section [ class "features" ]
        [ div []
            [ div [ class "section-heading text-center" ]
                [ h2 [] [ text "Browse our books" ]
                , p [] [ text "We have a huge library. You probably find something!" ]
                , i [ class "icon-screen-smartphone text-primary" ] []
                ]
            , div [ class "container main" ]
                [ div [ class "row" ]
                    [ {- div [ class "col-md-12" ] [ getAllItems model.items ]
                         ,
                      -}
                      div [ class "col-md-12" ] [ itemsPager model.itemsNumber model.perpage ]
                    ]
                ]
            ]
        ]



-- Items pager


itemsPager : Int -> Int -> Html Msg
itemsPager items_number perpage =
    let
        pages =
            floor (toFloat items_number / toFloat perpage)
    in
    div
        []
        [ a [ onClick (GetItemsAtPage 0) ] [ text "First" ], pager 0 pages, a [ onClick (GetItemsAtPage pages) ] [ text "Last" ] ]


pager : Int -> Int -> Html Msg
pager page max_items =
    let
        items =
            if page > max_items then
                Html.text ""
            else
                span [] [ a [ onClick (GetItemsAtPage page) ] [ text (toString (page + 1)) ], pager (page + 1) max_items ]
    in
    div [] [ items ]


countStyle : Attribute any
countStyle =
    style
        [ ( "font-size", "20px" )
        , ( "font-family", "monospace" )
        , ( "display", "inline-block" )
        , ( "width", "50px" )
        , ( "text-align", "center" )
        ]


{-| We add a separate function to get a title, which the ExampleViewer uses to
construct a table of contents. Sometimes, you might have a function of this
kind return `Html` instead, depending on where it makes sense to do some of
the construction.
-}
title : String
title =
    "Counter"



-- Routing (Old API)


{-| For delta2update, we provide our state as the value for the URL.
-}
delta2update : Model -> Model -> Maybe HashUpdate
delta2update previous current =
    Just <|
        RouteHash.set [ toString current ]


{-| For location2action, we generate an action that will restore our state.
-}
location2action : List String -> List Action
location2action list =
    case list of
        first :: rest ->
            case toInt first of
                Ok value ->
                    [ Set value ]

                Err _ ->
                    -- If it wasn't an integer, then no action ... we could
                    -- show an error instead, of course.
                    []



-- Routing (New API)


delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    builder
        |> replacePath [ toString current ]
        |> Just


builder2messages : Builder -> List Action
builder2messages builder =
    case path builder of
        first :: rest ->
            case toInt first of
                Ok value ->
                    [ Set value ]

                Err _ ->
                    -- If it wasn't an integer, then no action ... we could
                    -- show an error instead, of course.
                    []

        _ ->
            -- If nothing provided for this part of the URL, return empty list
            []
