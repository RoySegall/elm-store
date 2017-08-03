module Main exposing (..)

import Components.Items exposing (items)
import Html exposing (..)
import Html.Attributes exposing (..)

-- component import example

import Components.User exposing (..)


-- APP


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
  { cartItems : Int
  }



model : Model
model =
  {
    cartItems = 0
  }


-- UPDATE


type Msg
    = Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model.cartItems + 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container main" ]
        [ div [ class "row upper-strip" ]
            [ div [ class "col-md-12" ]
                [ div [ class "row content-upper" ]
                    [ div [ class "col-md-10" ]
                        [ span [ class "logo" ] [ text "GoStore" ]
                        ]
                    , div [ class "col-md-2" ]
                        [ div [ class "row" ]
                            [ div [ class "col-md-6" ] [ cart 0 ]
                            , div [ class "col-md-6" ] [ userBar ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "row content" ]
            [ div [ class "col-md-12" ]
                [ div [ class "jumbotron" ]
                    [ items
                    ]
                ]
            ]
        ]
