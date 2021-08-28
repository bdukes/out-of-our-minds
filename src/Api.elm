module Api exposing (routes)

import ApiRoute
import DataSource exposing (DataSource)
import Html exposing (Html)
import Route exposing (Route)
import Site
import Sitemap


routes :
    DataSource (List Route)
    -> (Html Never -> String)
    -> List (ApiRoute.ApiRoute ApiRoute.Response)
routes getStaticRoutes _ =
    [ ApiRoute.succeed
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
