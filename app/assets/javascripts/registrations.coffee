# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('#signup_form').on 'ajax:success', (e, data, status, xhr) ->
		$('.alert').remove()
		$('#signup_form').prepend('<div class="alert alert-notice">A confirmation link has been sent to your email address!</div>')

	$('#signup_form').on 'ajax:error', (e, xhr, status, error) ->
		labels = $("#signup_form").children('.form-group')
		$('.alert').remove()
		if xhr.responseJSON.errors
			$('#signup_form').prepend('<div class="alert alert-danger"><a class="close" data-dismiss="alert">×</a><ul></ul></div>')
		$.each(xhr.responseJSON.errors, (field, msg) ->
			$('.alert-danger ul').append('<li>' + capitalizeFirstLetter(field) + ' ' + msg + '</li>')

		)
capitalizeFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)