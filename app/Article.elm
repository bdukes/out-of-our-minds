module Article exposing (ArticleMetadata, allMetadata, articlesGlob, frontmatterDecoder)

import BackendTask
import BackendTask.File as File
import BackendTask.Glob as Glob
import Category exposing (Category)
import Date exposing (Date)
import FatalError exposing (FatalError)
import Json.Decode as Decode
import List.Extra
import Pages.Url as Url exposing (Url)
import Route


type alias Article =
    { filePath : String
    , slug : String
    }


articlesGlob : BackendTask.BackendTask FatalError (List { filePath : String, slug : String })
articlesGlob =
    Glob.succeed Article
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/articles/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


allMetadata : BackendTask.BackendTask FatalError (List ( Route.Route, ArticleMetadata ))
allMetadata =
    articlesGlob
        |> BackendTask.map2
            (\categories paths ->
                paths
                    |> List.map
                        (\{ filePath, slug } ->
                            BackendTask.map2 Tuple.pair
                                (BackendTask.succeed <| Route.Article__Slug_ { slug = slug })
                                (File.onlyFrontmatter (frontmatterDecoder categories) filePath |> BackendTask.allowFatal)
                        )
            )
            Category.dataSource
        |> BackendTask.resolve
        |> BackendTask.map
            (\articles ->
                articles
                    |> List.filterMap
                        (\( route, metadata ) ->
                            if metadata.draft then
                                Nothing

                            else
                                Just ( route, metadata )
                        )
            )
        |> BackendTask.map
            (List.sortBy
                (\( _, metadata ) -> -(Date.toRataDie metadata.published))
            )


type alias ArticleMetadata =
    { title : String
    , description : String
    , author : String
    , published : Date
    , image : Url
    , draft : Bool
    , categories : List Category
    }


frontmatterDecoder : List Category -> Decode.Decoder ArticleMetadata
frontmatterDecoder categories =
    Decode.map7 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "published" dateDecoder)
        (Decode.field "image" imageDecoder)
        (Decode.field "draft" Decode.bool
            |> Decode.maybe
            |> Decode.map (Maybe.withDefault False)
        )
        (Decode.field "categories" (Decode.list (categoryDecoder categories)))


categoryDecoder : List Category -> Decode.Decoder Category
categoryDecoder categories =
    let
        toCategory categoryName =
            case List.Extra.find (\{ name } -> String.toUpper name == String.toUpper categoryName) categories of
                Nothing ->
                    Decode.fail ("Could not find category " ++ categoryName)

                Just category ->
                    Decode.succeed category
    in
    Decode.string
        |> Decode.andThen toCategory


imageDecoder : Decode.Decoder Url
imageDecoder =
    Decode.string
        |> Decode.map Url.external


dateDecoder : Decode.Decoder Date
dateDecoder =
    Decode.string
        |> Decode.andThen
            (\isoString ->
                case Date.fromIsoString isoString of
                    Ok date ->
                        Decode.succeed date

                    Err error ->
                        Decode.fail error
            )
