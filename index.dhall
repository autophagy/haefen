let Template = ./template.dhall

let C = Template.Content

let mainSection =
      [ { ident = "name", content = C.Text "Mika Naylor" }
      , { ident = "langs"
        ,content = C.TextList [ "Python", "Haskell", "Elm", "Nix" ]
        }
      , { ident = "likes"
        , content = C.TextList [ "Algebriac Data Types", "Black Metal" ]
        }
      , { ident = "contact"
        , content =
            C.LinkList
              [ { src = "mailto:eala@autophagy.io", desc = "email" }
              , { src = "https://github.com/autophagy", desc = "github" }
              , { src = "https://twitter.com/autophagian", desc = "twitter" }
              ]
        }
      ]

let talksSection =
      [ { ident = "2022.10.06"
        , content =
            C.Link
              { src = "https://www.youtube.com/watch?v=Kk9Ad1DAzKU"
              , desc = "Leading Beyond Tools, Process & Structure"
              }
        }
       , { ident = "2021.12.11"
        , content =
            C.Link
              { src = "https://youtu.be/hXKdtY8gHbs?t=7850"
              , desc = "Behind The Lambda"
              }
        }
      , { ident = "2020.04.17"
        , content =
            C.Link
              { src = "https://youtu.be/bO4qyBufcfQ?t=2356"
              , desc = "Functional-ish Python"
              }
        }
      , { ident = "2020.11.19"
        , content =
            C.Link
              { src = "https://www.meetup.com/PyLadies-Berlin/events/264674547/"
              , desc = "Developers X Operations Workshop"
              }
        }
      , { ident = "2019.07.14"
        , content =
            C.Link
              { src = "https://www.youtube.com/watch?v=qLoMFu14wmk"
              , desc = "Code Styles Aren't Black And White"
              }
        }
      ]

in  Template.render [ mainSection, talksSection ]
