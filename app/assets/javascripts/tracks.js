var go = false;
var jPlayer;

function setNextSong(track_id){
	if(jPlayer.data("jPlayer").options.loop){
		$(this).unbind(".jPlayerRepeat").unbind(".jPlayerNext");
		$(this).bind($.jPlayer.event.ended + ".jPlayer.jPlayerRepeat", function(){
			$(this).jPlayer("play");
		});
	} else {
		$(this).unbind(".jPlayerRepeat").unbind(".jPlayerNext");
		$(this).bind($.jPlayer.event.ended + ".jPlayer.jPlayerNext", function(){
			$.ajax({
				type: "post",
				url: "/tracks/"+track_id+"/plays"
			});
			$.ajax({
				type: "post",
				data: {track_id: track_id, category:"auto"},
				url: "/"+$("#player-heading").attr("data-username")+"/autopay"
			});
			playlist_id = parseInt($(".track_"+track_id).attr("data-playlist_number"))+1;
			updatePlayer(playlist_id);
		});
	}
}

function loadPlayer(track_id){
	jPlayer.jPlayer({
		preload: "none",
		supplied: "mp3",
		swfPath: "http://www.jplayer.org/latest/js/Jplayer.swf",
		keyEnabled: true,
		play: function(){
			$(this).jPlayer("pauseOthers");
		},
		cssSelectorAncestor: "",
		cssSelector: {
			play:".jp-play",
			pause:".jp-pause",
			seekBar:".jp-seek-bar",
			playBar:".jp-play-bar"
		},
		ready: function () {
			track_url=$("#player-heading").attr("data-track_url");
			$(this).jPlayer("setMedia", {mp3: track_url} );
			if (go) $(this).jPlayer("play"); 
			go = false;
		},
		repeat: function(event){
			setNextSong(track_id);
		}
	});
}	

function updatePlayer(position){
	previous_position = $("#player-heading").attr('data-position');
	$('#playlist_' + previous_position).removeClass('active');
	if($("#playlist_"+position).length){
		track_id = $("#playlist_"+position).attr("data-track_id");
		$('#playlist_' + position).addClass('active');
		$.ajax({
			type:"POST",
			data: {position: position},
			url: "/tracks/"+track_id+"/update_player/",
			success: function() {
				go = true;
				loadPlayer(track_id);
			}
		});
	}
}

$(document).ready(function(){
	jPlayer = $("#jquery_jplayer_1");
	loadPlayer($("#player-heading").attr("data-track_id"));

	$(document).on('click', '.remote-link', function(){
		$('.navbar-collapse').removeClass('in');
		$('body').animate({scrollTop: $("#main").offset().top-70}, 500);
	}).on('click', '.jp-next', function(){
		position = $("#player-heading").attr('data-position');
		next_position = parseInt(position) + 1;
		updatePlayer(next_position);
	}).on('click', '.tag', function(){
		query = $(this).attr("data-description");
		$.ajax({
			type: 'post',
			data: {search:{query: query, type: 'tag'}},
			url: '/search/'
		});
	}).on('click', '#update_balance_link', function(){
		$('#update_balance').html("<p class='alert alert-info'>Updating balance...</p>");
	}).on('click', '#add-tag', function(){
		track_id = $('#player-heading').attr('data-track_id');
		$.ajax({
			type: 'get',
			url: '/tracks/'+track_id+'/tags/new'
		});
	}).on('click', '.clickable', function(){
		position = $(this).parent().attr('data-playlist_number');
		updatePlayer(position);
		$('body').animate({scrollTop: $("#player").offset().top-110}, 500);
	}).on('click', '.list-group-item', function(){
		$('.list-group-item').removeClass('active');
		$(this).addClass('active');
	}).on('click', '.yelp-response', function(){
		$('#venue_name').val($(this).attr("data-name"));
		$('#venue_street').val($(this).attr("data-street"));
		$('#venue_city').val($(this).attr("data-city"));
		$('#venue_state').val($(this).attr("data-state"));
		$('#venue_zipcode').val($(this).attr("data-zipcode"));
		$('#venue_country').val($(this).attr("data-country"));
		$('#yelp_image').val($(this).attr('data-image-url'));
	}).on('click', '.jambase-event', function(){
		$('#event_name').val($(this).attr('data-artists'));
		$('#event_moment').val($(this).attr('data-moment'));
	}).on('click', '#tabs a', function(e){
		e.preventDefault();
		$(this).tab('show');
	}).on('click', '.nav-link', function(){
		$('.nav-link').removeClass('active');
		$(this).addClass('active');
	}).on('click', '#load-yelp-suggestions', function(){
		$.ajax({
			type: 'get',
			url: '/load_yelp_suggestions/'
		});
	});

	$('.sortable').sortable({
		dropOnEmpty: false,
		items: 'li',
		handle: '.media-object',
		placeholder: 'li',
		opacity: .7,
		cursor: 'move',
		scroll: true,
		revert: false,
				update: function(event, ui){
			$(".list-group").removeClass("sortable");
			var playlist_id = $(this).attr('data-playlist_id');
			var track_id = $('#player-heading').attr('data-track_id');
			$.ajax({
				data: $(this).sortable('serialize'),
				type: 'post',
				url: '/playlists/'+playlist_id+'/sort',
				dataType: 'script',
				complete: function(request){
					setNextSong(track_id);	
					$(".list-group").addClass("sortable");
				}
			});
		}
	});
});