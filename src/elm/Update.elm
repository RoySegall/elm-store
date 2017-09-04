module Update exposing (..)

import Config exposing (..)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Http exposing (..)
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode
import Model exposing (..)
import Navigation
import Ports exposing (addItemToStorage, removeItemsFromCart, removeItemsFromStorage)
import Routing exposing (..)
import UrlParser


-- UPDATE


type alias Data =
    { data : List Item
    , items : Int
    , perpage : Int
    }


type alias ErrorLogin =
    { message : String }


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
    | UserLoginRequest (Result Http.Error Data)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddItems item ->
            ( { model
                | cartItems = model.cartItems ++ [ item ]
              }
            , addItemToStorage item
            )

        ClearCart model ->
            ( { model | cartItems = [] }, removeItemsFromStorage () )

        ToggleCart ->
            if model.hideCart then
                ( { model | hideCart = False }, Cmd.none )
            else
                ( { model | hideCart = True }, Cmd.none )

        HideCart ->
            ( { model | hideCart = True }, Cmd.none )

        GetItems (Ok backendData) ->
            ( { model
                | items = backendData.data
                , itemsNumber = backendData.items
                , perpage = backendData.perpage
              }
            , Cmd.none
            )

        GetItems (Err error) ->
            Debug.log "error occured" (toString error)
                |> always ( model, Cmd.none )

        GetItemsAtPage page ->
            ( { model | currentPage = page }, getItemsAtPage page )

        InitItems items ->
            ( { model | cartItems = items }, Cmd.none )

        RemoveItemFromCart item ->
            ( removeItemFromCart item model, removeItemsFromCart item )

        ChangeLocation path ->
            ( model, Navigation.newUrl path )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        UpdateUsername username ->
            let
                user =
                    model.user

                password =
                    user.password
            in
                ( { model | user = { username = username, password = password } }, Cmd.none )

        UpdatePassword password ->
            let
                user =
                    model.user

                username =
                    user.username
            in
                ( { model | user = { username = username, password = password } }, Cmd.none )

        UserLogin ->
            ( model, userLogin model )

        UserLoginRequest (Err httpErr) ->
            let
                _ =
                    Debug.log "" httpErr
            in
                case httpErr of
                    Http.BadStatus s ->
                        case Decode.decodeString loginErrorDecoder s.body of
                            Ok { message } ->
                                ( { model | error = message }, Cmd.none )

                            Err result ->
                                model ! []

                    _ ->
                        model ! []

        UserLoginRequest (Ok backendData) ->
            ( { model
                | success = "a"
              }
            , Cmd.none
            )


loginErrorDecoder : Decode.Decoder ErrorLogin
loginErrorDecoder =
    Decode.map ErrorLogin
        (field "message" Decode.string)


loginSuccessDecoder : Decode.Decoder SuccessLogin
loginSuccessDecoder =
    Decode.at [ "data" ] <| loginDecoder


loginDecoder : Decode.Decoder SuccessLogin
loginDecoder =
    Decode.map7 SuccessLogin
        (field "Id" Decode.string)
        (field "Username" Decode.string)
        (field "Password" Decode.string)
        (field "Email" Decode.string)
        (field "Image" Decode.string)
        (field "Role" <| roleDecoder)
        (field "Token" <| tokenDecoder)
        (field "Cart" <| Decode.list <| memberDecoder)


tokenDecoder : Decode.Decoder Token
tokenDecoder =
    Decode.map3 Role
        (field "Token" Decode.string)
        (field "Expire" Decode.int)
        (field "RefreshToken" Decode.string)


roleDecoder : Decode.Decoder Role
roleDecoder =
    Decode.map Role
        (field "Title" Decode.string)


cartDecoder : Decode.Decoder Cart
cartDecoder =
    Decode.map Cart
        (field "Id" Decode.string)


userLoginEncoder : User -> Encode.Value
userLoginEncoder user =
    Encode.object
        [ ( "username", Encode.string user.username )
        , ( "password", Encode.string user.password )
        ]


userLogin : Model -> Cmd Msg
userLogin model =
    let
        url =
            backend_address ++ "/api/user/login"
    in
        HttpBuilder.post url
            |> withExpect (Http.expectJson loginSuccessDecoder)
            |> withMultipartStringBody
                [ ( "username", model.user.username )
                , ( "password", model.user.password )
                ]
            |> HttpBuilder.send UserLoginRequest


handleRequestComplete : Result Http.Error (List String) -> Cmd Msg
handleRequestComplete result =
    let
        url =
            backend_address ++ "/api/items"
    in
        Http.send
            GetItems
            (Http.get url itemsDecoder)


getItems : Cmd Msg
getItems =
    let
        url =
            backend_address ++ "/api/items"
    in
        Http.send
            GetItems
            (Http.get url itemsDecoder)


getItemsAtPage : Int -> Cmd Msg
getItemsAtPage page =
    let
        url =
            backend_address ++ "/api/items?page=" ++ toString page
    in
        Http.send
            GetItems
            (Http.get url itemsDecoder)


itemsDecoder : Decode.Decoder Data
itemsDecoder =
    Decode.map3 Data
        (field "data" <| Decode.list <| memberDecoder)
        (field "items" Decode.int)
        (field "perpage" Decode.int)


memberDecoder : Decode.Decoder Item
memberDecoder =
    Decode.map5 Item
        (field "Id" Decode.string)
        (field "Title" Decode.string)
        (field "Description" Decode.string)
        (field "Price" Decode.float)
        (field "Image" Decode.string)


removeItemFromCart : Item -> Model -> Model
removeItemFromCart item model =
    { model
        | cartItems =
            List.filter (\i -> not (i.id == item.id)) model.cartItems
    }


{-| When clicking a link we want to prevent the default browser behaviour which is to load a new page.
So we use `onWithOptions` instead of `onClick`.
-}
onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
        onWithOptions "click" options (Decode.succeed message)
