let Prelude =
        env:DHALL_PRELUDE
      ? https://prelude.dhall-lang.org/v20.0.0/package.dhall sha256:21754b84b493b98682e73f64d9d57b18e1ca36a118b81b33d0a243de8455814b

let drv = env:DRV as Text ? ""

let Link = { src : Text, desc : Text }

let Content =
      < Text : Text
      | Link : Link
      | TextList : List Text
      | LinkList : List Link
      >

let Row = { ident : Text, content : Content }

let Section = List Row

let renderLink
    : Link → Text
    = λ(link : Link) → "<a href=${link.src}>${link.desc}</a>"

let renderContent
    : Content → Text
    = λ(contentType : Content) →
        merge
          { Text = λ(c : Text) → c
          , Link = renderLink
          , TextList = Prelude.Text.concatSep " | "
          , LinkList =
              Prelude.Text.concatMapSep
                " | "
                Link
                (λ(c : Link) → "<a href=${c.src}>${c.desc}</a>")
          }
          contentType

let renderRow
    : Row → Text
    = λ(row : Row) →
        ''
        <div class='row'>
            <span class='ident'>${row.ident}</span>
            <span class='sep'> :: </span>
            <span class='content'>${renderContent row.content}</span>
        </div>
        ''

let renderSection
    : Section → Text
    = λ(section : Section) →
        ''
        <div class="section">
            ${Prelude.Text.concatMapSep "\n" Row renderRow section}
        </div>
        ''

let render
    : List Section → Text
    = λ(sections : List Section) →
        ''
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <meta name="theme-color" content="#000000">
            <link rel="shortcut icon" href="favicon.ico">
            <link rel="stylesheet" href="main.css">
            <link rel="preconnect" href="https://fonts.gstatic.com">
            <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono&display=swap" rel="stylesheet">
            <title>Mika Naylor</title>
        </head>
        <body>
            <div id="text">
                ${Prelude.Text.concatMapSep "\n" Section renderSection sections}
            </div>
            <footer class="section"><a href="https://github.com/autophagy/haefen">${drv}</a></footer>
        </body>
        </html>
        ''

in  { Content, Row, render }
