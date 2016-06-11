module MessagesHelper
	def self_or_other(message)
		message.author == current_user ? "self" : "other"
	end

	def avatar_present?(message)
		message.author.fast_avatar_url.present?
	end

	def avatar_or_nickname(message)
		if avatar_present?(message)
			10.times {puts "ACATAR PRESENT"}
			content_tag :div, class: "avatar" do
				image_tag message.author.fast_avatar_url
			end
		else
			content_tag :div, message.author.nickname, class: "without_avatar"
		end
	end
end
