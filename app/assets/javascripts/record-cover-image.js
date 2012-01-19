// $(function() {
//   // Handler for .ready() called.
// 	$('.cover-image').each(function () {
// 		var coverImage = $(this),
// 			isShort = $('#records').hasClass('short');
// 
// 		if (!isShort) {
// 			var recordIds = $(this).attr('record_id'),
// 			    type = $(this).attr('type'),
// 			    title = $(this).attr('title');
// 			$.ajax({
//         dataType: 'html',
// 				url: 'cover/?id=' + recordIds + '&type=' + type + '&title=' + title,
// 				success: function (data, status) {
// 					coverImage.html(data);
// 				},
// 				error: function (request, status, thrown) {
// 					// error
// 				}
// 			});
// 		}
// 	});
// });
