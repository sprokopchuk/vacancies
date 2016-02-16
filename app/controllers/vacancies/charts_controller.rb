class Vacancies::ChartsController < ApplicationController

  authorize_resource :class => false

  def create
    @chart_form = ChartForm.new(params: params["chart_form"])
    @chart_data = @chart_form.graph_data
    respond_to do |format|
      format.js {render layout: false}
    end
  end

  def show
    @chart_form = ChartForm.new
  end

end
