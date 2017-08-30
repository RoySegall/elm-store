module Main exposing (..)

import ExampleViewer exposing (..)
import RouteUrl exposing (RouteUrlProgram)
import Model exposing (..)


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
