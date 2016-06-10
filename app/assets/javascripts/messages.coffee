# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
	$('#new_message').on 'ajax:error', (e, xhr, status, error) ->
		$('#message_content').effect("highlight" , {color: "#FF8F85"}, 400)