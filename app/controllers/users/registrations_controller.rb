class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :get_countries

  def create
     if verify_recaptcha
       super
     else
       build_resource
       clean_up_passwords(resource)
       flash.now[:error] = "There was an error with the recaptcha code below. Please re-enter the code and click submit [error code: " + flash[:recaptcha_error] + "]"
       flash.delete(:recaptcha_error)
       render_with_scope :new
     end
	end

	def update
	  # no mass assignment for country_id, we do it manually
	  # check for existence of the country in case a malicious user manipulates the params (fails silently)
		if params[resource_name][:country_id]          
	    resource.country_id = params[resource_name][:country_id] if Country.find_by_id(params[resource_name][:country_id])
			resource.save!
	  end
	  super
	end
	
	private
	
	  def get_countries
	    @all_countries = Country.all
	    @countries = []
	    @all_countries.each do |c|
	      @countries.push([c.name, c.id])
	    end  
	  end
	
end