# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#signup_form').on 'ajax:success', (e, data, status, xhr) ->
    console.log data
  $('#signup_form').on 'ajax:error', (e, xhr, status, error) ->
    console.log e
    console.log error
    console.log status
    console.log xhr
capitalizeFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)