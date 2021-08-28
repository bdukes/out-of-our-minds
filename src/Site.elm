module Site exposing (config, siteLogo, siteName, siteTagline)

import DataSource
import Head
import Head.Seo exposing (Image)
import Pages.Manifest as Manifest
import Pages.Url
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
head _ =
    [ Head.sitemapLink "/sitemap.xml"
    ]


manifest : Data -> Manifest.Config
manifest _ =
    Manifest.init
        { name = siteName
        , description = siteTagline
        , startUrl = Route.Index |> Route.toPath
        , icons = []
        }


siteName : String
siteName =
    "Out of Our Minds"


siteTagline : String
siteTagline =
    "Creative resources bringing order to chaos for families"


siteLogo : Image
siteLogo =
    { url = Pages.Url.external "/images/logo-main.svg"
    , alt = "Out of Our Minds logo"
    , dimensions = Nothing
    , mimeType = Nothing
    }
