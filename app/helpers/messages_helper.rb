module MessagesHelper
	def self_or_other(message)
		message.author == current_user ? "self" : "other"
	end
end
