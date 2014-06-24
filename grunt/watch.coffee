module.exports = {
  test:
    files: [
      '<%= srcDir %>/**/*.coffee'
      '<%= srcDir %>/**/*.js'
      '<%= srcDir %>/**/*.jade'
      '<%= srcDir %>/img/**/*.*'
      '<%= srcDir %>/**/*.css'
      '<%= srcDir %>/manifest.json'
    ]
    tasks: ['test']
}
