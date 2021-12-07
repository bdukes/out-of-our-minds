module Article exposing (ArticleMetadata, allMetadata, articlesGlob, frontmatterDecoder)

import Category exposing (Category)
import Cloudinary
import DataSource
import DataSource.File as File
import DataSource.Glob as Glob
import Date exposing (Date)
import List.Extra
import OptimizedDecoder
import Pages.Url exposing (Url)
import Route


type alias Article =
    { filePath : String
    , slug : String
    }


articlesGlob : DataSource.DataSource (List { filePath : String, slug : String })
articlesGlob =
    Glob.succeed Article
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/articles/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


allMetadata : DataSource.DataSource (List ( Route.Route, ArticleMetadata ))
allMetadata =
    articlesGlob
        |> DataSource.map2
            (\categories paths ->
                paths
                    |> List.map
                        (\{ filePath, slug } ->
                            DataSource.map2 Tuple.pair
                                (DataSource.succeed <| Route.Article__Slug_ { slug = slug })
                                (File.onlyFrontmatter (frontmatterDecoder categories) filePath)
                        )
            )
            Category.dataSource
        |> DataSource.resolve
        |> DataSource.map
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
        |> DataSource.map
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


frontmatterDecoder : List Category -> OptimizedDecoder.Decoder ArticleMetadata
frontmatterDecoder categories =
    OptimizedDecoder.map7 ArticleMetadata
        (OptimizedDecoder.field "title" OptimizedDecoder.string)
        (OptimizedDecoder.field "description" OptimizedDecoder.string)
        (OptimizedDecoder.field "author" OptimizedDecoder.string)
        (OptimizedDecoder.field "published" dateDecoder)
        (OptimizedDecoder.field "image" imageDecoder)
        (OptimizedDecoder.field "draft" OptimizedDecoder.bool
            |> OptimizedDecoder.maybe
            |> OptimizedDecoder.map (Maybe.withDefault False)
        )
        (OptimizedDecoder.field "categories" (OptimizedDecoder.list (categoryDecoder categories)))


categoryDecoder : List Category -> OptimizedDecoder.Decoder Category
categoryDecoder categories =
    let
        toCategory categoryName =
            case List.Extra.find (\{ name } -> String.toUpper name == String.toUpper categoryName) categories of
                Nothing ->
                    OptimizedDecoder.fail ("Could not find category " ++ categoryName)

                Just category ->
                    OptimizedDecoder.succeed category
    in
    OptimizedDecoder.string
        |> OptimizedDecoder.andThen toCategory


imageDecoder : OptimizedDecoder.Decoder Url
imageDecoder =
    OptimizedDecoder.string
        |> OptimizedDecoder.map (\cloudinaryAsset -> Cloudinary.url cloudinaryAsset Nothing 800)


dateDecoder : OptimizedDecoder.Decoder Date
dateDecoder =
    OptimizedDecoder.string
        |> OptimizedDecoder.andThen
            (\isoString ->
                case Date.fromIsoString isoString of
                    Ok date ->
                        OptimizedDecoder.succeed date

                    Err error ->
                        OptimizedDecoder.fail error
            )
