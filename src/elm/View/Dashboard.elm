module View.Dashboard exposing (..)

import Html exposing (Html)
import Html.Attributes
import Html.Events

import Types exposing (..)

view : Model -> Html Msg
view { newArticleFields } =
  Html.map NewArticleForm <|
    Html.div
      [ Html.Attributes.class "dashboard"
      , Html.Attributes.style <|
        if newArticleFields.focused then
          [ ("flex-direction", "column") ]
        else
          []
      ]
      [ Html.div
        [ Html.Attributes.class "dashboard-left" ] <|
        if newArticleFields.previewed then
          newArticlePreview newArticleFields
        else
          newArticleEdition newArticleFields
      , Html.div
        [ Html.Attributes.class "dashboard-right" ] []
      ]

newArticlePreview : NewArticleFields -> List (Html NewArticleAction)
newArticlePreview ({ title, content } as newArticleFields) =
  [ Html.h2 []
    [ Html.text "Nouvel article | Prévisualisation" ]
  , Html.h3 []
    [ Html.text title ]
  -- Preview in markdown
  , buttonRow newArticleFields
  ]

newArticleEdition : NewArticleFields -> List (Html NewArticleAction)
newArticleEdition ({ title, content, focused } as newArticleFields) =
  [ Html.h2 []
    [ Html.text "Nouvel article | Édition" ]
  , Html.input
    [ Html.Attributes.type_ "text"
    , Html.Attributes.placeholder "Titre…"
    , Html.Attributes.value title
    , Html.Events.onInput NewArticleTitle
    , Html.Events.onFocus NewArticleToggler
    , Html.Events.onBlur NewArticleToggler
    ] []
  , Html.textarea
    [ Html.Attributes.placeholder "Votre contenu en Markdown…"
    , Html.Attributes.value content
    , Html.Events.onInput NewArticleContent
    , Html.Events.onFocus NewArticleToggler
    , Html.Events.onBlur NewArticleToggler
    , Html.Attributes.style <|
      if focused then
        [ ("min-height", "200px") ]
      else
        []
    ] []
  , buttonRow newArticleFields
  ]

buttonRow : NewArticleFields -> Html NewArticleAction
buttonRow { previewed } =
  let previewButtonText = if previewed then "Retourner à l'édition" else "Prévisualiser" in
  Html.div
    [ Html.Attributes.class "dashboard--button-row" ]
    [ Html.button
      [ Html.Events.onClick NewArticleSubmit
      , Html.Attributes.value "Envoyer"
      , Html.Attributes.style [ ("flex", "0.5") ]
      ]
      [ Html.text "Envoyer" ]
    , Html.button
      [ Html.Events.onClick NewArticlePreview
      , Html.Attributes.value previewButtonText
      , Html.Attributes.style [ ("flex", "1") ]
      ]
      [ Html.text previewButtonText ]
    ]
