require_relative './Notifier'

class SeleniumRunner

	def initialize(test_files, site)

		@test_files = test_files

		@sitename = site

	end

	def run
		# 
		# Run in a thread so sinatra can return an HTTP response quickly.
		#
		Thread.new { 

			errors = ''

			@test_files.each do |t|

			# 
			# Run the selenium test and give us a variable
			# containing its output.
			# 
			message = `ruby #{t}`

			if message.include? "Error:"
				errors << message
				errors << '<br/>'
			end

			end

			if (!errors.empty?)
				title = "Selenium Test failure report for #{@sitename}"
				message = errors
			else
				title = "Selenium Test success for #{@sitename}"
				message = 'Carry on!'
			end

			Notifier.new(LOG_EMAIL_SENDER, LOG_EMAIL_RECIPIENT, title, message)

		}

	end

end