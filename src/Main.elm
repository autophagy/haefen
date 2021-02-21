module Main exposing (..)

import Browser
import Html exposing (Html, a, div, p, span, text)
import Html.Attributes exposing (class, href, id)



---- MODEL ----


type alias Model =
    {}


type alias Link =
    { dest : String, desc : String }


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



---- VIEW ----


name : String
name =
    "Mika Naylor"


langs : List String
langs =
    [ "Python", "Haskell", "Elm" ]


likes : List String
likes =
    [ "Pure FP", "Type Systems", "Black Metal" ]


work : String
work =
    "Ververica GmbH"


contact : List Link
contact =
    [ { dest = "mailto:eala@autophagy.io", desc = "email" }
    , { dest = "https://github.com/autophagy", desc = "github" }
    , { dest = "https://twitter.com/autophagian", desc = "twitter" }
    ]


view : Model -> Html Msg
view _ =
    let
        showList =
            String.join " | "

        showLink =
            \l -> a [ href l.dest ] [ text l.desc ]

        showLinkList =
            List.intersperse (text " | ") << List.map showLink

        row =
            \n content -> div [ class "row" ] ([ span [ class "ident" ] [ text n ], span [ class "sep" ] [ text " :: " ] ] ++ content)
    in
    div [ id "text" ]
        [ row "name" [ text name ]
        , row "langs" [ text <| showList langs ]
        , row "likes" [ text <| showList likes ]
        , row "work" [ text work ]
        , row "contact" <| showLinkList contact
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
