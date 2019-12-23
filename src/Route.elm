module Route exposing (Route(..), fromUrl, routeToPieces, routeToString)

import Url
import Url.Parser as Parser


type Route
    = NotFoundRoute
    | HomeRoute
    | About


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map HomeRoute Parser.top
        , Parser.map HomeRoute (Parser.s "home")
        , Parser.map About (Parser.s "about")
        ]


routeToString : Route -> String
routeToString page =
    "#/" ++ String.join "/" (routeToPieces page)


routeToPieces : Route -> List String
routeToPieces page =
    case page of
        HomeRoute ->
            [ "home" ]

        About ->
            [ "about" ]

        NotFoundRoute ->
            []


fromUrl : Url.Url -> Maybe Route
fromUrl url =
    Parser.parse parser { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
