module Routing exposing (..)

import Model exposing (..)
import Navigation
import UrlParser


--- routing


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map HomeRoute UrlParser.top
        , UrlParser.map Login (UrlParser.s "login")
        ]


{-| Match a location given by the Navigation package and return the matched route.
-}
parseLocation : Navigation.Location -> Route
parseLocation location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
