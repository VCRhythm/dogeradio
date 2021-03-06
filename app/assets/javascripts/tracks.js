var go = false;
var jPlayer;

function refreshPlayer(){
	loadPlayer($("#player-heading").attr("data-track_id"));
}

function refreshTicker(){
	$("#scrollingText").smoothDivScroll({
		autoScrollingMode: "always",
		autoScrollingDirection: "endlessLoopRight",
		autoScrollingStep: 1,
		autoScrollingInterval: 100,
	});
}

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
		cssSelectorAncestor:"",
		cssSelector: {
			play:".jp-play",
			pause:".jp-pause",
			seekBar:".jp-seek-bar",
			playBar:".jp-play-bar"
		},
		ready: function () {
			track_url=$("#player-heading").attr("data-track_url");
			$(this).jPlayer("setMedia", {
				mp3: track_url,
				ogg: track_url
			});
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
	refreshPlayer();
	refreshTicker();
	$.get("/events_sidebar");
	$(".alert").delay(3000).slideUp();

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
			url: '/tracks/'+track_id+'/tags/new',
			dataType: 'script'
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
	}).on('click', '#minimize-sidebar', function(){
		$('#sidebar').slideUp(function(){
			$(this).remove();
			$('#main-container').removeClass("row-offcanvas row-offcanvas-left");
			$('#main').removeClass("col-sm-8").addClass("col-sm-12");
		});
		$.ajax({
			type: 'get',
			url: '/topbar'
		});
	}).on('click', '#maximize-sidebar', function(){
		$('#topbar').slideUp(function(){
			$(this).remove();
			$('#main-container').addClass("row-offcanvas row-offcanvas-left");
			$('#main').removeClass("col-sm-12").addClass("col-sm-8");
		});
		$.ajax({
			type: 'get',
			url: '/sidebar'
		});
	}).on('click', "#update_balance_link", function(){
		$("#update_balance").html("<p class='alert alert-info'>Account balance updating...</p>");
	}).on('click', '#add-yelp-venues', function(){
		$(".yelp-response-check").each(function(){
			if(this.checked){
				$.ajax({
					type: 'post',
					data: {
						venue:{
							name: this.getAttribute("data-name"),
							street: this.getAttribute("data-street"),
							city: this.getAttribute("data-city"),
							state: this.getAttribute("data-state"),
							zipcode: this.getAttribute("data-zipcode"),
							country: this.getAttribute("data-country")
						},
						yelp_image: this.getAttribute('data-image-url')
					},
					url: "/venues"
				});
			}
		});
	}).on('click', '#tip-button', function(){
		$('#tip-button').slideUp();
		$('.tip-alert').html("Processing...").addClass("alert-success").slideDown();
	}).on({
		mouseenter: function() {
			$("#venue_" +$(this).attr("data-event-id")).html($(this).attr("data-venue-name")).addClass("description");
		},
		mouseleave: function() {
			$("#venue_" +$(this).attr("data-event-id")).html("@").removeClass("description");
		}
	}, ".venue-link");


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