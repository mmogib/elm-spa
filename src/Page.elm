module Page exposing (Page(..), PageModel(..))

import Page.About as About
import Page.Home as Home


type Page
    = NotFound
    | Home Home.Model
    | About About.Model


type alias AboutModel =
    About.Model


type alias HomeModel =
    Home.Model


type PageModel
    = AboutModel
    | HomeModel
