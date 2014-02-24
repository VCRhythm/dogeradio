desc "This task is called by the Heroku scheduler add-on"
task :reindex_models => :environment do
	puts "Reindexing..."
	run rake searchkick:reindex:all
	puts "done."
end
task :delete_guest_playlists => :environment do
	puts "Deleting old guest playlists..."
	Playlist.guest_playlists.where("updated_at < ?", 1.week.ago).delete_all
	puts "done."
end
