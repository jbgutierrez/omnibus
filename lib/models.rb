class Test
  attr_reader :test, :actors, :principal, :extensions
  def initialize(params)
    @test       = params[:test]
    @actors     = params[:actors]
    @principal  = Principal.new(params[:principal])
    @extensions = (params[:extensions] || []).map do |extension_params|
      e = Extension.new(extension_params)
      e.principal = @principal
      e
    end
  end
end

class Principal
  hash_initializer :preconditions, :actions, :postconditions
  attr_reader :preconditions, :actions, :postconditions
  def preconditions
    @preconditions || []
  end
end

class Extension
  hash_initializer :preconditions, :actions, :postconditions, :options, :principal
  attr_reader :preconditions, :actions, :postconditions, :options, :principal
  attr_writer :principal

  def options
    @options || []
  end

  def preconditions
    @preconditions || []
  end
  
  def all_preconditions
    principal.preconditions + preconditions
  end
  
  def all_actions
    result = []

    inherited = principal.actions.dup
    first_action = actions.first.chomp('...')
    match = inherited.find{ |a| a.start_with?(first_action)}
    if match
      actions.shift
      fork_index = inherited.index(match) 
      result += inherited.slice!(0, fork_index + 1)
      result += actions
      result += inherited if options.include?(:join)
    else
      result = actions
    end
    result
  end
  
  def all_postconditions
    options.include?(:keep_postconditions) ? (principal.postconditions + postconditions) : postconditions 
  end
end