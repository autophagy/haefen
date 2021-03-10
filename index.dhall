let Template = ./template.dhall

let Content = Template.Content

let name = { ident = "name", content = Content.Text "Mika Naylor" }

let langs =
      { ident = "langs"
      , content = Content.TextList [ "Python", "Haskell", "Elm" ]
      }

let likes =
      { ident = "likes"
      , content = Content.TextList [ "Pure FP", "Type Systems", "Black Metal" ]
      }

let work = { ident = "work", content = Content.Text "Ververica GmbH" }

let contact =
      { ident = "contact"
      , content =
          Content.LinkList
            [ { src = "mailto:eala@autophagy.io", desc = "email" }
            , { src = "https://github.com/autophagy", desc = "github" }
            , { src = "https://twitter.com/autophagian", desc = "twitter" }
            ]
      }

let mainSection = [ name, langs, likes, work, contact ]

let talksSection =
      [ { ident = "2020.04.17"
        , content =
            Content.Link
              { src = "https://youtu.be/bO4qyBufcfQ?t=2356"
              , desc = "Functional-ish Python"
              }
        }
      , { ident = "2020.11.19"
        , content =
            Content.Link
              { src = "https://www.meetup.com/PyLadies-Berlin/events/264674547/"
              , desc = "Developers X Operations Workshop"
              }
        }
      , { ident = "2019.07.14"
        , content =
            Content.Link
              { src = "https://www.youtube.com/watch?v=qLoMFu14wmk"
              , desc = "Code Styles Aren't Black And White"
              }
        }
      ]

in  Template.render [ mainSection, talksSection ]
