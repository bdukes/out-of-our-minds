module Page.Article.Slug_ exposing (Data, Model, Msg, page)

import Accessibility.Styled exposing (..)
import Article exposing (ArticleMetadata)
import Css
import Css.Global
import DataSource exposing (DataSource)
import Date
import Head
import Head.Seo as Seo
import Html.Styled.Attributes exposing (css, src)
import MarkdownCodec
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Path
import Shared exposing (Category)
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
        viewCategory : Category -> Html Msg
        viewCategory category =
            li [ css [ Css.padding2 Css.zero (Css.rem 1) ] ]
                [ img category.name [ src category.icon, css [ Css.minHeight (Css.px 50), Css.maxHeight (Css.rem 5) ] ]
                ]

        articleHeader =
            header [ css [ Css.displayFlex, Css.justifyContent Css.spaceBetween ] ]
                [ h2 [ css [ Css.fontSize (Css.em 2) ] ] [ text static.data.metadata.title ]
                , ul [ css [ Css.listStyle Css.none, Css.displayFlex ] ] (List.map viewCategory static.data.metadata.categories)
                ]
    in
    { title = static.data.metadata.title
    , body =
        View.Common.body
            [ article [ css [ Css.Global.descendants [ Css.Global.typeSelector "img" [ Css.maxWidth (Css.pct 100) ] ] ] ]
                (articleHeader :: static.data.body)
            ]
    }
