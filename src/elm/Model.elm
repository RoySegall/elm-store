module Model exposing (..)

import Navigation


type alias Flags =
    { items : List Item
    , accessToken : String
    , loggedInUser : LoggedUser
    }


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


type alias User =
    { username : String
    , password : String
    }


type alias LoggedUser =
    { id : String
    , username : String
    , image : String
    }


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
    , user : User
    , error : String
    , success : String
    , accessToken : String
    , loggedUser : LoggedUser
    }


type alias Data =
    { data : List Item
    , items : Int
    , perpage : Int
    }


type alias ErrorLogin =
    { message : String }


type alias ResultSuccessLogin =
    { data : SuccessLogin
    }


type alias SuccessLogin =
    { id : String
    , username : String
    , password : String
    , email : String
    , image : String
    , role : Role
    , token : Token
    , cart : Cart
    }


type alias Role =
    { title : String
    }


type alias Token =
    { token : String
    , expire : Int
    , refreshToken : String
    }


type alias Cart =
    { items : List Item
    }
