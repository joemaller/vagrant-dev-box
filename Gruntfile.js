module.exports = function (grunt) {
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-compass');

    grunt.initConfig({
        watch: {
            grunt: {
                files: ['Gruntfile.js']
            },
            html: {
                files: ['public/**/*.html', 'public/**/*.php'],
                options: {
                    livereload: true
                }
            },
            compass: {
                files: ['public/scss/**/*.scss'],
                tasks: ['compass:dev']
            },
            css: {
                files: ['public/css/**/*.css'],
                options: {
                    livereload: true
                }

            }
        },
        compass: {
            dev: {
                options: {
                    sassDir: 'public/scss',
                    cssDir: 'public/css'

                }
            }
        }
    });
}