let Template = ./template.dhall
let Content = Template.Content


let name = { ident = "name", content = Content.Bare "Mika Naylor" }

let langs =
      { ident = "langs"
      , content = Content.BareList [ "Python", "Haskell", "Elm" ]
      }

let likes =
      { ident = "likes"
      , content = Content.BareList [ "Pure FP", "Type Systems", "Black Metal" ]
      }

let work = { ident = "work", content = Content.Bare "Ververica GmbH" }

let contact =
      { ident = "contact"
      , content =
          Content.LinkList
            [ { src = "mailto:eala@autophagy.io", desc = "email" }
            , { src = "https://github.com/autophagy", desc = "github" }
            , { src = "https://twitter.com/autophagian", desc = "twitter" }
            ]
      }

let rows = [ name, langs, likes, work, contact ]

in Template.render rows
