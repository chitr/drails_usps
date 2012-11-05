
class DummiesController < ApplicationController
  # GET /dummies
  # GET /dummies.json
  def index
    @dummies = Dummy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dummies }
    end
  end

  # GET /dummies/1
  # GET /dummies/1.json
  def show
    @dummy = Dummy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dummy }
    end
  end

  # GET /dummies/new
  # GET /dummies/new.json
  def new
    @dummy = Dummy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dummy }
    end
  end

  # GET /dummies/1/edit
  def edit
    @dummy = Dummy.find(params[:id])
  end

  # POST /dummies
  # POST /dummies.json
  def create
    @dummy = Dummy.new(params[:dummy])
    @dummy.first_name = params[:first_name]
    @dummy.last_name = params[:last_name]

    respond_to do |format|
      if @dummy.save
        format.html { redirect_to @dummy, notice: 'Dummy was successfully created.' }
        format.json { render json: @dummy, status: :created, location: @dummy }
      else
        format.html { render action: "new" }
        format.json { render json: @dummy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dummies/1
  # PUT /dummies/1.json
  def update
    @dummy = Dummy.find(params[:id])

    respond_to do |format|
      if @dummy.update_attributes(params[:dummy])
        format.html { redirect_to @dummy, notice: 'Dummy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dummy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dummies/1
  # DELETE /dummies/1.json
  def destroy
    @dummy = Dummy.find(params[:id])
    @dummy.destroy

    respond_to do |format|
      format.html { redirect_to dummies_url }
      format.json { head :no_content }
    end
  end

  def login
    @dummy = Dummy.find(23)
    # CHANGE TO THIS IN PRODUCTION @dummy = Dummy.find(params[:id])
    # create mechanize agent and login 
    a = Mechanize.new
    a.get('https://reg.usps.com/entreg/LoginAction_input?app=GSS&appURL=https%3A%2F%2Fcns.usps.com%2Fgo%2FSecure%2FLabelInformationAction!input.action') 

    login_form = a.page.forms.first
    login_form['userName']  = ENV['usps_username']
    login_form['password'] = ENV['usps_password']
    login_form.submit

    # prefill the shipping form with the dummies' values
    shipping_form = a.current_page.form_with(:name => 'shipDomestic')
    shipping_form['deliveryFirstName'] = @dummy.first_name
    shipping_form['deliveryLastName'] = @dummy.last_name

    cns_url = a.current_page.uri.to_s
    # => https://cns.usps.com/go/Secure/LabelInformationAction!input.action

    temp_jar = a.cookie_jar.to_json
    
    # convert cookie into a hash for use in httparty
    cookie_array = JSON.parse(temp_jar)
    cookie_hash = Hash[*cookie_array]

    #cns_url.add_cookies(cookie_hash)

    # send click n ship url and cookie to httparty to format request in the model
    # pre_filled_page = @dummy.return_url(cns_url, cookie_hash)

    ## ERROR HTTParty::UnsupportedURIScheme: 'cns_url' Must be HTTP or HTTPS
    pre_filled_page = @dummy.return_url(cns_url)

    puts pre_filled_page

    redirect_to prefilled_page
end

    #scratch
    # @agent = Mechanize.new
    # @agent.cookie_jar = temp_jar
    # cookie = a.cookie_jar.to_a
    # latest = @agent.current_page.uri.to_s
    # page = @agent.get noncookie_url
    # puts page.to_s
    # redirect_to page