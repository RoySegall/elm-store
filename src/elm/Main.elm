module Main exposing (..)

import ExampleViewer exposing (..)
import Model exposing (..)
import RouteUrl exposing (RouteUrlProgram)


main : RouteUrlProgram Flags Model Action
main =
    RouteUrl.programWithFlags
        { delta2url = ExampleViewer.delta2url
        , location2messages = ExampleViewer.url2messages
        , init = ExampleViewer.init
        , update = ExampleViewer.update
        , view = ExampleViewer.view
        , subscriptions = ExampleViewer.subscriptions
        }
