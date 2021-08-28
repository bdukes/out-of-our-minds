module View.Common exposing (link)

import Accessibility.Styled exposing (Attribute, Html, a)
import Html.Styled.Attributes
import Route exposing (Route)


link : Route -> List (Attribute Never) -> List (Html msg) -> Html msg
link route attributes children =
    Route.toLink
        (\anchorAttrs ->
            a (List.map Html.Styled.Attributes.fromUnstyled anchorAttrs ++ attributes) children
        )
        route
