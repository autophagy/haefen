let Template = ./template.dhall

let C = Template.Content

let identity = { name = "Mika Naylor", curse = "she/her" }

let mainSection =
      [ { ident = "sympathies"
        , content =
            C.TextList [ "reproducible builds", "type systems", "riesling" ]
        }
      , { ident = "labour"
        , content =
            C.LinkList
              [ { src = "https://wyrhtaceramics.com/"
                , desc = "wyrhta ceramics"
                }
              , { src = "https://confluent.io", desc = "confluent" }
              ]
        }
      , { ident = "hoards"
        , content =
            C.LinkList
              [ { src = "https://github.com/autophagy", desc = "github" }
              , { src = "https://tangled.org/autophagy.io", desc = "tangled" }
              ]
        }
      , { ident = "speech"
        , content =
            C.LinkList
              [ { src = "mailto:eala@autophagy.io", desc = "email" }
              , { src = "https://mu.social/profile/autophagy.io", desc = "mu" }
              ]
        }
      ]

let talksSection =
      [ { ident = "2025.04.23"
        , content =
            C.Link
              { src = "https://2025.pycon.de/talks/UH7FXA/"
              , desc = "Instrumenting Python Applications with OpenTelemetry"
              }
        }
      , { ident = "2022.10.06"
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
      , { ident = "2020.04.17"
        , content =
            C.Link
              { src = "https://youtu.be/bO4qyBufcfQ?t=2356"
              , desc = "Functional-ish Python"
              }
        }
      ]

in  Template.render identity mainSection talksSection
