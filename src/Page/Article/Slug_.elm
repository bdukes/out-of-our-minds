module Page.Article.Slug_ exposing (Data, Model, Msg, page)

import Accessibility.Styled exposing (..)
import Article exposing (ArticleMetadata, frontmatterDecoder)
import Css
import Css.Global
import DataSource exposing (DataSource)
import Date
import Head exposing (structuredData)
import Head.Seo as Seo
import Html.Styled.Attributes exposing (css, href, src)
import Markdown.Renderer
import MarkdownCodec
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Route
import Shared exposing (Category)
import Site
import StructuredData
import Svg.Styled exposing (metadata)
import View exposing (View)
import View.Common exposing (link)


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
            li [ css [ Css.padding2 Css.zero (Css.rem 1) ] ] [ img category.name [ src category.icon ] ]
    in
    { title = static.data.metadata.title
    , body =
        View.Common.body
            [ h2 [] [ text static.data.metadata.title ]
            , ul [ css [ Css.listStyle Css.none, Css.displayFlex ] ] (List.map viewCategory static.data.metadata.categories)
            , article [ css [ Css.Global.descendants [ Css.Global.typeSelector "img" [ Css.maxWidth (Css.pct 100) ] ] ] ] static.data.body
            ]
    }
