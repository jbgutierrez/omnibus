module PPEE
  class Test
    attr_reader :test, :actors
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
    
    def scenarios
      principal_examples + extensions_examples
    end
        
    def principal_examples
      @principal.principal_examples
    end
    
    def extensions_examples
      @extensions.map(&:extension_examples).flatten
    end
  end

  class Principal
    hash_initializer :preconditions, :actions, :postconditions, :examples
    attr_accessor :preconditions, :actions, :postconditions, :examples
    
    def preconditions
      @preconditions || []
    end
    
    def examples
      @examples || []
    end
    
    def principal_examples
      return [ self ] if examples.empty?
      examples_copy = examples.dup
      placeholders = examples_copy.shift
      examples_copy.map do |example|
        template = self.dup
        placeholders.each_with_index do |place_holder, index|
          value = example[index]
          [ preconditions, actions, postconditions ].each do |list|
            list.each{ |v| v.gsub!("<#{place_holder}>", value) }
          end
        end
        template
      end
    end
  end

  class Extension
    hash_initializer :preconditions, :actions, :postconditions, :principal, :examples
    attr_accessor :preconditions, :actions, :postconditions, :principal, :examples

    def preconditions
      @preconditions || []
    end
    
    def examples
      @examples || []
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
    
    def extension_examples
      return [ self ] if examples.empty?
      examples_copy = examples.dup
      placeholders = examples_copy.shift
      examples_copy.map do |example|
        template = self.dup
        placeholders.each_with_index do |place_holder, index|
          value = example[index]
          [ template.preconditions,
            template.actions,
            template.postconditions,
            template.principal.preconditions,
            template.principal.actions,
            template.principal.postconditions ].each do |list|
            list.each { |v| v.gsub!("<#{place_holder}>", value) }
          end
          # template.preconditions.each { |p| p.gsub!("<#{place_holder}>", value) }
          # template.actions.each { |p| p.gsub!("<#{place_holder}>", value) }
          # template.postconditions.each { |p| p.gsub!("<#{place_holder}>", value) }
          # template.principal.preconditions.each { |p| p.gsub!("<#{place_holder}>", value) }
          # template.principal.actions.each { |p| p.gsub!("<#{place_holder}>", value) }
          # template.principal.postconditions.each { |p| p.gsub!("<#{place_holder}>", value) }
        end
        template
      end
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