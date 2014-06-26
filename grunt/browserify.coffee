TRANSFORMS = ['coffeeify', 'cssify', 'jadeify']

module.exports = (grunt) ->
  dev:
    files: [
      {src: '<%= srcDir %>/js/content.coffee', dest: "<%= buildDir %>/js/content.js"}
      {src: '<%= srcDir %>/js/popup.coffee', dest: "<%= buildDir %>/js/popup.js"}
    ]
    options:
      transform: TRANSFORMS
      external: [
        'jquery'
        'underscore'
        'angular'
      ]

  dist:
    files: "<%= browserify.dev.files %>",
    options:
      transform: TRANSFORMS.concat([])
      #alias: "<%= browserify.dev.options.alias %>"
      external: "<%= browserify.dev.options.external %>"

  test:
    src: ['<%= srcDir %>/js/*.spec.coffee'],
    dest: "<%= buildDir %>/test/browserified_tests.js",
    options:
      watch: true
      debug: true
      transform: ['coffeeify', 'cssify']
      #alias: "<%= browserify.dev.options.alias %>"
      external: "<%= browserify.dev.options.external %>"

  libs:
    src: []
    dest: "<%= buildDir %>/js/libs.js"
    options:
      alias: [
        '<%= srcDir %>/vendor/jquery/jquery.js:jquery'
        '<%= srcDir %>/vendor/angular/angular.js:angular'
        '<%= srcDir %>/vendor/underscore/underscore.js:underscore'
      ],
