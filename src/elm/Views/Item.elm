module Views.Item exposing (..)

import Components.Items exposing (getAllItems, pager)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ class "content item" ]
        [ section [] [ text model.selectedItem.title ] ]
