module Page.Article.Slug_ exposing (Data, Model, Msg, page)

import Accessibility.Styled exposing (..)
import Article exposing (ArticleMetadata)
import Css
import Css.Global
import Css.Media as Media exposing (only, screen, withMedia)
import DataSource exposing (DataSource)
import Date
import Head
import Head.Seo as Seo
import Html.Styled.Attributes exposing (css)
import MarkdownCodec
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Path
import Shared
import Site
import StructuredData
import View exposing (View)
import View.Common


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Article.articlesGlob
        |> DataSource.map
            (List.map
                (\globData ->
                    { slug = globData.slug }
                )
            )


data : RouteParams -> DataSource Data
data route =
    MarkdownCodec.withFrontmatter (\metadata body -> Data metadata body)
        ("content/articles/" ++ route.slug ++ ".md")


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    let
        metadata =
            static.data.metadata
    in
    Head.structuredData
        (StructuredData.article
            { title = metadata.title
            , description = metadata.description
            , author = StructuredData.person { name = metadata.author }
            , publisher = StructuredData.person { name = metadata.author }
            , url = Site.config.canonicalUrl ++ Path.toAbsolute static.path
            , imageUrl = metadata.image
            , datePublished = Date.toIsoString metadata.published
            }
        )
        :: (Seo.summaryLarge
                { canonicalUrlOverride = Nothing
                , siteName = Site.siteName
                , image =
                    { url = metadata.image
                    , alt = metadata.description
                    , dimensions = Nothing
                    , mimeType = Nothing
                    }
                , description = metadata.description
                , locale = Nothing
                , title = metadata.title
                }
                |> Seo.article
                    { tags = List.map .name metadata.categories
                    , section = Nothing
                    , publishedTime = Just (Date.toIsoString metadata.published)
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }
           )


type alias Data =
    { metadata : ArticleMetadata
    , body : List (Html Msg)
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    let
        articleHeader =
            header
                [ css
                    [ withMedia [ only screen [ Media.minWidth (Css.px 960) ] ]
                        [ Css.displayFlex
                        , Css.justifyContent Css.spaceBetween
                        ]
                    ]
                ]
                [ View.Common.pageHeading [] [ text static.data.metadata.title ]
                , View.Common.categoryList [] static.data.metadata.categories
                ]

        contentStyles =
            Css.Global.descendants
                [ Css.Global.p
                    [ Css.displayFlex
                    , Css.property "gap" "1em"
                    ]
                , Css.Global.img
                    [ Css.maxWidth (Css.pct 100)
                    , Css.maxHeight (Css.vh 75)
                    , Css.margin2 Css.zero Css.auto
                    ]
                , Css.Global.a
                    [ View.Common.linkStyle
                    ]
                ]
    in
    { title = static.data.metadata.title
    , body =
        View.Common.body
            [ article [ css [ contentStyles ] ]
                (articleHeader :: static.data.body)
            ]
    }
