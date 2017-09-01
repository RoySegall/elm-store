module Model exposing (..)

import Navigation


type alias Item =
    { id : String
    , title : String
    , description : String
    , price : Float
    , image : String
    }


type Route
    = HomeRoute
    | Login
    | NotFoundRoute


type alias Model =
    { cartItems : List Item
    , items : List Item
    , hideCart : Bool
    , text : String
    , itemsNumber : Int
    , perpage : Int
    , history : List Navigation.Location
    , currentPage : Int
    , route : Route
    }
