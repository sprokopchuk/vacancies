RailsAdmin.config do |config|

  ### Popular gems integration

  config.main_app_name = ['Vacancies', 'Admin']
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
    redirect_to main_app.root_path unless current_user.role? :admin
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.model Company do

    list do
      field :user do
        pretty_value do
          bindings[:object].user.full_name
        end
        label do
          "Employer"
        end
      end
      field :name
      field :description
      field :city
      field :country do
        pretty_value do
          CS.countries[bindings[:object].country.upcase.to_sym]
        end
      end
      field :url
    end

  end


  config.model User do
    list do
      field :first_name do
        pretty_value do
          bindings[:object].full_name
        end
        label do
          "Full name"
        end
      end
      field :approved, :toggle
      field :email
      field :role
      field :company
    end
  end

  config.model Vacancy do
    list do
      field :title
      field :deadline
      field :company
      field :speciality
      field :city
      field :country do
        pretty_value do
          CS.countries[bindings[:object].country.upcase.to_sym]
        end
      end
    end
  end
  config.actions do
    toggle
    dashboard                     # mandatory
    index                         # mandatory
    export
    bulk_delete
    show do
      except ['Vacancy']
    end
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
