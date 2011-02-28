class UserFilesController < ApplicationController

rescue_from ActionController::MissingFile, :with => :show_error
rescue_from OpenURI::HTTPError, :with => :show_error
rescue_from AWS::S3::NoSuchKey, :with => :show_error





  load_and_authorize_resource
  before_filter :check_banned_user

  def show_error
    flash[:error] = "Sorry, Unable to fetch the file"
    redirect_to "/"
  end


  def new
    #@user_file = UserFile.new

  end

  def create
    @user_file = UserFile.create( params[:user_file] )
    @user_file.user = current_user
    respond_to do |format|
      if @user_file.save
        #format.html { redirect_to(@user_file, :notice => 'File uploaded was successfully.') }
        #format.xml  { render :xml => @user_file, :status => :created, :location => @attachment }
         flash[:notice] = 'File uploaded successfully'
         format.js
      else
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @user_file.errors, :status => :unprocessable_entity }
        @user_file = nil
        flash[:notice] = 'Pls specify the file to upload'
        format.js
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
      if @user_file.update_attributes(params[:user_file])
        #format.html { redirect_to(@user_file, :notice => 'File was successfully updated.') }
        #format.xml  { head :ok }
        flash[:notice] = 'File updated successfully'
        format.js
      else
        #format.html { render :action => "edit" }
        #format.xml  { render :xml => @user_file.errors, :status => :unprocessable_entity }
        flash[:notice] = 'File updation failed.'
        format.js
      end
    end
  end


def download
    @user_file = UserFile.find(params[:id])


  if @user_file.attachment.url[0..22] != "http://s3.amazonaws.com"
    send_file Rails.root.to_s + '/public'.to_s + @user_file.attachment.url.to_s rescue  send_file @user_file.attachment.url.to_s
  else
    data = open(@user_file.attachment.url)
    send_data data.read, :type => data.content_type, :disposition => 'attachment', :filename => @user_file.attachment_file_name
  end


end

def publish_file
  @user_file = UserFile.find(params[:file_id])
  @user_file.update_attribute(:published,true)
  redirect_to user_file_path(@user_file.id)
end

def new_version
  @old_user_file = UserFile.find(params[:id])
  @user_file = UserFile.new(@old_user_file.attributes.merge(:user_id => current_user.id,:published => false, :parent_id=>@old_user_file.id, :ancestors => @old_user_file.ancestors ? "#{@old_user_file.ancestors},#{@old_user_file.id.to_s}" : "#{@old_user_file.id.to_s}", :version_number => @old_user_file.version_number ? "#{@old_user_file.version_number}.1" : "1", :attachment_file_name => "#{@old_user_file.attachment_file_name}.1"))
    @user_file.attachment = @old_user_file.attachment


    if @user_file.save
      flash[:notice] = 'Successfully created new version.'
      redirect_to edit_user_file_path(@user_file)
    end


end


end

