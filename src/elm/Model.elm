module Model exposing (..)

import Example1.Counter as Example1
import Example2.CounterPair as Example2


type Example
    = Example1
    | Example2


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
    , example1 : Example1.Model
    , example2 : Example2.Model
    , currentExample : Example
    }


type Action
    = Example1Action Example1.Action
    | Example2Action Example2.Action
    | HideCart
    | ShowExample Example
    | NoOp
