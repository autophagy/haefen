module Main exposing (..)

import Browser
import Html exposing (Html, a, div, p, span, text)
import Html.Attributes exposing (href, id)



---- MODEL ----


type Language
    = EN


type alias Model =
    Language


type alias I18n =
    { en : String }


init : ( Model, Cmd Msg )
init =
    ( EN, Cmd.none )


translate : Language -> I18n -> String
translate language i18n =
    case language of
        EN ->
            i18n.en



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



---- VIEW ----


greeting : I18n
greeting =
    { en = "Hi. I'm Mika." }


intro : I18n
intro =
    { en = """
    I'm a Berlin based software developer, mostly writing Python. Though,
    secretly, I really like type systems and functional programming with
    Haskell/Elm.
    """ }


orga : { text1 : I18n, pyladies : I18n, text2 : I18n, pyconuk : I18n }
orga =
    { text1 = { en = "I help organise " }
    , pyladies = { en = "Pyladies Berlin" }
    , text2 = { en = " and do public speaking at events like " }
    , pyconuk = { en = "PyCon UK." }
    }


work : { text1 : I18n, hraew : I18n, text2 : I18n, github : I18n }
work =
    { text1 = { en = "Find my work in " }
    , hraew = { en = "Hrǽw" }
    , text2 = { en = " or on " }
    , github = { en = "Github." }
    }


contact : { text1 : I18n, email : I18n, text2 : I18n, twitter : I18n }
contact =
    { text1 = { en = "Contact me via " }
    , email = { en = "email" }
    , text2 = { en = " or on " }
    , twitter = { en = "Twitter." }
    }


view : Model -> Html Msg
view language =
    let
        i18n =
            translate language >> text
    in
    div [ id "text" ]
        [ div [ id "title" ] [ span [ id "name" ] [ i18n greeting ] ]
        , div [ id "content" ]
            [ p [] [ i18n intro ]
            , p []
                [ i18n orga.text1
                , a [ href "https://berlin.pyladies.com/" ] [ i18n orga.pyladies ]
                , i18n orga.text2
                , a [ href "https://www.youtube.com/watch?v=qLoMFu14wmk" ] [ i18n orga.pyconuk ]
                ]
            , p []
                [ i18n work.text1
                , a [ href "https://hraew.autophagy.io/" ] [ i18n work.hraew ]
                , i18n work.text2
                , a [ href "https://github.com/autophagy/" ] [ i18n work.github ]
                ]
            , p []
                [ i18n contact.text1
                , a [ href "mailto:eala@autophagy.io" ] [ i18n contact.email ]
                , i18n contact.text2
                , a [ href "https://twitter.com/autophagian" ] [ i18n contact.twitter ]
                ]
            ]
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
