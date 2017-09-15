module Routing exposing (..)

import Model exposing (..)
import Navigation
import UrlParser exposing (..)


--- routing


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map HomeRoute UrlParser.top
        , UrlParser.map Login (UrlParser.s "login")
        , UrlParser.map ItemPage (UrlParser.s "item" </> string)
        , UrlParser.map UserProfile (UrlParser.s "profile")
        ]


{-| Match a location given by the Navigation package and return the matched route.
-}
parseLocation : Navigation.Location -> Route
parseLocation location =
    case UrlParser.parseHash matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
