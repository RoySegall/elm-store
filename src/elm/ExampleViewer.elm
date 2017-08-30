module ExampleViewer exposing (..)

-- Note that I'm renaming these locally for simplicity.

import Example1.Counter as Example1
import Example2.CounterPair as Example2
import Html exposing (Html, div, map, p, table, td, text, tr)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Navigation exposing (..)
import RouteHash exposing (HashUpdate)
import RouteUrl exposing (UrlChange)
import RouteUrl.Builder as Builder exposing (Builder)


-- MODEL


{-| We'll need to know which example we're showing at the moment.
-}
type Example
    = Example1
    | Example2


{-| We need to collect all the data that each example wants to track. Now, we
could do this in a couple of ways. If we want to remember all the data as we
display one thing or another, we would do this as a record. If we wanted to
only remember the data that we're currently looking at, we might do this as
a union type. I'll do it the record way for now.

In a real app, you are likely to divide the model into parts which are
"permanent" (in the sense that the app needs to remember them, no matter
what the user is looking at now), and parts that are "transient" (which need
to be remembered, but only while the user is looking at a particular thing).
So, in that cae, some things would be in a record, whereas other things would
be in a union type.

-}
type alias Model =
    { example1 : Example1.Model
    , example2 : Example2.Model

    -- And, we need to track which example we're actually showing
    , currentExample : Example
    }


{-| Now, to init our model, we have to collect each examples init
-}
init : ( Model, Cmd Action )
init =
    let
        model =
            { example1 = Example1.init
            , example2 = Example2.init
            , currentExample = Example1
            }
    in
        ( model, Cmd.none )



-- SUBSCRIPTIONS


{-| I happen to know that only Example8 uses them
-}
subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none



-- UPDATE


type Action
    = Example1Action Example1.Action
    | Example2Action Example2.Action
    | ShowExample Example
    | NoOp


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        ShowExample example ->
            ( { model | currentExample = example }
            , Cmd.none
            )

        Example1Action subaction ->
            ( { model | example1 = Example1.update subaction model.example1 }
            , Cmd.none
            )

        Example2Action subaction ->
            ( { model | example2 = Example2.update subaction model.example2 }
            , Cmd.none
            )



-- VIEW


(=>) =
    (,)


view : Model -> Html Action
view model =
    let
        viewExample =
            case model.currentExample of
                Example1 ->
                    map Example1Action (Example1.view model.example1)

                Example2 ->
                    map Example2Action (Example2.view model.example2)

        makeTitle ( index, example, title ) =
            let
                styleList =
                    if example == model.currentExample then
                        [ "font-weight" => "bold"
                        ]
                    else
                        [ "font-weight" => "normal"
                        , "color" => "blue"
                        , "cursor" => "pointer"
                        ]

                -- Note that we compose the full title out of some information the
                -- super-module knows about (the index) and some information the
                -- sub-module knows about (the title)
                fullTitle =
                    text <|
                        "Example "
                            ++ toString index
                            ++ ": "
                            ++ title

                -- If we're already on a page, we don't have a click action
                clickAction =
                    if example == model.currentExample then
                        []
                    else
                        [ onClick (ShowExample example) ]
            in
                p (style styleList :: clickAction)
                    [ fullTitle ]

        toc =
            div [] <|
                List.map makeTitle
                    [ ( 1, Example1, Example1.title )
                    , ( 2, Example2, Example2.title )
                    ]
    in
        table []
            [ tr []
                [ td
                    [ style
                        [ "vertical-align" => "top"
                        , "width" => "25%"
                        , "padding" => "8px"
                        , "margin" => "8px"
                        ]
                    ]
                    [ toc ]
                , td
                    [ style
                        [ "vertical-align" => "top"
                        , "width" => "75%"
                        , "padding" => "8px"
                        , "margin" => "8px"
                        , "border" => "1px dotted black"
                        ]
                    ]
                    [ viewExample ]
                ]
            ]



-- ROUTING
--
-- I've include demo code here for the old API, as well as the new API
-- using the full URL or just using the hash. Just to be completely clear,
-- you don't need all of these in practice ... you just pick one!
--
--------------------
-- Old RouteHash API
--------------------


