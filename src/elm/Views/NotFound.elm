module Views.NotFound exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    section [ class "not-found" ]
        [ div [ class "first" ] [ img [ src "static/img/storm.png" ] [] ]
        , div [ class "second" ]
            [ h1 [] [ text "This is not the page you are looking for" ]
            , p []
                [ text
                    ("It look that the force has brought you in a bad way to this page."
                        ++ "Don't be afraid of that. Fear is the path to the dark side. "
                        ++ "Fear leads to anger. Anger leads to hate. Hate leads to suffering."
                    )
                ]
            ]
        ]
