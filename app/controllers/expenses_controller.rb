class ExpensesController < ApiController
  before_action :set_transaction, only: [:show, :update, :destroy]
  before_action :set_removed_transaction, only: [:restore]

  def index
    @transactions = Expense
                        .by_couple(current_user.couple)
                        .page(pagination_params[:page])
                        .per_page(pagination_params[:limit] || 50)
                        .order(date: :desc)
    render json: @transactions
  end

  # POST /expenses
  def create
    @transaction = Expense.new(transaction_params)
    @transaction.couple = current_user.couple
    @transaction.save!

    render json: @transaction
  end

  # GET /expenses/:id
  def show
    render json: @transaction
  end

  # PUT /expenses/:id
  def update
    @transaction.update(transaction_params)
    render json: @transaction
  end

  # PATCH /expenses/:id/restore
  def restore
    @transaction.restore
    render json: @transaction
  end

  # DELETE /expenses/:id
  def destroy
    @transaction.destroy
    head :no_content
  end

  private

  def transaction_params
    # whitelist params
    params.permit(:description, :date, :amount, :currency, :payer_share, :payer_id, :category_id, :notes)
  end

  def pagination_params
    # whitelist params
    params.permit(:page, :limit)
  end

  def set_transaction
    @transaction = Expense.by_couple(current_user.couple).find(params[:id])
  end

  def set_removed_transaction
    @transaction = Expense.by_couple(current_user.couple).with_deleted.find(params[:id])
  end
end