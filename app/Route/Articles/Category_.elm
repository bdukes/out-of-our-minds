module Route.Articles.Category_ exposing (ActionData, Data, Model, Msg, route)

import Accessibility.Styled exposing (text)
import Article exposing (ArticleMetadata)
import BackendTask exposing (BackendTask)
import Category exposing (Category)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import List.Extra
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route exposing (Route)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Site
import View exposing (View)
import View.Common


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { category : String }


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
    Category.dataSource
        |> BackendTask.map (List.map .name)
        |> BackendTask.map (List.map RouteParams)


type alias Data =
    { articles : List ( Route, ArticleMetadata )
    , category : Category
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
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
                |> BackendTask.map (List.Extra.find isMatchingCategory)
                |> BackendTask.map (Maybe.map BackendTask.succeed)
                |> BackendTask.andThen (Maybe.withDefault (BackendTask.fail (FatalError.fromString "No matching category")))

        articlesDataSource =
            Article.allMetadata
                |> BackendTask.map filterArticlesByCategory
    in
    BackendTask.map2 Data
        articlesDataSource
        categoryDataSource


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    let
        category =
            app.data.category
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


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app sharedModel =
    { title = app.data.category.name
    , body =
        View.Common.body
            (View.Common.pageHeading [] [ text ("Articles about " ++ app.data.category.name) ]
                :: View.Common.articleList app.data.articles
            )
    }
