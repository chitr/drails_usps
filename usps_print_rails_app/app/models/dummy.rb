class Dummy < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  include HTTParty

	# get back the url of the authenticated session from mechanize and send or prepare including the cookie as header using HTTParty, in dummies_controller#login redirect to that page

	#does header go in as the hash? or as :headers => {'Cookie' => response.headers['Set-Cookie']} 
	# def return_url(cns_url, headers={}, content='')
	#def return_url(cns_url, cookie_hash)
	def return_url(cns_url)
		redirect_link = Dummy.get('cns_url')
	 	
	 	return redirect_to_this_page #.to_s
	end
end
