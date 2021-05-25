module Palette exposing (blogHeading, color)

import Element exposing (Element)
import Element.Font as Font
import Element.Region


color :
    { primary : Element.Color
    , primaryLight : Element.Color
    , primaryDark : Element.Color
    , secondary : Element.Color
    , secondaryLight : Element.Color
    , secondaryDark : Element.Color
    , accent : Element.Color
    , accentLight : Element.Color
    , accentDark : Element.Color
    }
color =
    { primary = Element.rgb255 29 57 143 -- hsl(225deg, 66.3%, 33.7%)
    , primaryLight = Element.rgb255 43 85 212 -- hsl(225deg, 66.3%, 50%)
    , primaryDark = Element.rgb255 26 51 127 -- hsl(225deg, 66.3%, 30%)
    , secondary = Element.rgb255 131 162 104 -- hsl(92deg, 23.8%, 52.2%)
    , secondaryLight = Element.rgb255 151 177 129 -- hsl(92deg, 23.8%, 60%)
    , secondaryDark = Element.rgb255 100 126 78 -- hsl(92deg, 23.8%, 40%)
    , accent = Element.rgb255 245 94 0 -- hsl(23deg,100%,48%)
    , accentLight = Element.rgb255 255 129 51 -- hsl(23deg, 100%, 60%)
    , accentDark = Element.rgb255 204 78 0 -- hsl(23deg, 100%, 40%)
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
