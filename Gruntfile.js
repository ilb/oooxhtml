/*jslint skipme:true */
module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    concat: {
      options: {
        separator: ';'
      },
      js: {
        src : [
          'web/scripts/*.js'
        ],
        dest: 'docs/<%= pkg.name %>.js'
      }
    },
    uglify: {
      options: {
        banner: '/*jslint skipme:true */\n/* <%= pkg.name %> <%= grunt.template.today() %> */\n'
      },
      js: {
        files: {
          'docs/<%= pkg.name %>.min.js': ['<%= concat.js.dest %>']
        }
      }
    },
    watch: {
      scripts: {
        files: ['web/scripts/**/*.js'],
        tasks: ['default'],
        options: {
          spawn: false
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', [ 'concat:js' ]); //, 'uglify:js'
};
