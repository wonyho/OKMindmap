let mix = require("laravel-mix");

mix
  .js("src/assets/js/app.js", "dist/assets/js/app.js")
  .sass("src/assets/sass/app.scss", "dist/assets/css/app.css")
  .setPublicPath("dist")
  .options({
    processCssUrls: false
  })
  .sourceMaps();
