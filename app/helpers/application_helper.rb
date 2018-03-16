module ApplicationHelper
	def pagetitle(pagename = '')
		branding = "Govind's User Management System"
		if pagename.empty?
			branding
		else
			pagename + " | " + branding
		end
	end
end
