# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//= require ckeditor/init
$ ->
  $('.new-comment textarea').autogrow();
  $('.comment-list').css('border-top','0px') if $('.comment-list > li').size() is 0
