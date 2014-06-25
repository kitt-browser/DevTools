module.exports = {
  test:
    files: [
      '<%= srcDir %>/**/*.coffee'
      '<%= srcDir %>/**/*.js'
      '<%= srcDir %>/**/*.jade'
      '<%= srcDir %>/img/**/*.*'
      '<%= srcDir %>/**/*.css'
      '<%= srcDir %>/**/*.html'
      '<%= srcDir %>/manifest.json'
    ]
    tasks: ['test']
}
