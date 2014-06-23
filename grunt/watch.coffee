module.exports = {
  test:
    files: [
      '<%= srcDir %>/**/*.coffee'
      '<%= srcDir %>/**/*.js'
      '<%= srcDir %>/**/*.jade'
      '<%= srcDir %>/**/*.html'
      '<%= srcDir %>/img/**/*.*'
      '<%= srcDir %>/manifest.json'
    ]
    tasks: ['test']
}
