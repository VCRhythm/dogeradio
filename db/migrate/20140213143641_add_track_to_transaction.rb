class AddTrackToTransaction < ActiveRecord::Migration
  def change
    add_reference :transactions, :track, index: true
  end
end
