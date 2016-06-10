module MessagesHelper
	def self_or_other(message)
		message.author == current_user ? "self" : "other"
	end

	def avatar_exists?(message)
		message.author.fast_avatar_url.exists?
	end
end
