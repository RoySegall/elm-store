module Update exposing (..)

import Config exposing (..)
import Decoder exposing (itemsDecoder, loginErrorDecoder, loginSuccessDecoder)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Http exposing (..)
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode
import Model exposing (..)
import Navigation
import Ports exposing (addItemToStorage, logOut, removeItemsFromCart, removeItemsFromStorage, setAccessToken)
import Routing exposing (..)


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            ( { model | accessToken = "" }, logOut () )

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
            ( { model | error = "", success = "" }, userLogin model )

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

        UserLoginRequest (Ok backendSuccessLogin) ->
            let
                loggedInUser : LoggedUser
                loggedInUser =
                    { id = backendSuccessLogin.id
                    , username = backendSuccessLogin.username
                    , image = backendSuccessLogin.image
                    }
            in
            ( { model
                | success = "Welcome " ++ backendSuccessLogin.username
                , accessToken = backendSuccessLogin.token.token
                , loggedUser = loggedInUser
              }
            , setAccessToken backendSuccessLogin
            )


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


removeItemFromCart : Item -> Model -> Model
removeItemFromCart item model =
    { model
        | cartItems =
            List.filter (\i -> not (i.id == item.id)) model.cartItems
    }


onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
    onWithOptions "click" options (Decode.succeed message)
