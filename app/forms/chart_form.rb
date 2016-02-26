class ChartForm

  include ActiveModel::Model
  include Virtus.model

  attribute :params, Hash
  attribute :vacancies, ActiveRecord::Relation, :default => :default_vacancies
  attribute :company, Company, :default => :default_company
  attribute :from, Date, :default => :default_from_date
  attribute :to, Date, :default => :default_to_date

  def graph_data
    @vacancies.where(:company_id => @company.id)
        .group_by_day(:created_at, range: @from..@to).count
  end

  private

  def default_from_date
    @from = Date.parse(@params["from"]) if @params["from"]
    to = Date.parse(@params["to"]) if @params["to"]
    if @from.nil? ||
       @from < Date.current.beginning_of_year ||
       @from == Date.current ||
       @from >= to

       @from = Date.current.beginning_of_year
    end
    @from
  end

  def default_to_date
    from = Date.parse(@params["from"]) if @params["from"]
    @to = Date.parse(@params["to"]) if @params["to"]
    if @to.nil? ||
       @to <= Date.current.beginning_of_year ||
       @to >= from

       @to = Date.current.end_of_year
     end
     @to
  end
  def default_company
    Company.find(@params["company"]) if @params["company"]
  end

  def default_vacancies
    Vacancy.unscoped
  end

end

