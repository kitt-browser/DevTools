module.exports = (grunt) -> {
  default: [
    'clean'
    'newer:copy'
    'browserify:libs'
    'browserify:dist'
    'crx:main'
    'notify:build_complete'
  ]


  dev: [
    'clean'
    'connect:testing:server'
    'browserify:libs'
    'concurrent:dev'
    'mocha_phantomjs'
    'notify:build_complete'
    'watch'
  ]

  test: [
    'concurrent:dev'
    'mocha_phantomjs'
    'notify:build_complete'
  ]
}
