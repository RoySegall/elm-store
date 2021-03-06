module Update exposing (..)

import Model exposing (..)
import Navigation
import Ports exposing (addItemToStorage, changeCheckoutStep, logOut, removeItemsFromCart, removeItemsFromStorage, setAccessToken, setItemInLocalStorage, showDoneMessage)
import Update.Extra exposing (sequence)
import UpdateHelper exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            ( logout model, logOut () )

        ChangeCheckoutStep step ->
            ( { model | checkoutStep = step }, changeCheckoutStep step )

        CheckoutComplete ->
            let
                msgs =
                    if model.accessToken == "" then
                        [ ShowDoneMessage, RemoveItemsFromStorage ]
                    else
                        [ ShowDoneMessage, RemoveItemsFromStorage, RemoveItemsFromCartBackend ]
            in
                { model | cartItems = [] }
                    ! []
                    |> sequence update msgs

        ShowDoneMessage ->
            ( model, showDoneMessage () )

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

        RemoveItemsFromStorage ->
            ( model, removeItemsFromStorage () )

        RemoveItemsFromCartBackend ->
            ( model, removeItemsFromCartBackend model )

        ClearCart model ->
            let
                msgs =
                    if model.accessToken == "" then
                        [ RemoveItemsFromStorage ]
                    else
                        [ RemoveItemsFromStorage, RemoveItemsFromCartBackend ]
            in
                clearCart model
                    ! []
                    |> sequence update msgs

        ToggleCart ->
            ( toggleCart model, Cmd.none )

        HideCart ->
            ( hideCart model, Cmd.none )

        GetItems (Ok backendData) ->
            ( processItemsFromBackend model backendData, Cmd.none )

        GetItems (Err error) ->
            ( getItemsError model error, Cmd.none )

        GetItemsAtPage page ->
            ( getItemsAtPageForUpdate model page, getItemsAtPage model page )

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
            ( model, setItemInLocalStorage items )

        UserLoginRequest (Ok backendSuccessLogin) ->
            userLoginRequestSuccess model backendSuccessLogin
                ! []
                |> sequence update
                    [ SetAccessToken backendSuccessLogin
                    , SetItemInLocalStorage backendSuccessLogin.cart.items
                    ]

        SingleItemDecoder (Err httpErr) ->
            userLoginRequestError model httpErr

        SingleItemDecoder (Ok backendItem) ->
            ( singleItemDecoder model backendItem, Cmd.none )

        AddItemDecoder (Err httpErr) ->
            userLoginRequestError model httpErr

        AddItemDecoder (Ok backendItem) ->
            ( singleItemDecoder model backendItem, Cmd.none )
