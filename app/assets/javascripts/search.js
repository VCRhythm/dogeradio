$(function() {
	$('#search_form').typeahead({
		name: 'tracks',
		remote: "/autocomplete?search[query]=%QUERY"
	}).on('typeahead:selected', function(obj, datum, name){
		$(this).submit();
	});
});
