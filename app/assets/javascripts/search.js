$(document).ready(function(){

	var tracks = new Bloodhound({
		datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
		queryTokenizer: Bloodhound.tokenizers.whitespace,
		limit: 10,
		remote: '/search_tracks?search[query]=%QUERY'
	});

	var tags = new Bloodhound({
		datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.description); },
		queryTokenizer: Bloodhound.tokenizers.whitespace,
		limit: 10,
		remote: '/search_tags?search[query]=%QUERY'
	});

	var users = new Bloodhound({
		datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.display_name); },
		queryTokenizer: Bloodhound.tokenizers.whitespace,
		limit: 10,
		remote: '/search_users?search[query]=%QUERY'
	});

	tracks.initialize();
	tags.initialize();
	users.initialize();

	$('#search_query').typeahead({
		highlight: true
	},
	{
		name: 'tracks',
		displayKey: 'name',
		source: tracks.ttAdapter(),
		templates: {
			header: '<h5 class="search-results-header">Tracks</h5>'
		}
	},
	{
		name: 'tags',
		displayKey: 'description',
		source: tags.ttAdapter(),
		templates: {
			header: '<h5 class="search-results-header">Tags</h5>'
		}
	},
	{
		name: 'users',
		displayKey: 'display_name',
		source: users.ttAdapter(),
		templates: {
			header: '<h5 class="search-results-header">Users</h5>'
		}
	}).on('typeahead:selected', function(obj, datum, name){
		$(this).submit();
	});
});