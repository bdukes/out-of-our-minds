module Site exposing (config, siteLogo, siteName, siteTagline)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo exposing (Image)
import MimeType
import Pages.Url
import SiteConfig exposing (SiteConfig)


config : SiteConfig
config =
    { canonicalUrl = "https://out-of-our-minds.xyz"
    , head = head
    }


head : BackendTask FatalError (List Head.Tag)
head =
    [ Head.metaName "viewport" (Head.raw "width=device-width,initial-scale=1")
    , Head.sitemapLink "/sitemap.xml"
    , Head.rssLink "/articles/feed.xml"
    , Head.icon [] (MimeType.OtherImage "svg+xml") (Pages.Url.external "/images/favicon.svg")
    , Head.icon [ ( 48, 48 ) ] MimeType.Png (Pages.Url.external "/images/favicon.png")
    ]
        |> BackendTask.succeed


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
