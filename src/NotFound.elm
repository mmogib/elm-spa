module NotFound exposing (view)

import Asset
import Element as El
import Element.Input as Input
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as FColor
import Framework.Heading as Heading
import Route exposing (routeToString)


notFoundImg : Asset.Image
notFoundImg =
    Asset.error


view : El.Element msg
view =
    El.column (Card.fill ++ [])
        [ El.el (Heading.h1 ++ [ El.paddingXY 10 30 ]) <| El.text "Page Not Found"
        , El.column [ El.centerX, El.paddingXY 25 20 ]
            [ El.row []
                [ "Oops."
                    |> (++) "Counter = "
                    |> El.text
                ]
            , El.image [] { src = Asset.imageToString notFoundImg, description = "Not found" }
            ]
        ]
