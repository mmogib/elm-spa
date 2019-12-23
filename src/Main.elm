module Main exposing (Model, Msg(..))

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Element
import Framework as Framework
import Framework.Grid as Grid
import Html exposing (Html)
import NotFound
import Page exposing (Page)
import Page.About as About
import Page.Home as Home
import Route as Route
import Url
import View exposing (navBar)



--Model


type alias Model =
    { page : Page
    , key : Nav.Key
    }


type Msg
    = NoOp
    | Redirect Url.Url
    | PushUrlToNav String
    | LoadExternalUrl String
    | GotHomeMsg Home.Msg
    | GotAboutMsg About.Msg



--init


changeRouteTo : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
changeRouteTo url key =
    let
        mayberoute =
            Route.fromUrl url
    in
    case mayberoute of
        Nothing ->
            ( { page = Page.NotFound, key = key }, Cmd.none )

        Just route ->
            case route of
                Route.NotFoundRoute ->
                    ( { page = Page.NotFound, key = key }, Cmd.none )

                Route.About ->
                    let
                        ( aboutModel, aboutCmds ) =
                            About.init "This is About page"
                    in
                    ( { page = Page.About aboutModel, key = key }
                    , Cmd.map GotAboutMsg aboutCmds
                    )

                Route.HomeRoute ->
                    let
                        ( homemodel, homecmds ) =
                            Home.init

                        model =
                            { page = Page.Home homemodel
                            , key = key
                            }

                        cmds =
                            Cmd.batch
                                [ Cmd.map GotHomeMsg homecmds
                                ]
                    in
                    ( model, cmds )


init : Maybe String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    changeRouteTo url key



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PushUrlToNav url ->
            ( model, Nav.pushUrl model.key url )

        --
        LoadExternalUrl url ->
            ( model, Nav.load url )

        Redirect url ->
            changeRouteTo url model.key

        GotAboutMsg submsg ->
            let
                oldsubmodl =
                    case model.page of
                        Page.About mdl ->
                            mdl

                        _ ->
                            Tuple.first (About.init "New Title")

                ( submodel, subcommands ) =
                    About.update submsg oldsubmodl
            in
            ( { model | page = Page.About submodel }, Cmd.map GotAboutMsg subcommands )

        GotHomeMsg submsg ->
            let
                oldsubmodl =
                    case model.page of
                        Page.Home mdl ->
                            mdl

                        _ ->
                            Tuple.first Home.init

                ( submodel, subcommands ) =
                    Home.update submsg oldsubmodl
            in
            ( { model | page = Page.Home submodel }, Cmd.map GotHomeMsg subcommands )

        NoOp ->
            ( model, Cmd.none )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- view


pageView : Model -> Element.Element Msg
pageView model =
    case model.page of
        Page.About submodel ->
            Element.map GotAboutMsg (About.view submodel)

        Page.NotFound ->
            NotFound.view

        Page.Home submodel ->
            Element.map GotHomeMsg (Home.view submodel)


mainView : Model -> List (Html Msg)
mainView model =
    [ navBar
    , Framework.layout [] <|
        Element.row Grid.spacedEvenly <|
            [ pageView model
            ]
    ]


view : Model -> Document Msg
view model =
    { title = "Site in Elm"
    , body = mainView model
    }



-- Url change and request
-- main


main : Program (Maybe String) Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = handleUrlChange
        , onUrlRequest = handleUrlRequest
        }



-- Handlers


handleUrlChange : Url.Url -> Msg
handleUrlChange url =
    Redirect url


handleUrlRequest : UrlRequest -> Msg
handleUrlRequest request =
    case request of
        Internal url ->
            case url.fragment of
                Nothing ->
                    NoOp

                Just _ ->
                    url
                        |> Url.toString
                        |> PushUrlToNav

        External href ->
            LoadExternalUrl href
