module View exposing (navBar)

import Html
    exposing
        ( Attribute
        , Html
        , a
        , button
        , div
        , li
        , nav
        , span
        , text
        , ul
        )
import Html.Attributes exposing (attribute, class, href, id)


navBar : Html msg
navBar =
    nav [ class "navbar navbar-expand-lg navbar-dark bg-primary " ]
        [ a [ class "navbar-brand", href "#" ] [ text "My site" ]
        , button
            [ class "navbar-toggler"
            , dataProp "toggle" "collapse"
            , dataProp "target" "#navbarToggler"
            ]
            [ span [ class "navbar-toggler-icon" ] [] ]

        --  data-toggle="collapse" data-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation"
        , div [ class "collapse navbar-collapse", id "navbarToggler" ]
            -- id="navbarColor01"
            [ ul [ class "navbar-nav mr-auto" ]
                [ li [ class "nav-item active" ]
                    [ a [ class "nav-link", href "#/home" ]
                        [ text "Home"
                        , span [ class "sr-only" ] [ text "(current)" ]
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "#/about" ]
                        [ text "About"
                        ]
                    ]
                ]
            ]
        ]


dataProp : String -> String -> Attribute msg
dataProp name value =
    attribute ("data-" ++ name) value
