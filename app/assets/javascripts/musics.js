var go = false;

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
			playlist_id = $(".music_"+music_id).data("playlist_number")+1;
			updatePlayer($("#playlist_"+playlist_id).data("music_id").split("_")[1]);
		});
	}
}

function updatePlayer(music_id){
	$.ajax({
		type:"POST",
		url: "musics/"+music_id+"/update_player/",
		success: function() {
			go = true;
			loadPlayer(music_id);
		}
	});
}

$(document).ready(function(){
	$('.sortable').sortable({
		dropOnEmpty: false,
		cursor: 'crosshair',
		items: 'li',
		helper: 'clone',
		opacity: 1,
		scroll: true,
		revert: true,
		update: function(event, ui){
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
