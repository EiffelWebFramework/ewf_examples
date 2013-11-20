
/**
 * Override jQuery.fn.init to guard against XSS attacks.
 *
 * See http://bugs.jquery.com/ticket/9521
 */

(function () {
  var jquery_init = jQuery.fn.init;
  jQuery.fn.init = function (selector, context, rootjQuery) {
    // If the string contains a "#" before a "<", treat it as invalid HTML.

    if (selector && typeof selector === 'string') {
      var hash_position = selector.indexOf('#');
      if (hash_position >= 0) {
        var bracket_position = selector.indexOf('<');
        if (bracket_position > hash_position) {
          throw 'Syntax error, unrecognized expression: ' + selector;
        }
      }
    }
    return jquery_init.call(this, selector, context, rootjQuery);
  };
  jQuery.fn.init.prototype = jquery_init.prototype;
})();

/* helper */
function s4() {
  return Math.floor((1 + Math.random()) * 0x10000)
             .toString(16)
             .substring(1);
};

function guid() {
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

/* Main app scripts */
var EWO = EWO || { };

EWO.session_id = guid();

EWO.updateTimeLabel = function (e) {
	// Should get the time from server
	console.log('update time!')	
	$.ajax({
			url: 'api/message/time/now',
			dataType: 'text',
			success: function(result) {
								$(e).text(result);
								}
							});
	setTimeout (function () { EWO.updateTimeLabel (e); }, 500);
}
EWO.keypressedOnInput = function (elt,k) {
	console.log('Keypressed on Input!')
	$.post('api/session/' + EWO.session_id + '/item/' + $(elt).attr('name'), 'value=' + $(elt).val()+k,
			function(result) {
				if (result == 'True') {
					$('input[name=operation]').each(function () { $(this).removeAttr("disabled"); });
				} else {
					$('input[name=operation]').each(function () { $(this).attr("disabled", "disabled"); });
				}
			}
		);
}

EWO.initKeypressOnInput = function (elt) {
		console.log('Keypress on Input!')
		var id = $(elt).attr('name');
		$(elt).after("<span id=\"log"+id+"\">&nbsp;</span>");
		$(elt).keypress(function (e) {
			// Should send the $(elt).text to the server, and if both num values are numeric, enable submit button else disable it
			if (e.which == 13) {
				$("#log"+id).text(" [" + e.which + "=ENTER]");
				e.preventDefault();
				//$("form").submit();
			} else {
				$("#log"+id).text(" [" + e.which + "=" + String.fromCharCode(e.which) + "]");
				
				EWO.keypressedOnInput(elt, String.fromCharCode(e.which));
			}
		});
}

EWO.refreshHover =function (text) {
  console.log('refresh hover!')
  $('#hover').val(text);
  $('#hover').text(text)
}



jQuery(document).ready(function(){
	console.log('Document ready!')
	$('h1').after("<div id=\"sessionid\">SessionID=" + EWO.session_id + "</div>");
	$('#time').each(function() {
		 EWO.updateTimeLabel($(this));	});

	$('#hover').each(function() {
		$(this).text("___");
		$(this).hover(function() {  console.log('hover!') 
									$.ajax({
									url: 'api/message/hover/test',
									dataType: 'text',
									success: EWO.refreshHover
									});
								}
							  , function() {$(this).html("&nbsp;");});
	});

	//$('input[name="first"]').each(function() {
	//$('input[name="second"]').each(function() {
	$('input.keylive').each(function() {
		EWO.initKeypressOnInput($(this));
	});

}); 

