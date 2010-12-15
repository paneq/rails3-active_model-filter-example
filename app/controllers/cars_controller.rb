class CarsController < ApplicationController

  def search
    @search = Search.new(params[:search])
    if @search.valid?
      @cars = @search.results.order("valid_from ASC")
    else
      @cars = Car.all
    end
    render :index
  end

  # GET /cars
  # GET /cars.xml
  def index
    @search = Search.new
    @cars = Car.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cars }
    end
  end

  # GET /cars/1
  # GET /cars/1.xml
  def show
    @car = Car.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /cars/new
  # GET /cars/new.xml
  def new
    @car = Car.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /cars/1/edit
  def edit
    @car = Car.find(params[:id])
  end

  # POST /cars
  # POST /cars.xml
  def create
    @car = Car.new(params[:car])
    redirect_to(cars_url, :notice => 'Creating cars is disabled on heroku.')
  end

  # PUT /cars/1
  # PUT /cars/1.xml
  def update
    @car = Car.find(params[:id])
    redirect_to(@car, :notice => 'Updating car is disabled on heroku.')
  end

  # DELETE /cars/1
  # DELETE /cars/1.xml
  def destroy
    @car = Car.find(params[:id])
    redirect_to(cars_url, :notice => 'Destroying car is disabled on heroku.')
  end
end
