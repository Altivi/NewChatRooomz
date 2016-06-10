module ApplicationHelper

	def nav_link(link_text, link_path) #bootstrap nav_link highlighting
	  class_name = current_page?(link_path) ? 'active' : ''

	  content_tag(:li, :class => class_name) do
	    link_to link_text, link_path
	  end
	end

	def user_id
		user_signed_in? ? current_user.id : ""
	end

end
