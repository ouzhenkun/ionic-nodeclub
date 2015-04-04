var gulp = require('gulp');
var bower = require('bower');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var rename = require('gulp-rename');
var concat = require('gulp-concat');
var minifyCss = require('gulp-minify-css');

var paths = {
  sass: ['./www/scss/*.scss'],
  coffee: ['./www/coffee/*.coffee']
};

var handleError = function(error) {
  console.error(error.toString());
  this.emit('end');
}

gulp.task('sass', function(done) {
  gulp.src(paths.sass)
    .pipe(sass().on('error', handleError))
    .pipe(rename({ extname: '.css' }))
    .pipe(minifyCss({ keepSpecialComments: 0 }))
    .pipe(concat('style.css'))
    .pipe(gulp.dest('./www/css'))
    .on('end', done);
});

gulp.task('coffee', function(done) {
  gulp.src(paths.coffee)
    .pipe(coffee({ bare: true }).on('error', handleError))
    .pipe(concat('app.js'))
    .pipe(gulp.dest('./www/js'))
    .on('end', done);
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee, ['coffee']);
});

gulp.task('default', ['sass', 'coffee']);

