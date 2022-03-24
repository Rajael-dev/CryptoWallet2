class WelcomeController < ApplicationController
  def index
    @meu_curso = params[:curso]
  end
end
