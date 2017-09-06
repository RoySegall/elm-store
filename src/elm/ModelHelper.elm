module ModelHelper exposing (..)

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


toggleCart : Model -> Bool -> Model
toggleCart model status =
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
