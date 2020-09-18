class IssuesController < ApplicationController

  private
    def issues_parameters
      params.require(:issue).permit(documents: [])
    end
end
