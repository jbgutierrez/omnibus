module PPEE
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
    hash_initializer :preconditions, :actions, :postconditions, :principal
    attr_reader :preconditions, :actions, :postconditions, :principal
    attr_writer :principal

    def preconditions
      @preconditions || []
    end
  
    def all_preconditions
      inherited_preconditions + preconditions
    end
    
    def inherited_preconditions
      principal.preconditions
    end
  
    def all_actions
      first_inherited_actions + specific_actions + last_inherited_actions
    end
  
    def first_inherited_actions
      inherited.slice(0, fork_index)
    end
    
    def specific_actions
      result = actions.dup
      result.shift
      result.pop if has_continue_clause?
      result
    end
    
    def last_inherited_actions
      inherited_copy = inherited
      join_index.times {|i| inherited_copy.shift }
      inherited_copy
    rescue
      []
    end
  
    def all_postconditions
      inherited_postconditions + postconditions 
    end
    
    def inherited_postconditions
      keep?(postconditions) ? (principal.postconditions + postconditions) : []
    end
    
    private

    def keep?(values)
      !values.empty? & values.first =~ /$[t|T]ambi[e|É]n/
    end
        
    def first_action
      original_first_action.sub(/^no /, '')
    end

    def last_action
      original_last_action.sub(/^[Cc]ontin[úu]o( [Ee]n)? */, '')
    end

    def original_first_action
      actions.first.strip!
      actions.first.chomp!('...')
      actions.first      
    end    

    def original_last_action
      actions.last.strip!
      actions.last.chomp!('...')
      actions.last      
    end    

    def search_index(collection, prefix)
      match = collection.find{ |a| a.start_with?(prefix)}
      collection.index(match) 
    end
    
    def fork_index
      index = search_index(inherited, first_action)
      index += 1 unless fork_overriden?
      index
    end
    
    def join_index
      index = nil
      if has_continue_clause?
        index = last_action.blank? ? fork_index : search_index(inherited, last_action)
      end
      index
    end
    
    def inherited
      principal.actions.dup
    end
    
    def fork_overriden?
      original_first_action.start_with?('no ')
    end
    
    def has_continue_clause?
      original_last_action =~ /^[Cc]ontin[úu]o( [Ee]n)? */
    end

  end
end