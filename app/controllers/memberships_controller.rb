class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update destroy]


  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user_id = current_user.id
    @beer_club = BeerClub.find(membership_params[:beer_club_id])

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @beer_club, notice: "Wllcome to the club #{current_user.username}!" }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to membership_url(@membership), notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @beer_club = BeerClub.find(membership_params[:beer_club_id])
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: "Succesfully resigned from #{@beer_club.name}." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:user_id, :beer_club_id)
  end
end
