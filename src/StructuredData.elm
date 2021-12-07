module StructuredData exposing (StructuredData(..), article, person)

import Json.Encode as Encode
import Pages.Url


{-| <https://schema.org/Article>
-}
article :
    { title : String
    , description : String
    , author : StructuredData { authorMemberOf | personOrOrganization : () } authorPossibleFields
    , publisher : StructuredData { publisherMemberOf | personOrOrganization : () } publisherPossibleFields
    , url : String
    , imageUrl : Pages.Url.Url
    , datePublished : String
    }
    -> Encode.Value
article info =
    Encode.object
        [ ( "@context", Encode.string "http://schema.org/" )
        , ( "@type", Encode.string "Article" )
        , ( "headline", Encode.string info.title )
        , ( "description", Encode.string info.description )
        , ( "image", Encode.string (Pages.Url.toString info.imageUrl) )
        , ( "author", encode info.author )
        , ( "publisher", encode info.publisher )
        , ( "url", Encode.string info.url )
        , ( "datePublished", Encode.string info.datePublished )
        ]


type StructuredData memberOf possibleFields
    = StructuredData String (List ( String, Encode.Value ))


{-| <https://schema.org/Person>
-}
person :
    { name : String
    }
    ->
        StructuredData
            { personOrOrganization : () }
            { additionalName : ()
            , address : ()
            , affiliation : ()
            }
person info =
    StructuredData "Person" [ ( "name", Encode.string info.name ) ]


encode : StructuredData memberOf possibleFieldsPublisher -> Encode.Value
encode (StructuredData typeName fields) =
    Encode.object
        (( "@type", Encode.string typeName ) :: fields)



--example :
--    StructuredData
--        { personOrOrganization : () }
--        { address : ()
--        , affiliation : ()
--        }
--example =
--    person { name = "Dillon Kearns" }
--        |> additionalName "Cornelius"
--organization :
--    {}
--    -> StructuredDataHelper { personOrOrganization : () }
--organization info =
--    StructuredDataHelper "Organization" []
--needsPersonOrOrg : StructuredDataHelper {}
--needsPersonOrOrg =
--    StructuredDataHelper "" []
