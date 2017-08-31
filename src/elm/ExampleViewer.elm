module ExampleViewer exposing (..)

-- Note that I'm renaming these locally for simplicity.

import Components.Items exposing (currentItems)
import Components.User exposing (userBar)
import Example1.Counter as Example1
import Example2.CounterPair as Example2
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (length)
import Model exposing (..)
import Navigation exposing (..)
import Ports exposing (addItemToStorage, removeItemsFromCart, removeItemsFromStorage)
import RouteHash exposing (HashUpdate)
import RouteUrl exposing (UrlChange)
import RouteUrl.Builder as Builder exposing (Builder)
import Update exposing (removeItemFromCart)


-- MODEL


{-| Now, to init our model, we have to collect each examples init
-}
init : Flags -> ( Model, Cmd Action )
init flags =
    let
        model =
            { example1 = Example1.init
            , example2 = Example2.init
            , currentExample = Example1
            , cartItems = flags.items
            , items = []
            , hideCart = True
            , text = ""
            , itemsNumber = 0
            , perpage = 0
            }
    in
    ( model, Cmd.none )



-- SUBSCRIPTIONS


{-| I happen to know that only Example8 uses them
-}
subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none



-- UPDATE


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        ShowExample example ->
            ( { model | currentExample = example }
            , Cmd.none
            )

        HideCart ->
            ( { model | hideCart = True }, Cmd.none )

        Example1Action subaction ->
            ( { model | example1 = Example1.update subaction model.example1 }
            , Cmd.none
            )

        Example2Action subaction ->
            ( { model | example2 = Example2.update subaction model.example2 }
            , Cmd.none
            )

        ToggleCart ->
            if model.hideCart then
                ( { model | hideCart = False }, Cmd.none )
            else
                ( { model | hideCart = True }, Cmd.none )

        ClearCart model ->
            ( { model | cartItems = [] }, removeItemsFromStorage () )

        AddItems item ->
            ( { model
                | cartItems = model.cartItems ++ [ item ]
              }
            , addItemToStorage item
            )

        RemoveItemFromCart item ->
            ( removeItemFromCart item model, removeItemsFromCart item )



-- VIEW


(=>) =
    (,)


cart : Model -> Html Action
cart model =
    div
        [ class "cart-component" ]
        [ a [ onClick ToggleCart ]
            [ span [ class "shopping-cart" ] [ text "Shopping cart" ]
            , span [ class "shopping-cart-counter" ] [ text (toString (length model.cartItems)) ]
            ]
        , currentItems model
        ]


view : Model -> Html Action
view model =
    let
        viewExample =
            case model.currentExample of
                Example1 ->
                    Html.map Example1Action (Example1.view model.example1)

                Example2 ->
                    Html.map Example2Action (Example2.view model.example2)
    in
    div []
        [ nav [ class "navbar navbar-expand-lg navbar-light fixed-top", id "mainNav" ]
            [ div [ class "container" ]
                [ a [ class "navbar-brand js-scroll-trigger" ] [ text "Go store" ]
                , div [ class "collapse navbar-collapse", id "navbarResponsive" ]
                    [ ul [ class "navbar-nav ml-auto" ]
                        [ li [ class "nav-item" ] [ userBar ]
                        , li [ class "nav-item cart-wrapper" ] [ cart model ]
                        ]
                    ]
                ]
            ]
        , section [ class "download bg-primary text-center", id "download", onClick HideCart ]
            [ div [ class "container" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-8 mx-auto" ]
                        [ h2 [ class "section-heading" ] [ text "Discover what all the buzz is about!" ]
                        , p [] [ text "Our app is available on any mobile device! Download now to get started!" ]
                        , div [ class "badges" ]
                            [ a [ class "badge-link" ] [ img [ src "static/img/google-play-badge.svg" ] [] ]
                            , a [ class "badge-link" ] [ img [ src "static/img/app-store-badge.svg" ] [] ]
                            ]
                        ]
                    ]
                ]
            ]
        , div []
            [ ul []
                [ li [ onClick (ShowExample Example1) ] [ text "Count 1" ]
                , li [ onClick (ShowExample Example2) ] [ text "counter 2" ]
                ]
            ]
        , div [] [ viewExample ]
        , footer []
            [ div [ class "container", onClick HideCart ]
                [ p [] [ text "Created by Roy Segall" ]
                , ul [ class "list-inline" ]
                    [ li [ class "fa fa-github" ] []
                    , a [ href "https://github.com/roysegall/go-store" ] [ text "Fork the backend" ]
                    , li [ class "fa fa-github" ] []
                    , a [ href "https://github.com/roysegall/elm-store" ] [ text "Fork this frontend" ]
                    ]
                ]
            ]
        ]


