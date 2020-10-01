class ApplicationMailer < ActionMailer::Base
  default from: 'hammadikhlaq96@gmail.com'
  layout 'mailer'
  before_action :initialize_validation
  before_action :load_company

  protected

  def initialize_validation
    @valid = true
  end

  def load_company
    @company = load_resource { Company.find_by(id: params[:company]) }
  end

  def load_resource
    if @valid
      resource = yield
      @valid = resource.present?
    end

    resource
  end

  def validate_action
    yield if @valid
  end
end
