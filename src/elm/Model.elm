module Model exposing (..)

import FrontPage.Main as MainPage
import Login.Main as Login
import Models.Models exposing (Item)


type Example
    = MainPage
    | Login


type alias Flags =
    { items : List Item
    }


type alias Model =
    { cartItems : List Item
    , hideCart : Bool
    , mainpage : MainPage.Model
    , login : Login.Model
    , currentExample : Example
    }


type Action
    = MainPageAction MainPage.Msg
    | LoginAction Login.Action
    | HideCart
    | ShowExample Example
    | NoOp
    | ToggleCart
    | ClearCart Model
    | AddItems Item
    | RemoveItemFromCart Item
