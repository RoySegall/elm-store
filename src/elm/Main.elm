module Main exposing (..)

import Components.User exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import Navigation exposing (..)
import Ports exposing (..)
import Routing exposing (..)
import Update exposing (..)
import UpdateHelper exposing (..)
import Views.Checkout
import Views.Item
import Views.Items
import Views.Login
import Views.NotFound
import Views.Profile


-- MODEL


{-| initialModel will be called with the current matched route.
We store this in the model so we can display the corrent view.
-}
userObject : User
userObject =
    { username = ""
    , password = ""
    }


selectedItem : Item
selectedItem =
    { description = "", id = "", price = 0, image = "", title = "" }


initialModel : Route -> List Item -> String -> LoggedUser -> String -> Model
initialModel route items accessToken loggedInUer backendAddress =
    let
        id =
            case route of
                HomeRoute ->
                    ""

                Login ->
                    ""

                ItemPage id ->
                    id

                UserProfile ->
                    ""

                Checkout ->
                    ""

                NotFoundRoute ->
                    ""
    in
    { route = route
    , cartItems = items
    , items = []
    , accessToken = accessToken
    , hideCart = True
    , text = ""
    , itemsNumber = 0
    , perpage = 0
    , history = []
    , currentPage = 0
    , user = userObject
    , error = ""
    , success = ""
    , loggedUser = loggedInUer
    , id = id
    , selectedItem = selectedItem
    , backendAddress = backendAddress
    , checkoutStep = 1
    }



-- APP


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            parseLocation location

        method =
            case currentRoute of
                HomeRoute ->
                    getItems flags.backendAddress

                Login ->
                    Cmd.none

                ItemPage id ->
                    getItem flags.backendAddress id

                UserProfile ->
                    Cmd.none

                Checkout ->
                    Cmd.none

                NotFoundRoute ->
                    Cmd.none
    in
    ( initialModel currentRoute flags.items flags.accessToken flags.loggedInUser flags.backendAddress, method )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    getItemsFromStorage InitItems


page : Model -> Html Msg
page model =
    case model.route of
        HomeRoute ->
            Views.Items.view model

        Login ->
            Views.Login.view model

        ItemPage id ->
            Views.Item.view model

        UserProfile ->
            Views.Profile.view model

        Checkout ->
            Views.Checkout.view model

        NotFoundRoute ->
            Views.NotFound.view model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ nav [ class "navbar navbar-expand-lg navbar-light fixed-top", id "mainNav" ]
            [ div [ class "container" ]
                [ a [ class "navbar-brand js-scroll-trigger" ] [ a [ href "/#", onLinkClick (ChangeLocation "#") ] [ text "Go store" ] ]
                , div [ class "collapse navbar-collapse", id "navbarResponsive" ]
                    [ ul [ class "navbar-nav ml-auto" ]
                        [ li [ class "nav-item" ] [ userBar model ]
                        , li [ class "nav-item cart-wrapper" ] [ cart model ]
                        ]
                    ]
                ]
            ]
        , page model
        , section [ class "contact bg-primary", onClick HideCart ]
            [ div [ class "container" ]
                [ h2 []
                    [ span [] [ text "Did you " ]
                    , i [ class "fa fa-heart" ] []
                    , span [] [ text " one of our books?" ]
                    ]
                , ul [ class "list-inline list-social" ]
                    [ li [ class "list-inline-item social-twitter" ] [ a [] [ i [ class "fa fa-twitter" ] [] ] ]
                    , li [ class "list-inline-item social-facebook" ] [ a [] [ i [ class "fa fa-facebook" ] [] ] ]
                    , li [ class "list-inline-item social-google-plus" ] [ a [] [ i [ class "fa fa-google-plus" ] [] ] ]
                    ]
                ]
            ]
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
