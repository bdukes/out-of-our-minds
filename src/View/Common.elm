module View.Common exposing (body, link)

import Accessibility.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (src)
import Route exposing (Route)


header : Html msg
header =
    Html.header []
        [ link Route.Index [] [ img "Out of Our Minds" [ src "/images/logo-main.svg" ] ]
        ]


footer : Html msg
footer =
    Html.footer [] []


body : List (Html msg) -> List (Html msg)
body contents =
    [ header
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
