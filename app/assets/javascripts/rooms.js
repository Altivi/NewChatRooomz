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
    $('#message_content').keypress(function(e){
        if (event.keyCode == 13) {
        var content = this.value;  
        var caret = getCaret(this);          
        if(event.shiftKey){
            event.stopPropagation();
        } else {
            this.value = content.substring(0, caret - 1) + content.substring(caret, content.length);
            $(this).closest('form').submit();
        }
    }
    });
});

function getCaret(el) { 
    if (el.selectionStart) { 
        return el.selectionStart; 
    } else if (document.selection) { 
        el.focus();
        var r = document.selection.createRange(); 
        if (r == null) { 
            return 0;
        }
        var re = el.createTextRange(), rc = re.duplicate();
        re.moveToBookmark(r.getBookmark());
        rc.setEndPoint('EndToStart', re);
        return rc.text.length;
    }  
    return 0; 
}