$(document).ready(function () {
    $('a.load-more').click(function (e) {
        e.preventDefault();
        $('.load-more').hide();
        $('.loading-gif').show();
        var first_id = $('.message').first().attr('data-id');
        $.ajax({
            type: "GET",
            url: $(this).attr('href'),
            data: {
                chat_msg_id: first_id
            },
            dataType: "script",
            success: function () {
                $('.loading-gif').hide();
                $('.load-more').show();
            }
        });
    });
    $('#new_message').keypress(function(e){
      if(e.which == 13){
           $(this).closest('form').submit();
       }
    });
});