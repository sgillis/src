module Main (..) where

import Html exposing (div, Html, text)
import Mouse
import Signal exposing (map, merge, Signal)
import Time exposing (every, inSeconds, second, Time)


type alias Universe =
  { time : Time
  , place : ( Int, Int )
  }


initialUniverse : Universe
initialUniverse =
  { time = 0
  , place = ( 0, 0 )
  }


type UniverseEvent
  = ClockTick Time
  | Movement ( Int, Int )


updateUniverse : UniverseEvent -> Universe -> Universe
updateUniverse event universe =
  case event of
    ClockTick time ->
      { universe | time = time }

    Movement movement ->
      { universe | place = movement }


time : Signal UniverseEvent
time =
  map (ClockTick << inSeconds) (every second)


place : Signal UniverseEvent
place =
  map Movement Mouse.position


events : Signal UniverseEvent
events =
  Signal.merge time place


viewUniverse : Universe -> Html
viewUniverse universe =
  div
    []
    [ div [] [ text <| "Time: " ++ toString (inSeconds universe.time) ]
    , div [] [ text <| "x: " ++ toString (fst universe.place) ]
    , div [] [ text <| "y: " ++ toString (snd universe.place) ]
    ]


currentUniverse : Signal Universe
currentUniverse =
  Signal.foldp updateUniverse initialUniverse events


main : Signal Html.Html
main =
  Signal.map viewUniverse currentUniverse
