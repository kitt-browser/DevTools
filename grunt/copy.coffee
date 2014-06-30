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

  vendor:
    files: [
      expand: yes
      src: ['iscroll/iscroll-lite.js']
      cwd: '<%= srcDir %>/vendor/'
      dest: "<%= buildDir %>/js"
    ]

  img:
    files: [
      expand: yes
      src: ['**']
      cwd: '<%= srcDir %>/img'
      dest: "<%= buildDir %>/img"
    ]

  css:
    files: [
     expand: yes
     src: ['**/*.html']
     cwd: '<%= srcDir %>/css'
     dest: "<%= buildDir %>/css"
    ]

  html:
    files: [
      expand: yes
      src: ['**/*.html']
      cwd: '<%= srcDir %>/html'
      dest: "<%= buildDir %>/html"
    ]
}
