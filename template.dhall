let Prelude =
        env:DHALL_PRELUDE
      ? https://prelude.dhall-lang.org/v20.0.0/package.dhall
          sha256:21754b84b493b98682e73f64d9d57b18e1ca36a118b81b33d0a243de8455814b

let drv = env:DRV as Text ? ""

let Identity = { name : Text, curse : Text }

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
          , TextList = Prelude.Text.concatSep "<span class='sep'>·</span>"
          , LinkList =
              Prelude.Text.concatMapSep
                "<span class='sep'>·</span>"
                Link
                (λ(c : Link) → "<a href=${c.src}>${c.desc}</a>")
          }
          contentType

let renderRow
    : Text → Row → Text
    = λ(identClass : Text) →
      λ(row : Row) →
        ''
        <span class='${identClass}'>${row.ident}</span><span class='d'>::</span><span class='v'>${renderContent
                                                                                                    row.content}</span>
        ''

let renderMain
    : Section → Text
    = λ(section : Section) →
        ''
        <section class="rows">
            ${Prelude.Text.concatMapSep "\n" Row (renderRow "k") section}
        </section>
        ''

let renderTalks
    : Section → Text
    = λ(section : Section) →
        ''
        <p class="rubric">talks</p>
        <section class="talks">
            ${Prelude.Text.concatMapSep "\n" Row (renderRow "date") section}
        </section>
        ''

let render
    : Identity → Section → Section → Text
    = λ(identity : Identity) →
      λ(main : Section) →
      λ(talks : Section) →
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
                <script src="becoming.js"></script>
                <title>${identity.name}</title>
            </head>
            <body>
                <canvas id="field" aria-hidden="true"></canvas>

                <main>
                    <p class="namemark">
                        ${Prelude.Text.lowerASCII identity.name}
                        <span id="curse">[${identity.curse}]</span>
                    </p>

                    ${renderMain main}

                    <hr>

                    ${renderTalks talks}

                    <section class="colophon">
                        <p class="v"><a href="https://github.com/autophagy/haefen">${drv}</a></p>
                        <p id="mouth"></p>
                    </section>
                </main>

                <script>
                    become("${drv}", "field")
                    speak("${drv}", "mouth")
                </script>
            </body>
        </html>
            ''

in  { Content, Row, render }
