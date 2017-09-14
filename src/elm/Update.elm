module Update exposing (..)

import Model exposing (..)
import Navigation
import Ports exposing (addItemToStorage, logOut, removeItemsFromCart, removeItemsFromStorage, setAccessToken)
import Update.Extra exposing (sequence)
import UpdateHelper exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            ( logout model, logOut () )

        AddItemToStorage item ->
            ( model, addItemToStorage item )

        AddItemToStorageInBackend item ->
            ( model, addItemToStorageInBackend model item )

        AddItems item ->
            let
                msgs =
                    if model.accessToken == "" then
                        [ AddItemToStorage item ]
                    else
                        [ AddItemToStorage item, AddItemToStorageInBackend item ]
            in
            addItems model item
                ! []
                |> sequence update msgs

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

        RemoveItemFromCartLocalStorage item ->
            ( model, removeItemsFromCart item )

        RemoveItemFromCartBackend item ->
            ( model, removeItemsFromBackend model item )

        RemoveItemFromCart item ->
            let
                msgs =
                    if model.accessToken == "" then
                        [ RemoveItemFromCartLocalStorage item ]
                    else
                        [ RemoveItemFromCartLocalStorage item, RemoveItemFromCartBackend item ]
            in
            removeItemFromCart model item
                ! []
                |> sequence update msgs

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

        SetAccessToken backendSuccessLogin ->
            ( model, setAccessToken backendSuccessLogin )

        SetItemInLocalStorage items ->
            ( model, Cmd.none )

        UserLoginRequest (Ok backendSuccessLogin) ->
            let
                msgs =
                    if model.accessToken == "" then
                        [ SetAccessToken backendSuccessLogin ]
                    else
                        [ SetAccessToken backendSuccessLogin, SetItemInLocalStorage backendSuccessLogin.cart.items ]
            in
            userLoginRequestSuccess model backendSuccessLogin
                ! []
                |> sequence update msgs

        SingleItemDecoder (Err httpErr) ->
            userLoginRequestError model httpErr

        SingleItemDecoder (Ok backendItem) ->
            ( singleItemDecoder model backendItem, Cmd.none )

        AddItemDecoder (Err httpErr) ->
            userLoginRequestError model httpErr

        AddItemDecoder (Ok backendItem) ->
            ( singleItemDecoder model backendItem, Cmd.none )
