module Page.Home exposing (Model, Msg, init, update, view)

import Api
import Element as El
import Element.Input as Input
import Framework.Button as Button
import Framework.Card as Card
import Framework.Color as FColor
import Framework.Heading as Heading
import Json.Encode as E
import Task


type alias Model =
    { counter : Int
    , message : String
    }


type Msg
    = IncreaseBy Int
    | SetMessage String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetMessage message ->
            ( { model | message = message }, Api.storeCache (Just (E.string message)) )

        IncreaseBy amount ->
            let
                task =
                    Task.succeed "Changing counter"
            in
            ( { model | counter = model.counter + amount, message = "..." }, Task.perform SetMessage task )


view : Model -> El.Element Msg
view model =
    El.column (Card.fill ++ [])
        [ El.el (Heading.h1 ++ [ El.paddingXY 10 30 ]) <| El.text model.message
        , El.column (Card.large ++ [ El.centerX, El.paddingXY 25 20 ])
            [ El.row []
                [ String.fromInt model.counter
                    |> (++) "Counter = "
                    |> El.text
                ]
            , El.row [ El.paddingXY 0 40, El.alignRight ]
                [ Input.button (Button.simple ++ FColor.success ++ [ El.width El.fill ]) <|
                    { onPress = Just (IncreaseBy 5)
                    , label = El.text "Add"
                    }
                ]
            ]
        ]


init : ( Model, Cmd Msg )
init =
    ( Model 1 "Home Page", Cmd.none )
