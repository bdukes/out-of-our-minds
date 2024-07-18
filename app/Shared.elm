module Shared exposing (Data, Model, Msg, SharedMsg, template)

import Accessibility.Styled exposing (div)
import BackendTask exposing (BackendTask)
import Category exposing (Category)
import Css exposing (borderBox, boxSizing, margin, zero)
import Css.Global exposing (descendants, everything)
import Effect exposing (Effect)
import FatalError exposing (FatalError)
import Html exposing (Html)
import Html.Events
import Html.Styled.Attributes exposing (css)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Styles exposing (palette)
import UrlPath exposing (UrlPath)
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
    { categories : List Category }


type alias SharedMsg =
    Never


type alias Model =
    ()


init :
    Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : UrlPath
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Effect Msg )
init flags maybePagePath =
    ( ()
    , Effect.none
    )


update : Msg -> Model -> ( Model, Effect Msg )
update _ model =
    ( model, Effect.none )


subscriptions : UrlPath -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : BackendTask FatalError Data
data =
    BackendTask.map Data Category.dataSource


view :
    Data
    ->
        { path : UrlPath
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : List (Html msg), title : String }
view sharedData page model toMsg pageView =
    { body =
        [ div
            [ css
                [ Css.minHeight (Css.vh 100)
                , Css.backgroundColor palette.white
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
        ]
    , title = pageView.title
    }


bodyStyles : Accessibility.Styled.Html msg
bodyStyles =
    Css.Global.global
        [ Css.Global.body
            [ margin zero
            , descendants [ everything [ boxSizing borderBox ] ]
            ]
        ]
