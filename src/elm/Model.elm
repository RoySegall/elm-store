module Model exposing (..)

import Http
import Navigation


type Msg
    = AddItems Item
    | HideCart
    | ClearCart Model
    | ToggleCart
    | GetItems (Result Http.Error Data)
    | InitItems (List Item)
    | RemoveItemFromCart Item
    | GetItemsAtPage Int
    | OnLocationChange Navigation.Location
    | ChangeLocation String
    | UpdateUsername String
    | UpdatePassword String
    | UserLogin
    | UserLoginRequest (Result Http.Error SuccessLogin)
    | Logout
    | ChangeSelectedItem (Result Http.Error Data)
    | ChangeCurrentPage (Maybe String)


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
    | ItemPage String
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
    , id : Maybe String
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
    , selectedItem : Item
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
