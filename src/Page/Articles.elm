module Page.Articles exposing (Data, Model, Msg, page)

import Accessibility.Styled exposing (..)
import Article exposing (ArticleMetadata)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Route exposing (Route)
import Shared
import Site
import View exposing (View)
import View.Common


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
    Article.allMetadata


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.siteName
        , image = Site.siteLogo
        , description = "Our collection of articles on topics like education, nurture, sensory needs, trauma and more"
        , locale = Nothing
        , title = "Articles | Out of Our Minds"
        }
        |> Seo.website


type alias Data =
    List ( Route, Article.ArticleMetadata )


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Articles | Out of Our Minds"
    , body =
        View.Common.body
            [ h2 [] [ text "All articles" ]
            , ul [] (List.map viewArticle static.data)
            ]
    }


viewArticle : ( Route, ArticleMetadata ) -> Html msg
viewArticle ( route, metadata ) =
    li []
        [ View.Common.link route [] [ text metadata.title ]
        ]