{-| If you have existing code using elm-route-hash, your `delta2update` function
should not require any changes.
-}
delta2update : Model -> Model -> Maybe HashUpdate
delta2update previous current =
    case current.currentExample of
        Example1 ->
            -- First, we ask the submodule for a HashUpdate. Then, we use
            -- `map` to prepend something to the URL.
            RouteHash.map ((::) "example-1") <|
                Example1.delta2update previous.example1 current.example1

        Example2 ->
            RouteHash.map ((::) "example-2") <|
                Example2.delta2update previous.example2 current.example2


{-| Here, we basically do the reverse of what delta2update does. If you
have existing code using elm-route-hash, your `location2action` function
should not require any changes.
-}
location2action : List String -> List Action
location2action list =
    case list of
        "example-1" :: rest ->
            -- We give the Example1 module a chance to interpret the rest of
            -- the URL, and then we prepend an action for the part we
            -- interpreted.
            ShowExample Example1 :: List.map Example1Action (Example1.location2action rest)

        "example-2" :: rest ->
            ShowExample Example2 :: List.map Example2Action (Example2.location2action rest)

        _ ->
            -- Normally, you'd want to show an error of some kind here.
            -- But, for the moment, I'll just default to example1
            [ ShowExample Example1 ]



-------------------
-- New RouteUrl API
-------------------


{-| This is an example of the new API, if using the whole URL
-}
delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    -- We're using a `Builder` to build up the possible change. You don't
    -- have to do that ... you can construct a `UrlChange` however you like.
    --
    -- So, as the last step, we map our possible `Builder` to a `UrlChange`.
    Maybe.map Builder.toUrlChange <|
        delta2builder previous current


{-| An example of the new API, if just using the hash
-}
delta2hash : Model -> Model -> Maybe UrlChange
delta2hash previous current =
    -- Here, we're re-using the Builder-oriented code, but stuffing everything
    -- into the hash (rather than actually using the full URL).
    Maybe.map Builder.toHashChange <|
        delta2builder previous current


{-| This is the common code that we rely on above. Again, you don't have to use
a `Builder` if you don't want to ... it's just one way to construct a `UrlChange`.
-}
delta2builder : Model -> Model -> Maybe Builder
delta2builder previous current =
    case current.currentExample of
        Example1 ->
            -- First, we ask the submodule for a `Maybe Builder`. Then, we use
            -- `map` to prepend something to the path.
            Example1.delta2builder previous.example1 current.example1
                |> Maybe.map (Builder.prependToPath [ "example-1" ])

        Example2 ->
            Example2.delta2builder previous.example2 current.example2
                |> Maybe.map (Builder.prependToPath [ "example-2" ])


{-| This is an example of a `location2messages` function ... I'm calling it
`url2messages` to illustrate something that uses the full URL.
-}
url2messages : Location -> List Action
url2messages location =
    -- You can parse the `Location` in whatever way you want. I'm making
    -- a `Builder` and working from that, but I'm sure that's not the
    -- best way. There are links to a number of proper parsing packages
    -- in the README.
    builder2messages (Builder.fromUrl location.href)


{-| This is an example of a `location2messages` function ... I'm calling it
`hash2messages` to illustrate something that uses just the hash.
-}
hash2messages : Location -> List Action
hash2messages location =
    -- You can parse the `Location` in whatever way you want. I'm making
    -- a `Builder` and working from that, but I'm sure that's not the
    -- best way. There are links to a number of proper parsing packages
    -- in the README.
    builder2messages (Builder.fromHash location.href)


{-| Another example of a `location2messages` function, this time only using the hash.
-}
builder2messages : Builder -> List Action
builder2messages builder =
    -- You can parse the `Location` in whatever way you want ... there are a
    -- number of parsing packages listed in the README. Here, I'm constructing
    -- a `Builder` and working from that, but that's probably not the best
    -- thing to do.
    case Builder.path builder of
        first :: rest ->
            let
                subBuilder =
                    Builder.replacePath rest builder
            in
                case first of
                    "example-1" ->
                        -- We give the Example1 module a chance to interpret
                        -- the rest of the location, and then we prepend an
                        -- action for the part we interpreted.
                        ShowExample Example1 :: List.map Example1Action (Example1.builder2messages subBuilder)

                    "example-2" ->
                        ShowExample Example2 :: List.map Example2Action (Example2.builder2messages subBuilder)

                    _ ->
                        -- Normally, you'd want to show an error of some kind here.
                        -- But, for the moment, I'll just default to example1
                        [ ShowExample Example1 ]

        _ ->
            -- Normally, you'd want to show an error of some kind here.
            -- But, for the moment, I'll just default to example1
            [ ShowExample Example1 ]
