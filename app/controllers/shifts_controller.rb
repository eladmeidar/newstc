class ShiftsController < ApplicationController
  def index
    @shifts = Shift.all
  end
  
  def show
    @shift = Shift.find(params[:id])
  end
  
  def new
    @shift = Shift.new
  end
  
  def create
    @shift = Shift.new(params[:shift])
    if @shift.save
      #combine with any compatible shifts
      @shift = Shift.combine_with_surrounding_shifts(@shift)
      flash[:notice] = "Successfully created shift."
      redirect_to @shift
    else
      render :action => 'new'
    end
  end
  
  def edit
    @shift = Shift.find(params[:id])
  end
  
  def update
    @shift = Shift.find(params[:id])
    if @shift.update_attributes(params[:shift])
      #combine with any compatible shifts
      @shift = Shift.combine_with_surrounding_shifts(@shift)
      flash[:notice] = "Successfully updated shift."
      redirect_to @shift
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy
    flash[:notice] = "Successfully destroyed shift."
    redirect_to shifts_url
  end
end