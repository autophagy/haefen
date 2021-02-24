let Prelude =
      https://prelude.dhall-lang.org/v20.0.0/package.dhall sha256:21754b84b493b98682e73f64d9d57b18e1ca36a118b81b33d0a243de8455814b

let Link = { src : Text, desc : Text }

let Content = < Bare : Text | BareList : List Text | LinkList : List Link >

let Row = { ident : Text, content : Content }

let renderContent
    : Content → Text
    = λ(contentType : Content) →
        merge
          { Bare = λ(c : Text) → c
          , BareList = Prelude.Text.concatSep " | "
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

let render
    : List Row -> Text
    = \(rows : List Row) -> ''
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
            ${Prelude.Text.concatMapSep "\n" Row renderRow rows}
        </div>
    </body>
    </html>
    ''
in { Content = Content, Row = Row, render = render }
