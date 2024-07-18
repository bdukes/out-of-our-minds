module Route.Store exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import Accessibility.Styled exposing (h2, text)
import BackendTask
import FatalError
import Head
import Head.Seo as Seo
import PagesMsg
import RouteBuilder
import Shared
import Site
import View


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single
        { data = data
        , head = head
        }
        |> RouteBuilder.buildNoState { view = view }


type alias Data =
    {}


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.succeed {}


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.siteName
        , image = Site.siteLogo
        , description = "Purchase creative resources to help your family find order in chaos"
        , locale = Nothing
        , title = "Store | Out of Our Minds"
        }
        |> Seo.website


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared =
    { title = "Store"
    , body = [ h2 [] [ text "Store" ] ]
    }