{-| This is an example of the new API, if using the whole URL
-}
delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    -- We're using a `Builder` to build up the possible change. You don't
    -- have to do that ... you can construct a `UrlChange` however you like.
    --
    -- So, as the last step, we map our possible `Builder` to a `UrlChange`.
    Maybe.map Builder.toUrlChange <|
        delta2builder previous current


{-| An example of the new API, if just using the hash
-}
delta2hash : Model -> Model -> Maybe UrlChange
delta2hash previous current =
    -- Here, we're re-using the Builder-oriented code, but stuffing everything
    -- into the hash (rather than actually using the full URL).
    Maybe.map Builder.toHashChange <|
        delta2builder previous current


{-| This is the common code that we rely on above. Again, you don't have to use
a `Builder` if you don't want to ... it's just one way to construct a `UrlChange`.
-}
delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    case current.currentExample of
        Example1 ->
            -- First, we ask the submodule for a `Maybe Builder`. Then, we use
            -- `map` to prepend something to the path.
            Example1.delta2builder previous.example1 current.example1
                |> Maybe.map (Builder.prependToPath [ "home" ])

        Example2 ->
            Example2.delta2builder previous.example2 current.example2
                |> Maybe.map (Builder.prependToPath [ "login" ])


{-| This is an example of a `location2messages` function ... I'm calling it
`url2messages` to illustrate something that uses the full URL.
-}
url2messages : Location -> List Action
url2messages location =
    -- You can parse the `Location` in whatever way you want. I'm making
    -- a `Builder` and working from that, but I'm sure that's not the
    -- best way. There are links to a number of proper parsing packages
    -- in the README.
    builder2messages (Builder.fromUrl location.href)


{-| This is an example of a `location2messages` function ... I'm calling it
`hash2messages` to illustrate something that uses just the hash.
-}
hash2messages : Location -> List Action
hash2messages location =
    -- You can parse the `Location` in whatever way you want. I'm making
    -- a `Builder` and working from that, but I'm sure that's not the
    -- best way. There are links to a number of proper parsing packages
    -- in the README.
    builder2messages (Builder.fromHash location.href)


{-| Another example of a `location2messages` function, this time only using the hash.
-}
builder2messages : Builder -> List Action
builder2messages builder =
    -- You can parse the `Location` in whatever way you want ... there are a
    -- number of parsing packages listed in the README. Here, I'm constructing
    -- a `Builder` and working from that, but that's probably not the best
    -- thing to do.
    case Builder.path builder of
        first :: rest ->
            let
                subBuilder =
                    Builder.replacePath rest builder
            in
            case first of
                "home" ->
                    -- We give the Example1 module a chance to interpret
                    -- the rest of the location, and then we prepend an
                    -- action for the part we interpreted.
                    ShowExample Example1 :: List.map Example1Action (Example1.builder2messages subBuilder)

                "login" ->
                    ShowExample Example2 :: List.map Example2Action (Example2.builder2messages subBuilder)

                _ ->
                    -- Normally, you'd want to show an error of some kind here.
                    -- But, for the moment, I'll just default to example1
                    [ ShowExample Example1 ]

        _ ->
            -- Normally, you'd want to show an error of some kind here.
            -- But, for the moment, I'll just default to example1
            [ ShowExample Example1 ]
