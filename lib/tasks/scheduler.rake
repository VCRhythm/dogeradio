desc "This task is called by the Heroku scheduler add-on"
task :reindex_models => :environment do
	puts "Reindexing..."
	User.reindex
	Tag.reindex
	Track.reindex
	puts "done."
end
task :delete_guest_playlists => :environment do
	if Time.now.sunday?
		puts "Deleting old guest playlists..."
		Playlist.guest_playlists.where("playlists.updated_at < ?", 1.week.ago).destroy_all
		puts "done."
	end
end
