path = require 'path'
os = require 'os'

# Add support for obselete APIs of vm module so we can make some third-party
# modules work under node v0.11.x.
require 'vm-compatibility-layer'

packageJson = require '../package.json'

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-cson'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-lesslint'
  grunt.loadNpmTasks 'grunt-contrib-csslint'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-download-atom-shell'

  grunt.file.setBase path.resolve '..'

  atomShellDownloadDir = path.join os.tmpdir(), 'atom-cached-atom-shells'
  appDir = path.join 'atom-shell', 'Atom.app', 'Contents', 'Resources', 'app'

  grunt.initConfig
    pkt: grunt.file.readJSON 'package.json'

    coffee:
      glob_to_multiple:
        expand: true
        #cwd: 'src'
        src: ['src/**/*.coffee']
        dest: appDir
        ext: '.js'

    less:
      options:
        paths: [
          'static/variables'
          'static'
        ]
      glob_to_multiple:
        expand: true
        src: ['static/**/*.coffee']
        dest: appDir
        ext: '.css'

    'prebuild-less':
      src: [
        'static/**/*.less'
        'node_modules/bootstrap/less/bootstrap.less'
      ]

    cson:
      options:
        rootObject: true
      glob_to_multiple:
        expand: true
        src: [
          'static/**/*.cson'
        ]
        dest: appDir
        ext: '.json'

    coffeelint:
      options:
        no_empty_param_list:
          level: 'error'
        max_line_length:
          level: 'ignore'
        indentation:
          level: 'ignore'
      src: [
        'dot-atom/**/*.coffee'
        'exports/**/*.coffee'
        'src/**/*.coffee'
      ]
      build: [
        'build/tasks/**/*.coffee'
        'build/Gruntfile.coffee'
      ]
      test: ['spec/**/*.coffee']

    csslint:
      options:
        'adjoining-classes': false
        'duplicate-background-images': false
        'box-model': false
        'box-sizing': false
        'bulletproof-font-face': false
        'compatible-vendor-prefixes': false
        'display-property-grouping': false
        'fallback-colors': false
        'font-sizes': false
        'gradients': false
        'ids': false
        'important': false
        'known-properties': false
        'outline-none': false
        'overqualified-elements': false
        'qualified-headings': false
        'unique-headings': false
        'universal-selector': false
        'vendor-prefix': false
      src: ['static/**/*.css']

    lesslint:
      src: ['static/**/*.less']

    'download-atom-shell':
      version: packageJson.atomShellVersion
      outputDir: 'atom-shell'
      downloadDir: atomShellDownloadDir
      rebuild: true  # rebuild native modules after atom-shell is updated

    shell:
      clean:
        command: 'rm -rf lib'
        options:
          stdout: true
          stderr: true
          failOrError: true

  grunt.registerTask 'compile', ['coffee', 'prebuild-less', 'cson']
  grunt.registerTask 'lint', ['coffeelint', 'csslint', 'lesslint']
  grunt.registerTask 'test', []
  grunt.registerTask 'default', ['download-atom-shell', 'build', 'lint']
  grunt.registerTask 'clean', ->
    rm = require('rimraf').sync
    rm 'lib'
  grunt.registerTask 'build', ->
    {cp, mkdir, rm} = require('./tasks/task-helpers')(grunt)
    rm path.join appDir, 'package.json'
    rm path.join appDir, 'node_modules'
    rm path.join appDir, 'static'
    cp 'package.json', path.join appDir, 'package.json'
    cp 'node_modules', path.join appDir, 'node_modules'
    cp 'static', path.join(appDir, 'static'), filter: /.+\.(cson|coffee)$/
    grunt.task.run 'compile'
  grunt.registerTask 'prebuild-less', ->
