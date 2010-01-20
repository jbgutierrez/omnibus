require 'ppee_tests_checker'

class CheckersController < ApplicationController
  
  def new
  end
  
  def create
    tree = GrammarParser.new.parse_or_fail(params[:text]).build
    @test = Test.new(tree)
    flash.now[:notice] = "La sintaxis es correcta"    
  rescue Exception => e
    flash.now[:error] = e.message
  ensure
    render :new
  end
  
end
