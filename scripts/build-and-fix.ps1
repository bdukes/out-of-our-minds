if (Test-Path $PSScriptRoot/../elm-stuff/elm-pages/elm.js) {
    Remove-Item $PSScriptRoot/../elm-stuff/elm-pages/elm.js;
}
npm run build;
npm run fix;
