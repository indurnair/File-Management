class UserFilesController < ApplicationController
  load_and_authorize_resource
  def new
    @user_file = UserFile.new
  end

  def create
    @user_file = UserFile.create( params[:user_file] )
    respond_to do |format|
      if @user_file.save
        format.html { redirect_to(@user_file, :notice => 'File uploaded was successfully.') }
        format.xml  { render :xml => @user_file, :status => :created, :location => @attachment }
      else
        format.html { render :action => "@user_file" }
        format.xml  { render :xml => @user_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  def current_user_files
    @user_files = UserFile.find(:all,:conditions=>['user_id = ?',current_user.id])
  end

  def published_files
    @user_files = UserFile.find(:all,:conditions=>['published = ?',true])
  end

  def index
   @user_files = UserFile.all
  end

  def show
  @user_file = UserFile.find(params[:id])
  end

  def edit
     @user_file = UserFile.find(params[:id])
  end

  def update
    @user_file = UserFile.find(params[:id])

    respond_to do |format|
      if @user_file.update_attributes(params[:user_fil])
        format.html { redirect_to(@user_file, :notice => 'File was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_file.errors, :status => :unprocessable_entity }
      end
    end
  end
end

