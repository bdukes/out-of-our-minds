module Page.Index exposing (Data, Model, Msg, page)

import Accessibility.Styled exposing (..)
import Css exposing (alignItems, backgroundColor, block, center, color, display, displayFlex, justifyContent, padding2, pct, spaceAround, textAlign, width, zero)
import Css.Media as Media exposing (only, screen, withMedia)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled.Attributes exposing (css, src)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Route
import Shared
import Site
import Styles
import View exposing (View)
import View.Common exposing (categoryImageLink, link)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.siteName
        , image = Site.siteLogo
        , description = Site.siteTagline
        , locale = Nothing
        , title = "Out of Our Minds"
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Out of Our Minds"
    , body =
        View.Common.body
            [ section [ css [ Css.marginBottom (Css.em 2) ] ]
                [ img "Creative resources bringing order to chaos for families" [ css [ width (pct 100), padding2 zero (Css.em 2) ], src "/images/tagline.svg" ]
                ]
            , section [ css [ bannersStyle ] ]
                [ link Route.Articles [ css [ bannerStyle Styles.palette.primary ] ] [ text "Articles" ]
                , link Route.Store [ css [ bannerStyle Styles.palette.secondary ] ] [ text "Store" ]
                ]
            , section [ css [ logoNavStyles ] ] (List.map categoryImageLink static.sharedData.categories)
            ]
    }


bannersStyle : Css.Style
bannersStyle =
    withMedia [ only screen [ Media.minWidth (Css.px 450) ] ]
        [ displayFlex
        , justifyContent spaceAround
        , alignItems center
        ]


bannerStyle : Css.Color -> Css.Style
bannerStyle backgroundColor =
    Css.batch
        [ display block
        , textAlign center
        , padding2 (Css.em 5) zero
        , width (pct 100)
        , Css.backgroundColor backgroundColor
        , color Styles.palette.white
        ]


logoNavStyles : Css.Style
logoNavStyles =
    Css.batch
        [ Css.margin2 (Css.em 2) zero
        , Css.property "display" "grid"
        , Css.property "gap" "1em"
        , Css.property "grid-template-columns" " 1fr"
        , withMedia [ only screen [ Media.minWidth (Css.px 300), Media.maxWidth (Css.px 449) ] ]
            [ Css.property "grid-template-columns" "repeat(2, 1fr)"
            ]
        , withMedia [ only screen [ Media.minWidth (Css.px 450), Media.maxWidth (Css.px 959) ] ]
            [ Css.property "grid-template-columns" "repeat(3, 1fr)"
            ]
        , withMedia [ only screen [ Media.minWidth (Css.px 960) ] ]
            [ Css.property "grid-template-columns" "repeat(6, 1fr)"
            ]
        ]
