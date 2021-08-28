module Api exposing (routes)

import ApiRoute
import Article
import DataSource exposing (DataSource)
import Html exposing (Html)
import Pages
import Route exposing (Route)
import Rss
import Site
import Sitemap
import Time


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes _ =
    [ rss
        { siteTagline = Site.siteTagline
        , siteUrl = Site.config.canonicalUrl
        , title = "Out of Our Minds Articles"
        , builtAt = Pages.builtAt
        , indexPage = [ "articles" ]
        }
        postsDataSource
    , ApiRoute.succeed
        (getStaticRoutes
            |> DataSource.map
                (\allRoutes ->
                    { body =
                        allRoutes
                            |> List.map
                                (\route ->
                                    { path = Route.routeToPath route |> String.join "/"
                                    , lastMod = Nothing
                                    }
                                )
                            |> Sitemap.build { siteUrl = Site.config.canonicalUrl }
                    }
                )
        )
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single
    ]


postsDataSource : DataSource.DataSource (List Rss.Item)
postsDataSource =
    Article.allMetadata
        |> DataSource.map
            (List.map
                (\( route, article ) ->
                    { title = article.title
                    , description = article.description
                    , url =
                        route
                            |> Route.routeToPath
                            |> String.join "/"
                    , categories = []
                    , author = article.author
                    , pubDate = Rss.Date article.published
                    , content = Nothing
                    , contentEncoded = Nothing
                    , enclosure = Nothing
                    }
                )
            )


rss :
    { siteTagline : String
    , siteUrl : String
    , title : String
    , builtAt : Time.Posix
    , indexPage : List String
    }
    -> DataSource.DataSource (List Rss.Item)
    -> ApiRoute.ApiRoute ApiRoute.Response
rss options itemsRequest =
    ApiRoute.succeed
        (itemsRequest
            |> DataSource.map
                (\items ->
                    { body =
                        Rss.generate
                            { title = options.title
                            , description = options.siteTagline
                            , url = options.siteUrl ++ "/" ++ String.join "/" options.indexPage
                            , lastBuildTime = options.builtAt
                            , generator = Just "elm-pages"
                            , items = items
                            , siteUrl = options.siteUrl
                            }
                    }
                )
        )
        |> ApiRoute.literal "articles/feed.xml"
        |> ApiRoute.single
