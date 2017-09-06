module Update exposing (..)

import Config exposing (..)
import Decoder exposing (itemsDecoder, loginErrorDecoder, loginSuccessDecoder)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Http exposing (..)
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (..)
import Model exposing (..)
import ModelHelper exposing (..)
import Navigation
import Ports exposing (addItemToStorage, logOut, removeItemsFromCart, removeItemsFromStorage, setAccessToken)
import Routing exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            ( logout model, logOut () )

        AddItems item ->
            ( addItems model item, addItemToStorage item )

        ClearCart model ->
            ( clearCart model, removeItemsFromStorage () )

        ToggleCart ->
            let
                status =
                    if model.hideCart then
                        False
                    else
                        True
            in
            ( toggleCart model status, Cmd.none )

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
