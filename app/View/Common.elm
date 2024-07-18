module View.Common exposing (articleList, body, categoryImageLink, categoryList, link, linkStyle, pageHeading)

import Accessibility.Styled as Html exposing (..)
import Article exposing (ArticleMetadata)
import Category exposing (Category)
import Css exposing (auto, center, color, fontFamilies, margin2, maxWidth, sansSerif, textAlign, width, zero)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled.Attributes as Attr exposing (css, src, title)
import Route exposing (Route)
import Styles exposing (categoryImageStyles)


mainStyle : Css.Style
mainStyle =
    Css.batch
        [ fontFamilies [ Css.qt "Open Sans", .value sansSerif ]
        , color Styles.palette.black
        , margin2 zero auto
        , width (Css.pct 100)
        , maxWidth (Css.px 960)
        ]


mainHeader : Html msg
mainHeader =
    Html.header [ css [ mainStyle, Css.marginTop (Css.em 1), Css.property "grid-area" "header" ] ]
        [ link Route.Index [] [ img "Out of Our Minds" [ src "/images/logo-main.svg" ] ]
        ]


mainFooter : Html msg
mainFooter =
    let
        iconStyle =
            Css.batch [ Css.height (Css.em 1), Css.position Css.relative, Css.bottom (Css.em -0.1) ]
    in
    Html.footer
        [ css
            [ Css.backgroundColor Styles.palette.primaryMuted
            , Css.color Styles.palette.primaryDeep
            , Css.property "grid-area" "footer"
            , Css.alignSelf Css.end
            , Css.textAlign Css.center
            , Css.padding (Css.em 1)
            ]
        , Attr.attribute "xmlns:cc" "http://creativecommons.org/ns#"
        ]
        [ Html.small []
            [ text "Text and images are works by "
            , Html.span [ Attr.attribute "property" "cc:attributionName" ] [ text "Nikki Dukes" ]
            , text " and licensed under "
            , Html.a [ Attr.href "http://creativecommons.org/licenses/by-nc/4.0/?ref=chooser-v1", Attr.target "_blank", Attr.rel "license noopener noreferrer" ]
                [ Html.figure [ css [ Css.display Css.inlineFlex, Css.margin zero, Css.property "gap" "0.25em" ] ]
                    [ Html.figcaption [ css [ Css.display Css.inline, Css.color Styles.palette.primaryDeep, Css.textDecoration Css.underline ] ]
                        [ text "Attribution-NonCommercial 4.0 International"
                        ]
                    , Html.decorativeImg [ src "https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1", css [ iconStyle ] ]
                    , Html.decorativeImg [ src "https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1", css [ iconStyle ] ]
                    , Html.decorativeImg [ src "https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1", css [ iconStyle ] ]
                    ]
                ]
            ]
        ]


body : List (Html msg) -> List (Html msg)
body contents =
    [ mainHeader
    , main_ [ css [ mainStyle, Css.property "grid-area" "main" ] ] contents
    , mainFooter
    ]


link : Route -> List (Attribute Never) -> List (Html msg) -> Html msg
link route attributes children =
    Route.toLink
        (\anchorAttrs ->
            a (List.map Attr.fromUnstyled anchorAttrs ++ attributes) children
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


linkStyle : Css.Style
linkStyle =
    Css.batch
        [ Css.color Styles.palette.primary
        , Css.visited [ Css.color Styles.palette.secondaryDark ]
        , Css.hover [ Css.color Styles.palette.secondary ]
        , Css.focus [ Css.color Styles.palette.secondary ]
        ]


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
                        "title"
                        "categories"
                        "description"
                        """
                    , withMedia [ only screen [ Media.minWidth (Css.px 550) ] ]
                        [ Css.property "grid-template-areas"
                            """
                            "title       categories"
                            "description categories"
                            """
                        ]
                    , Css.borderBottom3 (Css.em 0.05) Css.solid Styles.palette.accentLight
                    ]
                ]
                [ listHeading [ css [ Css.property "grid-area" "title", Css.marginBottom zero ] ]
                    [ link route [ css [ linkStyle ] ] [ text articleMetadata.title ]
                    ]
                , categoryList
                    [ css
                        [ Css.property "grid-area" "categories"
                        , Css.justifyContent Css.flexStart
                        , withMedia [ only screen [ Media.minWidth (Css.px 550) ] ] [ Css.justifyContent Css.flexEnd ]
                        ]
                    ]
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
