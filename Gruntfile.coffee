module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  #### Compiling (CoffeeScript, JS, Jade and LESS)
    coffee:
      dev:
        files:
          'dist/js/gallerygrid.js': ['src/**/*.coffee']

    uglify:
      options:
        mangle: no
        beautify: yes
        compress: no
      lib:
        files:
          'dist/js/lib.js': ['<%= pkg.build.js %>']

    less:
      dev:
        expand: true,
        cwd: 'src/less'
        src: ['**/*.less']
        dest: 'dist/css/'
        ext: '.css'
      lib:
        files:
          'dist/css/lib.css': ['<%= pkg.build.css %>']

    jade:
      options:
        pretty: yes
      dev:
        files:
          'dist/index.html': ['test/**/*.jade']

  #### Linting
    coffeelint:
      dev: [
        'Gruntfile.coffee'
        'src/**/*.coffee'
      ]

      options:
        no_unnecessary_double_quotes:
          level: 'warn' # single-quotes only unless necessary
        max_line_length:
          level: 'ignore' # nope, totes don't care

  #### Connect
    connect:
      dev:
        options:
          port: 9001
          livereload: yes
          base: 'dist'
          open:
            target: 'http://127.0.0.1:<%= connect.dev.options.port %>'

    copy:
      lib:
        files: [
          {expand: yes, cwd: 'bower_components/font-awesome/fonts/', src: '*', dest: 'dist/fonts'}
        ]


  #### Misc (automated testing using watch)
    watch:
      autoreload:
        files: ['src/**/*', 'package.json']
        tasks: ['build']
        options:
          livereload: yes

  grunt.registerTask 'build-lib', ['uglify:lib', 'less:lib', 'copy:lib']
  grunt.registerTask 'build',     ['coffeelint:dev', 'coffee:dev', 'less:dev', 'jade:dev']
  grunt.registerTask 'dev',       ['build-lib', 'build', 'connect:dev', 'watch']
