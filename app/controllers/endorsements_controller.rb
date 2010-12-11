class EndorsementsController < ApplicationController
  # GET /endorsements
  # GET /endorsements.xml
  def index
    @endorsements = Endorsement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @endorsements }
    end
  end

  # GET /endorsements/1
  # GET /endorsements/1.xml
  def show
    @endorsement = Endorsement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @endorsement }
    end
  end

  # GET /endorsements/new
  # GET /endorsements/new.xml
  def new
    @endorsement = Endorsement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @endorsement }
    end
  end

  # GET /endorsements/1/edit
  def edit
    @endorsement = Endorsement.find(params[:id])
  end

  # POST /endorsements
  # POST /endorsements.xml
  def create
    @endorsement = Endorsement.new(params[:endorsement])
    @endorsement.endorser = current_user

    respond_to do |format|
      if @endorsement.save
        flash[:notice] = 'Endorsement was successfully created.'
        format.html { redirect_to(@endorsement.endorsee) }
        format.xml  { render :xml => @endorsement, :status => :created, :location => @endorsement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @endorsement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /endorsements/1
  # PUT /endorsements/1.xml
  def update
    @endorsement = Endorsement.find(params[:id])

    respond_to do |format|
      if @endorsement.update_attributes(params[:endorsement])
        flash[:notice] = 'Endorsement was successfully updated.'
        format.html { redirect_to(@endorsement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @endorsement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /endorsements/1
  # DELETE /endorsements/1.xml
  def destroy
    @endorsement = Endorsement.find(params[:id])
    @endorsement.destroy
		
		flash[:notice] = 'Endorsement was successfully removed.'

    respond_to do |format|
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end

  # PUT /endorsements/1/accept
  # PUT /endorsements/1/accept.xml
  def accept
    @endorsement = Endorsement.find(params[:id])
    @endorsement.accept

    respond_to do |format|
      if @endorsement.save
        flash[:notice] = 'Endorsement was successfully accepted.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @endorsement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /endorsements/1/refuse
  # PUT /endorsements/1/refuse.xml
  def refuse
    @endorsement = Endorsement.find(params[:id])
    @endorsement.refuse

    respond_to do |format|
      if @endorsement.save
        flash[:notice] = 'Endorsement was successfully refused.'
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @endorsement.errors, :status => :unprocessable_entity }
      end
    end
  end


end
