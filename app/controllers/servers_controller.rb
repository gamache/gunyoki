class ServersController < ApplicationController
  respond_to :html, :json

  def index
    respond_with(@servers = Server.all)
  end

  def show
    @server = Server.find(params[:id])
    head :not_found unless @server
    respond_with(@server)
  end

  def create
    @server = Server.new(params)
    head :unprocessable_entity unless @server.save
    respond_with(@server)
  end

  def update
    @server = Server.find(params[:id])
    if !@server
      head :not_found
    elsif !@server.update_attributes(params)
      head :unprocessable_entity
    end
    respond_with(@server)
  end
end
