require 'test/unit'
require 'rubygems'
require 'active_support'
require 'treetop'
require 'treetop_ext'
require 'polyglot'
require 'generic'
require 'grammar'

class CheckersController < ApplicationController
  
  def new
  end
  
  def create
    GrammarParser.new.parse_or_fail(params[:text])
    flash.now[:notice] = "La sintaxis es correcta"
  rescue Exception => e
    flash.now[:error] = e.message
  ensure
    render :new
  end
  
end
