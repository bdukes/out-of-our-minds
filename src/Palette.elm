module Palette exposing (blogHeading, color)

import Element exposing (Element)
import Element.Font as Font
import Element.Region


color :
    { primary : Element.Color
    , secondary : Element.Color
    , accent : Element.Color
    }
color =
    { primary = Element.rgb255 29 57 143
    , secondary = Element.rgb255 131 162 104
    , accent = Element.rgb255 245 94 0
    }


blogHeading : String -> Element msg
blogHeading title =
    Element.paragraph
        [ Font.bold
        , Font.family [ Font.typeface "Open Sans" ]
        , Element.Region.heading 1
        , Font.size 36
        , Font.center
        ]
        [ Element.text title ]
