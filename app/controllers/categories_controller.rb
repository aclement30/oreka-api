class CategoriesController < ApiController
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.by_couple(current_user.couple).all.order(:name)
    render json: @categories
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    @category.couple = current_user.couple
    @category.save!

    render json: @category
  end

  # PUT /categories/:id
  def update
    @category.update(category_params)
    render json: @category
  end

  # DELETE /categories/:id
  def destroy
    @category.destroy
    head :no_content
  end

  private

  def category_params
    # whitelist params
    params.permit(:name)
  end

  def set_category
    @category = Category.by_couple(current_user.couple).find(params[:id])
  end
end