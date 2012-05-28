class AddInvitationCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitation_code, :string, after: :role

    # Set the invitation code for all the users that already exists on the system
    # We need to do this here so we can add a unique index later
    User.all.each do |user|
      if user.respond_to?(:set_invitation_code)
        user.set_invitation_code
        user.save(validate: false)
      end
    end

    add_index :users, :invitation_code, unique: true
  end
end
