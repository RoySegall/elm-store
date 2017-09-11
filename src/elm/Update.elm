module Update exposing (..)

import Config exposing (..)
import Decoder exposing (itemsDecoder, loginErrorDecoder, loginSuccessDecoder)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Http exposing (..)
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (..)
import Model exposing (..)
import Navigation
import Ports exposing (addItemToStorage, logOut, removeItemsFromCart, removeItemsFromStorage, setAccessToken)
import Routing exposing (..)
import Task
import UpdateHelper exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            ( logout model, logOut () )

        AddItems item ->
            let
                msgs =
                    Http.toTask
                        |> Task.andThen (addItemToStorage item)
                        |> Task.andThen (addItemToStorageInBackend item)

                action =
                    if model.accessToken == "" then
                        addItemToStorage item
                    else
                        Task.perform (addItemToStorage item) (addItemToStorageInBackend item)
            in
            ( addItems model item, action )

        ClearCart model ->
            ( clearCart model, removeItemsFromStorage () )

        ToggleCart ->
            ( toggleCart model, Cmd.none )

        HideCart ->
            ( hideCart model, Cmd.none )

        GetItems (Ok backendData) ->
            ( processItemsFromBackend model backendData, Cmd.none )

        GetItems (Err error) ->
            ( getItemsError model error, Cmd.none )

        GetItemsAtPage page ->
            ( getItemsAtPageForUpdate model page, getItemsAtPage page )

        InitItems items ->
            ( initItems model items, Cmd.none )

        RemoveItemFromCart item ->
            ( removeItemFromCart model item, removeItemsFromCart item )

        ChangeLocation path ->
            ( model, Navigation.newUrl path )

        OnLocationChange location ->
            ( onLocationChange model location, loadStuffFromBackend model location )

        UpdateUsername username ->
            ( updateUsername model username, Cmd.none )

        UpdatePassword password ->
            ( updatePassword model password, Cmd.none )

        UserLogin ->
            ( userLoginForUpdate model, userLogin model )

        UserLoginRequest (Err httpErr) ->
            userLoginRequestError model httpErr

        UserLoginRequest (Ok backendSuccessLogin) ->
            ( userLoginRequestSuccess model backendSuccessLogin, setAccessToken backendSuccessLogin )

        SingleItemDecoder (Err httpErr) ->
            userLoginRequestError model httpErr

        SingleItemDecoder (Ok backendItem) ->
            ( singleItemDecoder model backendItem, Cmd.none )
