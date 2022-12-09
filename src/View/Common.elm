module View.Common exposing (articleList, body, categoryImageLink, categoryList, link, pageHeading)

import Accessibility.Styled as Html exposing (..)
import Article exposing (ArticleMetadata)
import Category exposing (Category)
import Css exposing (center, textAlign, zero)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled.Attributes exposing (css, src, title)
import Route exposing (Route)
import Styles exposing (categoryImageStyles)


mainHeader : Html msg
mainHeader =
    Html.header []
        [ link Route.Index [] [ img "Out of Our Minds" [ src "/images/logo-main.svg" ] ]
        ]


footer : Html msg
footer =
    Html.footer [] []


body : List (Html msg) -> List (Html msg)
body contents =
    [ mainHeader
    , main_ [] contents
    , footer
    ]


link : Route -> List (Attribute Never) -> List (Html msg) -> Html msg
link route attributes children =
    Route.toLink
        (\anchorAttrs ->
            a (List.map Html.Styled.Attributes.fromUnstyled anchorAttrs ++ attributes) children
        )
        route


categoryImageLink : Category -> Html msg
categoryImageLink category =
    let
        route =
            Route.Articles__Category_ { category = category.name }
    in
    link route
        [ css [ textAlign center ], title ("View all of the articles in the " ++ category.name ++ " category") ]
        [ img category.name [ src category.icon, css [ categoryImageStyles ] ]
        ]


categoryList : List (Attribute Never) -> List Category -> Html msg
categoryList attributes categories =
    let
        viewCategory : Category -> Html msg
        viewCategory category =
            li [ css [ Css.padding2 Css.zero (Css.rem 1) ] ]
                [ categoryImageLink category
                ]
    in
    if List.isEmpty categories then
        none

    else
        ul (css [ Css.listStyle Css.none, Css.displayFlex, Css.padding zero ] :: attributes)
            (List.map viewCategory categories)


pageHeading : List (Attribute Never) -> List (Html msg) -> Html msg
pageHeading attributes children =
    let
        fontSizeStyle =
            css
                [ Css.fontSize (Css.em 1.8)
                , withMedia [ only screen [ Media.minWidth (Css.px 960) ] ]
                    [ Css.fontSize (Css.em 2) ]
                ]
    in
    h2 (fontSizeStyle :: attributes)
        children


listHeading : List (Attribute Never) -> List (Html msg) -> Html msg
listHeading attributes children =
    let
        fontSizeStyle =
            css
                [ Css.fontSize (Css.em 1.3)
                , withMedia [ only screen [ Media.minWidth (Css.px 960) ] ]
                    [ Css.fontSize (Css.em 1.5) ]
                ]
    in
    h3 (fontSizeStyle :: attributes)
        children


articleList : List ( Route, ArticleMetadata ) -> List (Html msg)
articleList articles =
    let
        viewArticle ( route, articleMetadata ) =
            section
                [ css
                    [ Css.property "display" "grid"
                    , Css.property "gap" "1em"
                    , Css.property "grid-template-areas"
                        """
                        "title       categories"
                        "description categories"
                        """
                    ]
                ]
                [ listHeading [ css [ Css.property "grid-area" "title", Css.marginBottom zero ] ]
                    [ link route [] [ text articleMetadata.title ]
                    ]
                , categoryList [ css [ Css.property "grid-area" "categories" ] ]
                    articleMetadata.categories
                , p [ css [ Css.property "grid-area" "description", Css.margin zero ] ]
                    [ text articleMetadata.description
                    ]
                ]
    in
    List.map viewArticle articles


none : Html msg
none =
    text ""
