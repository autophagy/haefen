let Template = ./template.dhall

let C = Template.Content

let mainSection =
      [ { ident = "name", content = C.Text "Mika Naylor" }
      , { ident = "langs"
        , content = C.TextList [ "Nix", "Rust", "Python", "Haskell", "Elm" ]
        }
      , { ident = "work"
        , content = C.Link { src = "https://confluent.io", desc = "confluent" }
        }
      , { ident = "contact"
        , content =
            C.LinkList
              [ { src = "mailto:eala@autophagy.io", desc = "email" }
              , { src = "https://github.com/autophagy", desc = "github" }
              , { src = "https://hordburh.autophagy.io/@mika", desc = "fediverse" }
              , { src = "https://bsky.app/profile/autophagy.io", desc = "bluesky" }
              ]
        }
      , { ident = "pgp"
        , content = C.Link { src = "/gpg.pub", desc = "9B0A 46AC C6F6 E9FB" }
        }
      ]

let projectsSection =
      [ { ident = "wordhord"
        , content =
            C.Link
              { src = "https://wordhord.autophagy.io"
              , desc = "blog & tiny static site generator"
              }
        }
      , { ident = "antimber"
        , content =
            C.Link
              { src = "https://github.com/autophagy/antimber"
              , desc = "nixOS & homemanager configuration"
              }
        }
      , { ident = "færeld"
        , content =
            C.Link
              { src = "https://github.com/autophagy/faereld"
              , desc = "cli time tracking tool"
              }
        }
      , { ident = "insegel"
        , content =
            C.Link
              { src = "https://github.com/autophagy/insegel"
              , desc = "sphinx theme"
              }
        }
      , { ident = "scieldas"
        , content =
            C.Link
              { src = "https://scieldas.autophagy.io"
              , desc = "metadata badges for open source projects"
              }
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

in  Template.render [ mainSection, projectsSection, talksSection ]
