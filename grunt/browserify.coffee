TRANSFORMS = ['coffeeify', 'cssify', 'jadeify']

module.exports = (grunt) ->
  dev:
    files: [
      {src: '<%= srcDir %>/js/content.coffee', dest: "<%= buildDir %>/js/content.js"}
      {src: '<%= srcDir %>/js/popup.coffee', dest: "<%= buildDir %>/js/popup.js"}
    ]
    options:
      transform: TRANSFORMS
      alias: [
        'src/vendor/jquery/jquery.js:jquery',
        'src/vendor/angular/angular.js:angular'
        'src/vendor/underscore/underscore.js:underscore'
      ],
      external: [
        'src/vendor/jquery/jquery.js',
        'src/vendor/angular/angular.js'
        'src/vendor/underscore/underscore.js'
      ]

  dist:
    files: "<%= browserify.dev.files %>",
    options:
      transform: TRANSFORMS.concat([])
      alias: "<%= browserify.dev.options.alias %>"
      external: "<%= browserify.dev.options.external %>"

  test:
    src: ['<%= srcDir %>/js/*.spec.coffee'],
    dest: "<%= buildDir %>/test/browserified_tests.js",
    options:
      # Embed source map for tests
      debug: true
      transform: ['coffeeify', 'cssify']
      alias: "<%= browserify.dev.options.alias %>"
      external: "<%= browserify.dev.options.external %>"

  libs:
    options:
      shim:
        jquery:
          path: '<%= srcDir %>/vendor/jquery/jquery.js',
          exports: '$'
        underscore:
          path: '<%= srcDir %>/vendor/underscore/underscore.js',
          exports: '_'
        angular:
          path: '<%= srcDir %>/vendor/angular/angular.js',
          exports: 'angular',
          depends:
            jquery: '$'
    src: [
      '<%= srcDir %>/vendor/jquery/jquery.js'
      '<%= srcDir %>/vendor/angular/angular.js'
      '<%= srcDir %>/vendor/underscore/underscore.js'
    ],
    dest: "<%= buildDir %>/js/libs.js"
