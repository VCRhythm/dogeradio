$(document).ready(function(){

var search = new Bloodhound({
	datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
	queryTokenizer: Bloodhound.tokenizers.whitespace,
	limit: 10,
	remote: '/search_tracks?search[query]=%QUERY'
});

search.initialize();

$('#search_query').typeahead(null, {
	displayKey: 'name',
	source: search.ttAdapter()
}).on('typeahead:selected', function(obj, datum, name){
	$(this).submit();
});
});