$ ->
	$('#search_form').typeahead
		name: 'tracks' 
		remote: "/autocomplete?search[query]=%QUERY" 
