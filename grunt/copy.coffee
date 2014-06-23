module.exports = (grunt) -> {
  manifest:
    src:  'manifest.json',
    dest: "<%= buildDir %>"
    cwd: "<%= srcDir %>"
    expand: yes
    options:
      processContent: (content, srcpath) ->
        grunt.template.process(content, data: {
          version: grunt.config('package.version')
          name: grunt.config('package.name')
          description: grunt.config('package.description')
        })
  main:
    files: [
      expand: yes
      src: ['img/**']
      cwd: 'src'
      dest: "<%= buildDir %>"
    ,
      expand: yes
      src: ['**/*.html']
      cwd: 'src/html'
      dest: "<%= buildDir %>/html"
    ]
}
