module Site exposing (config)

import DataSource
import Head
import Pages.Manifest as Manifest
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
        { data = data
        , canonicalUrl = "https://out-of-our-minds.family"
        , manifest = manifest
        , head = head
        }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "Out of Our Minds"
        , description = "Creative resources bringing order to chaos for families"
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }
