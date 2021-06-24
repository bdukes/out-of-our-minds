module Shared exposing (Category, Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Css exposing (auto, backgroundColor, borderBox, boxSizing, color, fontFamilies, margin2, maxWidth, minHeight, qt, sansSerif, zero)
import Css.Global exposing (descendants, everything)
import DataSource
import DataSource.Glob
import Html exposing (Html)
import Html.Styled exposing (div)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import SharedTemplate exposing (SharedTemplate)
import Styles
import View exposing (View)


template : SharedTemplate Msg Model Data SharedMsg msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    , sharedMsg = SharedMsg
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Category =
    { name : String
    , icon : String
    }


type alias Data =
    { categories : List Category
    }


type SharedMsg
    = NoOp


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
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    let
        toCategory prefix imageName suffix =
            { name = imageName, icon = prefix ++ imageName ++ suffix }
    in
    DataSource.Glob.succeed toCategory
        |> DataSource.Glob.match (DataSource.Glob.literal "public")
        |> DataSource.Glob.capture (DataSource.Glob.literal "/images/categories/")
        |> DataSource.Glob.capture DataSource.Glob.wildcard
        |> DataSource.Glob.capture (DataSource.Glob.literal ".svg")
        |> DataSource.Glob.toDataSource
        |> DataSource.map Data


view :
    Data
    -> { path : Path, frontmatter : route }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { title = pageView.title
    , body = div [] (bodyStyles :: pageView.body) |> Html.Styled.toUnstyled
    }


bodyStyles : Html.Styled.Html msg
bodyStyles =
    Css.Global.global
        [ Css.Global.body
            [ fontFamilies [ qt "Open Sans", .value sansSerif ]
            , backgroundColor Styles.palette.white
            , color Styles.palette.black
            , margin2 zero auto
            , maxWidth (Css.px 960)
            , minHeight (Css.vh 100)
            , descendants [ everything [ boxSizing borderBox ] ]
            ]
        ]
