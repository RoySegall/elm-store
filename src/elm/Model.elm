module Model exposing (..)

import FrontPage.Main as MainPage
import Login.Main as Login


type Example
    = MainPage
    | Login


type alias Item =
    { id : String
    , title : String
    , description : String
    , price : Float
    , image : String
    }


type alias Flags =
    { items : List Item
    }


type alias Model =
    { cartItems : List Item
    , items : List Item
    , hideCart : Bool
    , text : String
    , itemsNumber : Int
    , perpage : Int
    , mainpage : MainPage.Model
    , login : Login.Model
    , currentExample : Example
    }


type Action
    = MainPageAction MainPage.Action
    | LoginAction Login.Action
    | HideCart
    | ShowExample Example
    | NoOp
    | ToggleCart
    | ClearCart Model
    | AddItems Item
    | RemoveItemFromCart Item
