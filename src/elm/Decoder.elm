module Decoder exposing (..)

import Json.Decode as Decode exposing (..)
import Model exposing (..)


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


loginErrorDecoder : Decode.Decoder ErrorLogin
loginErrorDecoder =
    Decode.map ErrorLogin
        (field "message" Decode.string)


loginSuccessDecoder : Decode.Decoder SuccessLogin
loginSuccessDecoder =
    Decode.at [ "data" ] <| loginDecoder


loginDecoder : Decode.Decoder SuccessLogin
loginDecoder =
    Decode.map8 SuccessLogin
        (field "Id" Decode.string)
        (field "Username" Decode.string)
        (field "Password" Decode.string)
        (field "Email" Decode.string)
        (field "Image" Decode.string)
        (field "Role" <| roleDecoder)
        (field "Token" <| tokenDecoder)
        (field "Cart" <| cartDecoder)


tokenDecoder : Decode.Decoder Token
tokenDecoder =
    Decode.map3 Token
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
        (field "Items" <| Decode.list <| memberDecoder)
