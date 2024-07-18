module Route.Article.Slug_ exposing (ActionData, Data, Model, Msg, route)

import Accessibility.Styled exposing (..)
import Article exposing (ArticleMetadata)
import BackendTask exposing (BackendTask)
import Css exposing (cover, noRepeat)
import Css.Global
import Css.Media as Media exposing (only, screen, withMedia)
import Date
import DateOrDateTime
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled.Attributes exposing (css)
import MarkdownCodec
import Pages.Url as Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Site
import StructuredData
import Styles exposing (palette)
import UrlPath
import View exposing (View)
import View.Common


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


pages : BackendTask FatalError (List RouteParams)
pages =
    Article.articlesGlob
        |> BackendTask.map
            (List.map
                (\globData ->
                    { slug = globData.slug }
                )
            )


type alias Data =
    { metadata : ArticleMetadata
    , body : List (Html (PagesMsg Msg))
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    MarkdownCodec.withFrontmatter (\metadata body -> Data metadata body)
        ("content/articles/" ++ routeParams.slug ++ ".md")


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    let
        metadata =
            app.data.metadata
    in
    Head.structuredData
        (StructuredData.article
            { title = metadata.title
            , description = metadata.description
            , author = StructuredData.person { name = metadata.author }
            , publisher = StructuredData.person { name = metadata.author }
            , url = Site.config.canonicalUrl ++ UrlPath.toAbsolute app.path
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
                    , publishedTime = Just (DateOrDateTime.Date metadata.published)
                    , modifiedTime = Nothing
                    , expirationTime = Nothing
                    }
           )


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    let
        articleHeader =
            header
                [ css
                    [ withMedia [ only screen [ Media.minWidth (Css.px 960) ] ]
                        [ Css.property "background-image" ("linear-gradient(to top, rgba(255, 255, 255, 0.9), rgba(0, 0, 0, 0.6)), url(" ++ Url.toString app.data.metadata.image ++ ")")
                        , Css.backgroundRepeat noRepeat
                        , Css.backgroundSize cover
                        , Css.backgroundPosition2 Css.zero (Css.pct 25)
                        , Css.color palette.white
                        , Css.padding2 (Css.rem 2) (Css.rem 1)
                        ]
                    ]
                ]
                [ View.Common.pageHeading [] [ text app.data.metadata.title ]
                , View.Common.categoryList [ css [ Css.flexDirection Css.rowReverse ] ] app.data.metadata.categories
                ]

        contentStyles =
            Css.Global.descendants
                [ Css.Global.selector "p:has(img)"
                    [ Css.displayFlex
                    , Css.property "gap" "1em"
                    , Css.flexWrap Css.wrap
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
    { title = app.data.metadata.title
    , body =
        View.Common.body
            [ article [ css [ contentStyles ] ]
                (articleHeader :: app.data.body)
            ]
    }
