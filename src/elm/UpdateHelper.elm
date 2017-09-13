module UpdateHelper exposing (..)

import Config exposing (..)
import Decoder exposing (..)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Http exposing (..)
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (..)
import Model exposing (..)
import Navigation
import Ports exposing (..)
import Routing exposing (..)


removeItemsFromBackend : Model -> Item -> Cmd Msg
removeItemsFromBackend model item =
    let
        url =
            backend_address ++ "/api/cart/items"
    in
    HttpBuilder.delete url
        |> withExpect (Http.expectJson itemDecoder)
        |> withHeader "access-token" model.accessToken
        |> withMultipartStringBody
            [ ( "item_id", item.id )
            ]
        |> HttpBuilder.send AddItemDecoder


addItemToStorageInBackend : Model -> Item -> Cmd Msg
addItemToStorageInBackend model item =
    let
        url =
            backend_address ++ "/api/cart/items"
    in
    HttpBuilder.post url
        |> withExpect (Http.expectJson itemDecoder)
        |> withHeader "access-token" model.accessToken
        |> withMultipartStringBody
            [ ( "item_id", item.id )
            ]
        |> HttpBuilder.send AddItemDecoder


singleItemDecoder : Model -> Item -> Model
singleItemDecoder model decodedItem =
    let
        itemFromBackend : Item
        itemFromBackend =
            { description = decodedItem.description
            , id = decodedItem.id
            , price = decodedItem.price
            , image = decodedItem.image
            , title = decodedItem.title
            }
    in
    { model | selectedItem = itemFromBackend }


getItem : String -> Cmd Msg
getItem id =
    getItemFromBackend id


loadStuffFromBackend : Model -> Navigation.Location -> Cmd Msg
loadStuffFromBackend model location =
    let
        newRoute =
            parseLocation location

        message =
            case newRoute of
                HomeRoute ->
                    getItems

                Login ->
                    Cmd.none

                ItemPage id ->
                    getItemFromBackend id

                NotFoundRoute ->
                    Cmd.none
    in
    message


getItemFromBackend : String -> Cmd Msg
getItemFromBackend id =
    let
        url =
            backend_address ++ "/api/items/" ++ id
    in
    HttpBuilder.get url
        |> withExpect (Http.expectJson itemDecoder)
        |> HttpBuilder.send SingleItemDecoder


userLoginRequestSuccess : Model -> SuccessLogin -> Model
userLoginRequestSuccess model backendSuccessLogin =
    let
        loggedInUser : LoggedUser
        loggedInUser =
            { id = backendSuccessLogin.id
            , username = backendSuccessLogin.username
            , image = backendSuccessLogin.image
            }
    in
    { model
        | success = "Welcome " ++ backendSuccessLogin.username
        , accessToken = backendSuccessLogin.token.token
        , loggedUser = loggedInUser
    }


userLoginRequestError : Model -> Http.Error -> ( Model, Cmd Msg )
userLoginRequestError model error =
    let
        _ =
            Debug.log "" error
    in
    case error of
        Http.BadStatus s ->
            case Decode.decodeString loginErrorDecoder s.body of
                Ok { message } ->
                    ( { model | error = message }, Cmd.none )

                Err result ->
                    model ! []

        _ ->
            model ! []


userLoginForUpdate : Model -> Model
userLoginForUpdate model =
    { model | error = "", success = "" }


updateUsername : Model -> String -> Model
updateUsername model username =
    let
        user =
            model.user

        password =
            user.password
    in
    { model | user = { username = username, password = password } }


updatePassword : Model -> String -> Model
updatePassword model password =
    let
        user =
            model.user

        username =
            user.username
    in
    { model | user = { username = username, password = password } }


onLocationChange : Model -> Navigation.Location -> Model
onLocationChange model location =
    let
        newRoute =
            parseLocation location

        parseId =
            case newRoute of
                HomeRoute ->
                    ""

                Login ->
                    ""

                ItemPage id ->
                    id

                NotFoundRoute ->
                    ""
    in
    { model | id = parseId, route = newRoute }


initItems : Model -> List Item -> Model
initItems model items =
    { model | cartItems = items }


getItemsAtPageForUpdate : Model -> Int -> Model
getItemsAtPageForUpdate model page =
    { model | currentPage = page }


getItemsError : Model -> Http.Error -> Model
getItemsError model error =
    Debug.log "error occured" (toString error)
        |> always model


processItemsFromBackend : Model -> Data -> Model
processItemsFromBackend model backendData =
    { model
        | items = backendData.data
        , itemsNumber = backendData.items
        , perpage = backendData.perpage
    }


hideCart : Model -> Model
hideCart model =
    { model | hideCart = True }


toggleCart : Model -> Model
toggleCart model =
    let
        status =
            if model.hideCart then
                False
            else
                True
    in
    { model | hideCart = status }


clearCart : Model -> Model
clearCart model =
    { model | cartItems = [] }


addItems : Model -> Item -> Model
addItems model item =
    { model
        | cartItems = model.cartItems ++ [ item ]
    }


logout : Model -> Model
logout model =
    { model | accessToken = "" }


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


removeItemFromCart : Model -> Item -> Model
removeItemFromCart model item =
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
