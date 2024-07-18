module Styles exposing (categoryImageStyles, palette)

import Css


type alias PaletteColor =
    { name : String
    , hue : Float
    , saturation : Float
    }


primary : PaletteColor
primary =
    { name = "blue"
    , hue = 225
    , saturation = 0.663
    }


secondary : PaletteColor
secondary =
    { name = "green"
    , hue = 92
    , saturation = 0.238
    }


accent : PaletteColor
accent =
    { name = "orange"
    , hue = 23
    , saturation = 1
    }


palette :
    { white : Css.Color
    , black : Css.Color
    , primary : Css.Color
    , primaryTransparent : Css.Color
    , primarySemiTransparent : Css.Color
    , primaryLight : Css.Color
    , primaryDark : Css.Color
    , primaryMuted : Css.Color
    , primaryDeep : Css.Color
    , secondary : Css.Color
    , secondaryTransparent : Css.Color
    , secondarySemiTransparent : Css.Color
    , secondaryLight : Css.Color
    , secondaryDark : Css.Color
    , accent : Css.Color
    , accentLight : Css.Color
    , accentDark : Css.Color
    }
palette =
    { white = Css.hsl primary.hue 0 0.99
    , black = Css.hsl primary.hue 1 0.01
    , primary = Css.hsl primary.hue primary.saturation 0.337
    , primaryTransparent = Css.hsla primary.hue primary.saturation 0.337 0.75
    , primarySemiTransparent = Css.hsla primary.hue primary.saturation 0.337 0.9
    , primaryLight = Css.hsl primary.hue primary.saturation 0.5
    , primaryDark = Css.hsl primary.hue primary.saturation 0.3
    , primaryMuted = Css.hsl primary.hue primary.saturation 0.95
    , primaryDeep = Css.hsl primary.hue primary.saturation 0.1
    , secondary = Css.hsl secondary.hue secondary.saturation 0.522
    , secondaryTransparent = Css.hsla secondary.hue secondary.saturation 0.522 0.75
    , secondarySemiTransparent = Css.hsla secondary.hue secondary.saturation 0.522 0.9
    , secondaryLight = Css.hsl secondary.hue secondary.saturation 0.6
    , secondaryDark = Css.hsl secondary.hue secondary.saturation 0.4
    , accent = Css.hsl accent.hue accent.saturation 0.48
    , accentLight = Css.hsl accent.hue accent.saturation 0.6
    , accentDark = Css.hsl accent.hue accent.saturation 0.4
    }


categoryImageStyles : Css.Style
categoryImageStyles =
    Css.batch
        [ Css.minHeight (Css.px 50)
        , Css.maxHeight (Css.rem 5)
        ]
