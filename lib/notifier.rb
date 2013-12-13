class Notifier

	require 'mandrill'
	require 'net/http'

	def initialize(sender, recipient, title, body)

	    m = Mandrill::API.new MANDRILL_APIKEY
		message = {  
		 :subject=> title,  
		 :from_name=> "Selenium Tester",  
		 # :text=>"Hi message, how are you?",  
		 :to=>[  
		   {  
		     :email=> recipient,  
		     :name=> 'Fireman'  
		   }  
		 ],  
		 :html=>body,  
		 :from_email=>sender  
		}  
		sending = m.messages.send message  
		puts sending

	end

end