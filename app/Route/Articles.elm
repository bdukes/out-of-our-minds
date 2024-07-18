module Route.Articles exposing (ActionData, Data, Model, Msg, route)

import Accessibility.Styled as Html exposing (img, section, text)
import Article
import BackendTask exposing (BackendTask)
import Css exposing (alignItems, block, center, color, display, displayFlex, fontSize, fontWeight, justifyContent, lighter, none, normal, padding2, pct, spaceAround, textAlign, textDecoration, width, zero)
import Css.Media as Media exposing (only, screen, withMedia)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled.Attributes exposing (css, src)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route exposing (Route)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Site
import Styles
import UrlPath
import View exposing (View)
import View.Common exposing (categoryImageLink, link)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    List ( Route, Article.ArticleMetadata )


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    Article.allMetadata


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.siteName
        , image = Site.siteLogo
        , description = "Our collection of articles on topics like education, nurture, sensory needs, trauma and more"
        , locale = Nothing
        , title = "Articles | Out of Our Minds"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    { title = "Out of Our Minds"
    , body =
        View.Common.body
            (View.Common.pageHeading [] [ text "All articles" ]
                :: View.Common.articleList app.data
            )
    }


bannersStyle : Css.Style
bannersStyle =
    withMedia [ only screen [ Media.minWidth (Css.px 450) ] ]
        [ displayFlex
        , justifyContent spaceAround
        , alignItems center
        ]


bannerStyle : Css.Color -> Css.Color -> String -> Css.Style
bannerStyle backgroundColor hoverColor backgroundImageUrl =
    Css.batch
        [ display block
        , textAlign center
        , padding2 (Css.rem 5) zero
        , fontSize (Css.em 2)
        , fontWeight lighter
        , width (pct 100)
        , Css.backgroundSize Css.cover
        , Css.backgroundRepeat Css.noRepeat
        , Css.backgroundPosition Css.center
        , Css.property "background-image" ("linear-gradient(to top, " ++ backgroundColor.value ++ ", " ++ backgroundColor.value ++ "), url(" ++ backgroundImageUrl ++ ")")
        , color Styles.palette.white
        , textDecoration none
        , Css.hover
            [ fontWeight normal
            , Css.property "background-image" ("linear-gradient(to top, " ++ hoverColor.value ++ ", " ++ hoverColor.value ++ "), url(" ++ backgroundImageUrl ++ ")")
            ]
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
