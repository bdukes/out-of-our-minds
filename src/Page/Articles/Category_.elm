module Page.Articles.Category_ exposing (Data, Model, Msg, page)

import Accessibility.Styled exposing (..)
import Article exposing (ArticleMetadata)
import Category exposing (Category)
import Css
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled.Attributes exposing (css)
import List.Extra
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Route exposing (Route)
import Shared
import Site
import View exposing (View)
import View.Common exposing (categoryList)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { category : String }


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
    Category.dataSource
        |> DataSource.map (List.map .name)
        |> DataSource.map (List.map RouteParams)


data : RouteParams -> DataSource Data
data routeParams =
    let
        filterArticlesByCategory : List ( Route, ArticleMetadata ) -> List ( Route, ArticleMetadata )
        filterArticlesByCategory articles =
            articles
                |> List.filter (\( _, article ) -> isInCategory article)

        isInCategory : ArticleMetadata -> Bool
        isInCategory { categories } =
            categories
                |> List.any isMatchingCategory

        isMatchingCategory : Category -> Bool
        isMatchingCategory { name } =
            String.toUpper name == String.toUpper routeParams.category

        categoryDataSource =
            Category.dataSource
                |> DataSource.map (List.Extra.find isMatchingCategory)
                |> DataSource.map (Maybe.map DataSource.succeed)
                |> DataSource.andThen (Maybe.withDefault (DataSource.fail "No matching category"))

        articlesDataSource =
            Article.allMetadata
                |> DataSource.map filterArticlesByCategory
    in
    DataSource.map2 Data
        articlesDataSource
        categoryDataSource


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    let
        category =
            static.data.category
    in
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.siteName
        , image =
            { url = Pages.Url.external category.icon
            , alt = category.name
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Read all of the articles from the " ++ category.name ++ " category"
        , locale = Nothing
        , title = category.name
        }
        |> Seo.website


type alias Data =
    { articles : List ( Route, ArticleMetadata )
    , category : Category
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    let
        articleHeader route articleMetadata =
            header [ css [ Css.displayFlex, Css.justifyContent Css.spaceBetween ] ]
                [ h2 [ css [ Css.fontSize (Css.em 2) ] ] [ View.Common.link route [] [ text articleMetadata.title ] ]
                , categoryList articleMetadata.categories
                ]

        viewArticle : ( Route, ArticleMetadata ) -> Html Msg
        viewArticle ( route, articleMetadata ) =
            section []
                [ articleHeader route articleMetadata, p [] [ text articleMetadata.description ] ]
    in
    { title = static.data.category.name
    , body =
        View.Common.body
            (List.map viewArticle static.data.articles)
    }
