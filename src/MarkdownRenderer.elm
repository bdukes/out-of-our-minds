module MarkdownRenderer exposing (renderer)

import Css
import Css.Global
import Html as UnstyledHtml
import Html.Styled as Html exposing (Html, fromUnstyled, toUnstyled)
import Html.Styled.Attributes as Attr
import Markdown.Block
import Markdown.Html
import Markdown.Renderer exposing (defaultHtmlRenderer, render)


renderer : Markdown.Renderer.Renderer (Html msg)
renderer =
    { heading = renderHeading
    , paragraph = toStyledRenderer defaultHtmlRenderer.paragraph
    , blockQuote = toStyledRenderer defaultHtmlRenderer.blockQuote
    , html = htmlRenderer
    , text = defaultHtmlRenderer.text >> fromUnstyled
    , codeSpan = defaultHtmlRenderer.codeSpan >> fromUnstyled
    , strong = toStyledRenderer defaultHtmlRenderer.strong
    , emphasis = toStyledRenderer defaultHtmlRenderer.emphasis
    , strikethrough = toStyledRenderer defaultHtmlRenderer.strikethrough
    , hardLineBreak = defaultHtmlRenderer.hardLineBreak |> fromUnstyled
    , link = \info -> toStyledRenderer (defaultHtmlRenderer.link info)
    , image = defaultHtmlRenderer.image >> fromUnstyled
    , unorderedList = renderUnorderedList
    , orderedList = renderOrderedList
    , codeBlock = defaultHtmlRenderer.codeBlock >> fromUnstyled
    , thematicBreak = defaultHtmlRenderer.thematicBreak |> fromUnstyled
    , table = toStyledRenderer defaultHtmlRenderer.table
    , tableHeader = toStyledRenderer defaultHtmlRenderer.tableHeader
    , tableBody = toStyledRenderer defaultHtmlRenderer.tableBody
    , tableRow = toStyledRenderer defaultHtmlRenderer.tableRow
    , tableCell = \info -> toStyledRenderer (defaultHtmlRenderer.tableCell info)
    , tableHeaderCell = \info -> toStyledRenderer (defaultHtmlRenderer.tableHeaderCell info)
    }


renderHeading : { level : Markdown.Block.HeadingLevel, rawText : String, children : List (Html msg) } -> Html msg
renderHeading { level, rawText, children } =
    defaultHtmlRenderer.heading { level = level, rawText = rawText, children = List.map toUnstyled children } |> fromUnstyled


renderUnorderedList : List (Markdown.Block.ListItem (Html msg)) -> Html msg
renderUnorderedList items =
    items
        |> List.map (\(Markdown.Block.ListItem task children) -> Markdown.Block.ListItem task (List.map toUnstyled children))
        |> defaultHtmlRenderer.unorderedList
        |> fromUnstyled


renderOrderedList : Int -> List (List (Html msg)) -> Html msg
renderOrderedList info items =
    items
        |> List.map (\children -> List.map toUnstyled children)
        |> defaultHtmlRenderer.orderedList info
        |> fromUnstyled


toStyledRenderer : (List (UnstyledHtml.Html msg) -> UnstyledHtml.Html msg) -> (List (Html msg) -> Html msg)
toStyledRenderer unstyledRenderer =
    \children -> unstyledRenderer (List.map toUnstyled children) |> fromUnstyled


htmlRenderer : Markdown.Html.Renderer (List (Html msg) -> Html msg)
htmlRenderer =
    Markdown.Html.oneOf
        [ Markdown.Html.tag "ooom-footnote-ref" viewFootnoteRef |> Markdown.Html.withAttribute "id"
        , Markdown.Html.tag "ooom-footnote" viewFootnote |> Markdown.Html.withAttribute "id"
        ]


viewFootnote : String -> List (Html msg) -> Html msg
viewFootnote id children =
    Html.div [ Attr.css [ Css.Global.children [ Css.Global.typeSelector "p" [ Css.display Css.inline ] ] ] ]
        (Html.sup [ Attr.id ("f" ++ id) ] [ Html.text id ] :: children ++ [ Html.a [ Attr.href ("#fr" ++ id) ] [ Html.text " ↩" ] ])


viewFootnoteRef : String -> List (Html msg) -> Html msg
viewFootnoteRef id _ =
    Html.a [ Attr.href ("#f" ++ id) ]
        [ Html.sup [ Attr.id ("fr" ++ id) ] [ Html.text id ]
        ]
