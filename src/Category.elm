module Category exposing (Category, dataSource)

import DataSource
import DataSource.Glob


type alias Category =
    { name : String
    , icon : String
    }


dataSource : DataSource.DataSource (List Category)
dataSource =
    let
        toCategory prefix imageName suffix =
            { name = imageName, icon = prefix ++ imageName ++ suffix }
    in
    DataSource.Glob.succeed toCategory
        |> DataSource.Glob.match (DataSource.Glob.literal "public")
        |> DataSource.Glob.capture (DataSource.Glob.literal "/images/categories/")
        |> DataSource.Glob.capture DataSource.Glob.wildcard
        |> DataSource.Glob.capture (DataSource.Glob.literal ".svg")
        |> DataSource.Glob.toDataSource
