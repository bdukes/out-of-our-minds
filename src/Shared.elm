module Shared exposing (Data, Model, Msg, template)

import Accessibility.Styled exposing (div)
import Browser.Navigation
import Category exposing (Category)
import Css exposing (borderBox, boxSizing, margin, zero)
import Css.Global exposing (descendants, everything)
import DataSource
import Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Nothing
    }


type alias Msg =
    Never


type alias Data =
    { categories : List Category
    }


type alias Model =
    { showMobileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init _ _ _ =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( { model | showMobileMenu = False }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.map Data Category.dataSource


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view _ _ _ _ pageView =
    { title = pageView.title
    , body =
        div
            [ css
                [ Css.minHeight (Css.vh 100)
                , Css.property "display" "grid"
                , Css.property "gap" "0.5em"
                , Css.property "grid-template-areas"
                    """
                    "header"
                    "main"
                    "footer"
                    """
                ]
            ]
            (bodyStyles :: pageView.body)
            |> Accessibility.Styled.toUnstyled
    }


bodyStyles : Accessibility.Styled.Html msg
bodyStyles =
    Css.Global.global
        [ Css.Global.body
            [ margin zero
            , descendants [ everything [ boxSizing borderBox ] ]
            ]
        ]
