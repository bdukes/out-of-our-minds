module View exposing (View, map, placeholder)

import Accessibility.Styled exposing (Html, text)
import View.Common


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body = List.map (Accessibility.Styled.map fn) doc.body
    }


placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder - " ++ moduleName
    , body = View.Common.body [ text moduleName ]
    }
