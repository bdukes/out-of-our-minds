module Category exposing (Category, dataSource)

import BackendTask exposing (BackendTask)
import BackendTask.Glob
import FatalError exposing (FatalError)


type alias Category =
    { name : String
    , icon : String
    }


dataSource : BackendTask FatalError (List Category)
dataSource =
    let
        toCategory prefix imageName suffix =
            { name = imageName, icon = prefix ++ imageName ++ suffix }
    in
    BackendTask.Glob.succeed toCategory
        |> BackendTask.Glob.match (BackendTask.Glob.literal "public")
        |> BackendTask.Glob.capture (BackendTask.Glob.literal "/images/categories/")
        |> BackendTask.Glob.capture BackendTask.Glob.wildcard
        |> BackendTask.Glob.capture (BackendTask.Glob.literal ".svg")
        |> BackendTask.Glob.toBackendTask
