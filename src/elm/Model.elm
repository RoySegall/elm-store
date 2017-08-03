module Model exposing (..)


type alias Item =
    { id : String
    , title : String
    , description : String
    , price : Float
    , image : String
    }


type alias Model =
    { cartItems : Int
    }
