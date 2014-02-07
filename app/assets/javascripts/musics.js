var go = false;

function setNextSong(music_id){
	player = $("#jquery_jplayer_1");
	if(player.data("jPlayer").options.loop){
		$(this).unbind(".jPlayerRepeat").unbind(".jPlayerNext");
		$(this).bind($.jPlayer.event.ended + ".jPlayer.jPlayerRepeat", function(){
			$(this).jPlayer("play");
		});
	} else {
		$(this).unbind(".jPlayerRepeat").unbind(".jPlayerNext");
		$(this).bind($.jPlayer.event.ended + ".jPlayer.jPlayerNext", function(){
			$.ajax({
				type: "post",
				url: "musics/"+music_id+"/plays/"
			});
			playlist_id = $(".music_"+music_id).data("playlist_number")+1;
			updatePlayer(playlist_id);
		});
	}
}

function loadPlayer(music_id){
	$('#jquery_jplayer_1').jPlayer({
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
			music_url=$("#player-heading").data("music_url");
			$(this).jPlayer("setMedia", {mp3: music_url} );
			if (go) $(this).jPlayer("play"); 
			go = false;
		},
		repeat: function(event){
			setNextSong(music_id);
		}
	});
}	

function updatePlayer(position){
	previous_position = $("#player-heading").data('position');
	music_id = $("#playlist_"+position).data("music_id").split("_")[1];
	$('#playlist_' + previous_position).removeClass('active');
	$('#playlist_' + position).addClass('active');
	$.ajax({
		type:"POST",
		data: {position: position},
		url: "musics/"+music_id+"/update_player/",
		success: function() {
			go = true;
			loadPlayer(music_id);
		}
	});
}

$(document).ready(function(){

	$(document).on('click', '.remote-link', function(){
		$('body').animate({scrollTop: $("#main").offset().top-90}, 500);
	}).on('click', '.jp-next', function(){
		position = $("#player-heading").data('position');
		next_position = position + 1;
		updatePlayer(next_position);
	}).on('click', '.tag', function(){
		$.ajax({
			type: 'post',
			url: '/tags/'+$(this).data('id')+'/search',
		});
	}).on('click', '#update_balance_link', function(){
		$('#update_balance').html("<p class='alert alert-info'>Updating balance...</p>");
	}).on('click', '#add-tag', function(){
		music_id = $('#player-heading').data('music_id');
		$.ajax({
			type: 'get',
			url: 'musics/'+music_id+'/tags/new'
		});
	});

	$('.sortable').sortable({
		dropOnEmpty: false,
		cursor: 'crosshair',
		items: 'li',
		helper: 'clone',
		opacity: 1,
		scroll: true,
		revert: true,
		start: function(e, ui){
			ui.placeholder.height("20px");
		},
		update: function(event, ui){
			$(".delete-link").addClass("stop-delete");
			$(".list-group").removeClass("sortable");
			var playlist_id = $(this).data('playlist_id');
			var music_id = $('#player-heading').data('music_id');
			$.ajax({
				data: $(this).sortable('serialize'),
				type: 'post',
				url: '/playlists/'+playlist_id+'/sort',
				dataType: 'script',
				complete: function(request){
					setNextSong(music_id);	
					$(".list-group").addClass("sortable");
				}
			});
		}
	});
});
