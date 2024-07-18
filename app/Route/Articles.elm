module Route.Articles exposing (ActionData, Data, Model, Msg, route)

import Accessibility.Styled exposing (text)
import Article
import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import PagesMsg exposing (PagesMsg)
import Route exposing (Route)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Site
import View exposing (View)
import View.Common


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    List ( Route, Article.ArticleMetadata )


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    Article.allMetadata


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.siteName
        , image = Site.siteLogo
        , description = "Our collection of articles on topics like education, nurture, sensory needs, trauma and more"
        , locale = Nothing
        , title = "Articles | Out of Our Minds"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app _ =
    { title = "Out of Our Minds"
    , body =
        View.Common.body
            (View.Common.pageHeading [] [ text "All articles" ]
                :: View.Common.articleList app.data
            )
    }
