class AddAttachmentToMusics < ActiveRecord::Migration
	def self.up
		add_attachment :musics, :attachment
	end

	def self.down
		remote_attachment :musics, :attachment
	end
end
