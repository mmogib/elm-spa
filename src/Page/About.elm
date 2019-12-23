module Page.About exposing (Model, Msg(..), init, title, toTitle, update, view)

import Element as El
import Element.Input as Input
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as FColor
import Framework.Heading as Heading
import Random


type Model
    = Title String


type Msg
    = TitleChanged String
    | TitleChangedRandomly Int


title : Model -> String
title (Title str) =
    str


toTitle : String -> Model
toTitle str =
    Title str


init : String -> ( Model, Cmd Msg )
init str =
    ( toTitle str, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        TitleChanged str ->
            let
                cmds =
                    Random.generate TitleChangedRandomly (Random.int -8 9)
            in
            ( toTitle str, cmds )

        TitleChangedRandomly int ->
            ( String.fromInt int
                |> (++) "Random Title #"
                |> toTitle
            , Cmd.none
            )


view : Model -> El.Element Msg
view model =
    El.column (Card.fill ++ [])
        [ El.el (Heading.h1 ++ [ El.paddingXY 10 30 ]) <| El.text (title model)
        , El.column (Card.large ++ [ El.centerX, El.paddingXY 25 20 ])
            [ El.row []
                [ "String.fromInt model.counter"
                    |> (++) "Counter = "
                    |> El.text
                ]
            ]
        ]
