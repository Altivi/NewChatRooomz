class UserMailer < ApplicationMailer
	
	default to: Proc.new { User.pluck(:email) },
          from: 'donut.video.mailer@gmail.com'
	 
	def last_rooms_snapshot
      	Dir.chdir(Rails.root.join('tmp', 'images', 'rooms_snapshots'))
		attachments.inline['snapshot.png'] = File.read(Rails.root.join('tmp', 'images', 'rooms_snapshots',Dir["**/*"].max))
		mail(subject: "The latest rooms !")
	end

end
