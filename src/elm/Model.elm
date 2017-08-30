module Model exposing (..)


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
    }
