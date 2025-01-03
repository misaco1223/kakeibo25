module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",  // viewsディレクトリ内の全てのHTML/ERBファイルを対象
    "./app/assets/stylesheets/**/*.css",  // stylesheetsディレクトリ内の全てのCSSファイルを対象
    "./app/javascript/**/*.js"  // JavaScriptファイルも対象
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
  ],
}
