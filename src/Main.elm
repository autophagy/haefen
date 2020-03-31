module Main exposing (..)

import Browser
import Html exposing (Html, a, div, h1, img, p, span, text)
import Html.Attributes exposing (href, id, src)



---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


intro : String
intro =
    "Hi. I'm Mika."


content : List (List (Html Msg))
content =
    [ [ text "I'm a Berlin based software developer, mostly writing Python. I adore functional programming with Haskell and Elm. Also into cybernetcs, body horror and Xenofeminism." ]
    , [ text "I help organise "
      , a [ href "#" ] [ text "Pyladies Berlin" ]
      , text " and do public speaking at events like "
      , a [ href "https://www.youtube.com/watch?v=qLoMFu14wmk" ] [ text "PyCon UK." ]
      ]
    , [ text "Find my work in "
      , a [ href "#" ] [ text "Hraew" ]
      , text " or on "
      , a [ href "#" ] [ text "Github." ]
      ]
    , [ text "Contact me via "
      , a [ href "#" ] [ text "email" ]
      , text " or "
      , a [ href "#" ] [ text "Twitter." ]
      ]
    ]


view : Model -> Html Msg
view model =
    div [ id "text" ]
        [ div [ id "title" ] [ span [ id "name" ] [ text intro ], span [ id "sep" ] [] ]
        , div [ id "content" ] (List.map (\c -> p [] c) content)
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
