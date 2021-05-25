port module Pages exposing (PathKey, allPages, allImages, internals, images, isValidRoute, pages, builtAt)

import Color exposing (Color)
import Pages.Internal
import Head
import Html exposing (Html)
import Json.Decode
import Json.Encode
import Pages.Platform
import Pages.Manifest exposing (DisplayMode, Orientation)
import Pages.Manifest.Category as Category exposing (Category)
import Url.Parser as Url exposing ((</>), s)
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Directory as Directory exposing (Directory)
import Time


builtAt : Time.Posix
builtAt =
    Time.millisToPosix 1621906272805


type PathKey
    = PathKey


buildImage : List String -> ImagePath.Dimensions -> ImagePath PathKey
buildImage path dimensions =
    ImagePath.build PathKey ("images" :: path) dimensions


buildPage : List String -> PagePath PathKey
buildPage path =
    PagePath.build PathKey path


directoryWithIndex : List String -> Directory PathKey Directory.WithIndex
directoryWithIndex path =
    Directory.withIndex PathKey allPages path


directoryWithoutIndex : List String -> Directory PathKey Directory.WithoutIndex
directoryWithoutIndex path =
    Directory.withoutIndex PathKey allPages path


port toJsPort : Json.Encode.Value -> Cmd msg

port fromJsPort : (Json.Decode.Value -> msg) -> Sub msg


internals : Pages.Internal.Internal PathKey
internals =
    { applicationType = Pages.Internal.Browser
    , toJsPort = toJsPort
    , fromJsPort = fromJsPort identity
    , content = content
    , pathKey = PathKey
    }




allPages : List (PagePath PathKey)
allPages =
    [ (buildPage [ "articles", "draft" ])
    , (buildPage [ "articles", "hello" ])
    , (buildPage [ "articles" ])
    , (buildPage [  ])
    , (buildPage [ "store" ])
    ]

pages =
    { articles =
        { draft = (buildPage [ "articles", "draft" ])
        , hello = (buildPage [ "articles", "hello" ])
        , index = (buildPage [ "articles" ])
        , directory = directoryWithIndex ["articles"]
        }
    , index = (buildPage [  ])
    , store =
        { index = (buildPage [ "store" ])
        , directory = directoryWithIndex ["store"]
        }
    , directory = directoryWithIndex []
    }

images =
    { allLogoParts = (buildImage [ "all-logo-parts.svg" ] { width = 512, height = 512 })
    , articleCovers =
        { wall = (buildImage [ "article-covers", "wall.jpg" ] { width = 664, height = 556 })
        , directory = directoryWithoutIndex ["articleCovers"]
        }
    , categorySixPack = (buildImage [ "category-six-pack.svg" ] { width = 512, height = 512 })
    , education = (buildImage [ "education.svg" ] { width = 512, height = 512 })
    , logoMain = (buildImage [ "logo-main.svg" ] { width = 512, height = 512 })
    , nikki = (buildImage [ "nikki.jpg" ] { width = 120, height = 120 })
    , nurture = (buildImage [ "nurture.svg" ] { width = 512, height = 512 })
    , nutrition = (buildImage [ "nutrition.svg" ] { width = 512, height = 512 })
    , order = (buildImage [ "order.svg" ] { width = 150, height = 150 })
    , sensory = (buildImage [ "sensory.svg" ] { width = 512, height = 512 })
    , tagline = (buildImage [ "tagline.svg" ] { width = 512, height = 512 })
    , trauma = (buildImage [ "trauma.svg" ] { width = 512, height = 512 })
    , directory = directoryWithoutIndex []
    }


allImages : List (ImagePath PathKey)
allImages =
    [(buildImage [ "all-logo-parts.svg" ] { width = 512, height = 512 })
    , (buildImage [ "article-covers", "wall.jpg" ] { width = 664, height = 556 })
    , (buildImage [ "category-six-pack.svg" ] { width = 512, height = 512 })
    , (buildImage [ "education.svg" ] { width = 512, height = 512 })
    , (buildImage [ "logo-main.svg" ] { width = 512, height = 512 })
    , (buildImage [ "nikki.jpg" ] { width = 120, height = 120 })
    , (buildImage [ "nurture.svg" ] { width = 512, height = 512 })
    , (buildImage [ "nutrition.svg" ] { width = 512, height = 512 })
    , (buildImage [ "order.svg" ] { width = 150, height = 150 })
    , (buildImage [ "sensory.svg" ] { width = 512, height = 512 })
    , (buildImage [ "tagline.svg" ] { width = 512, height = 512 })
    , (buildImage [ "trauma.svg" ] { width = 512, height = 512 })
    ]


isValidRoute : String -> Result String ()
isValidRoute route =
    let
        validRoutes =
            List.map PagePath.toString allPages
    in
    if
        (route |> String.startsWith "http://")
            || (route |> String.startsWith "https://")
            || (route |> String.startsWith "#")
            || (validRoutes |> List.member route)
    then
        Ok ()

    else
        ("Valid routes:\n"
            ++ String.join "\n\n" validRoutes
        )
            |> Err


content : List ( List String, { extension: String, frontMatter : String, body : Maybe String } )
content =
    [ 
  ( []
    , { frontMatter = "{\"title\":\"Out of Our Minds\",\"type\":\"page\"}"
    , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["articles", "draft"]
    , { frontMatter = "{\"type\":\"blog\",\"author\":\"Nikki Dukes\",\"title\":\"A Draft Blog Post\",\"description\":\"I'm not quite ready to share this post with the world\",\"image\":\"images/article-covers/wall.jpg\",\"draft\":true,\"published\":\"2019-09-21\"}"
    , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["articles", "hello"]
    , { frontMatter = "{\"type\":\"blog\",\"author\":\"Nikki Dukes\",\"title\":\"Hello `elm-pages`! 🚀\",\"description\":\"Here's an intro for my blog post to get you interested in reading more...\",\"image\":\"images/article-covers/wall.jpg\",\"published\":\"2019-09-21\"}"
    , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["articles"]
    , { frontMatter = "{\"title\":\"Articles | Out of Our Minds\",\"type\":\"blog-index\"}"
    , body = Nothing
    , extension = "md"
    } )
  ,
  ( ["store"]
    , { frontMatter = "{\"title\":\"Store | Out of Our Minds\",\"type\":\"store-index\"}"
    , body = Nothing
    , extension = "md"
    } )
  
    ]
