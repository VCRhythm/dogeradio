$(document).ready(function(){

var tracks = new Bloodhound({
	datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
	queryTokenizer: Bloodhound.tokenizers.whitespace,
	limit: 10,
	remote: '/search_tracks?search[query]=%QUERY'
});

tracks.initialize();

$('#search_query').typeahead({
	highlight: true
},
{
	name: 'tracks',
	displayKey: 'name',
	source: tracks.ttAdapter(),
	templates: {
		header: '<h4 class="search-results-header">Tracks</h4>'
	}
}).on('typeahead:selected', function(obj, datum, name){
	$(this).submit();
});
});