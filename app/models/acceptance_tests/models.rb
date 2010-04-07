# coding: utf-8
module PPEE
  
  def self.search_index(collection, prefix)
    match = collection.find{ |a| a.lstrip.start_with?(prefix)}
    collection.index(match) 
  end

  def self.build_list(list, keys, values)
    list.map do |original|
      build_item(original, keys, values)
    end.compact
  end

  def self.build_item(original, keys, values)
    item = original.dup
    if item =~ /<[^>]+>/
      placeholders = item.scan(/<[^>]+>/)
      placeholders.each do |placeholder|
        placeholder.delete! '<'
        placeholder.delete! '>'
        remove_blanks = placeholder.chomp!('?')
        value = nil
        index = PPEE.search_index(keys, placeholder)
        value = values[index] unless index.nil?
        if remove_blanks and value.blank?
          item = nil
          break
        else
          value ||= "FALTA LA CLAVE"
          item.gsub!("<#{placeholder}>", value)
          item.gsub!("<#{placeholder}?>", '')
        end
      end
    end
    item
  end

  class Test
    attr_reader :test, :actors
    def initialize(params)
      @test       = params[:test]
      @actors     = params[:actors]
      @principal  = Principal.new(params[:principal])
      @extensions = (params[:extensions] || []).map do |extension_params|
        extension_params[:principal] = @principal
        Extension.new(extension_params)
      end
      [@test, @actors, @principal, @extensions].each(&:freeze)
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
    attr_reader :aliases, :preconditions, :actions, :postconditions, :examples

    def initialize(args)
      @aliases        = args[:aliases] || ''
      @preconditions  = args[:preconditions] || []
      @actions        = args[:actions]
      @postconditions = args[:postconditions]
      @examples       = args[:examples] || []
      [@preconditions, @aliases, @actions, @postconditions, @examples].each(&:freeze)
    end
    
    def principal_examples
      return [ self ] if examples.empty?
      examples_copy = examples.dup
      placeholders = examples_copy.shift
      examples_copy.map do |example|
        args = { :preconditions  => PPEE.build_list(preconditions, placeholders, example),
                 :actions        => PPEE.build_list(actions, placeholders, example),
                 :postconditions => PPEE.build_list(postconditions, placeholders, example) }
        args[:aliases] = PPEE.build_item(aliases, placeholders, example) unless aliases.blank?
        Principal.new(args)
      end
    end
  end

  class Extension
    attr_reader :preconditions, :actions, :postconditions, :principal, :examples

    def initialize(args)
      @preconditions  = args[:preconditions] || []
      @actions        = args[:actions]
      @postconditions = args[:postconditions]
      @examples       = args[:examples] || []
      @principal      = args[:principal]
      [@preconditions, @actions, @postconditions, @examples, @principal].each(&:freeze)
    end

    def aliases
      principal.aliases
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
      has_continue_clause? ? inherited.slice(join_index, inherited.size) : []
    end
  
    def all_postconditions
      inherited_postconditions + specific_postconditions 
    end
    
    def inherited_postconditions
      return [] unless keep?(postconditions)
      principal.postconditions - overriden_postconditions
    end
    
    def specific_postconditions
      postconditions.reject{ |p| p =~ /\.\.\.$/ }
    end
    
    def overriden_postconditions
      return [] unless keep?(postconditions)
      postconditions.map do |p|
        if p.end_with?('...')
          prefix = p.gsub(/^ *([t|T]ambi[e|é]n)? *no */, '').gsub('...', '')
          principal.postconditions.find{ |a| a.start_with?(prefix) }
        end
      end.compact
    end
    
    def extension_examples
      return [ self ] if examples.empty?
      examples_copy = examples.dup
      placeholders = examples_copy.shift
      examples_copy.map do |example|
        principal_args = { :preconditions  => PPEE.build_list(principal.preconditions, placeholders, example),
                           :actions        => PPEE.build_list(principal.actions, placeholders, example),
                           :postconditions => PPEE.build_list(principal.postconditions, placeholders, example) }
        principal_args[:aliases] = PPEE.build_item(principal.aliases, placeholders, example) unless principal.aliases.blank?
        
        args = { :preconditions  => PPEE.build_list(preconditions, placeholders, example),
                 :actions        => PPEE.build_list(actions, placeholders, example),
                 :postconditions => PPEE.build_list(postconditions, placeholders, example),
                 :principal      => Principal.new(principal_args)  }
        Extension.new(args)
      end
    end

    private

    def keep?(values)
      values.first =~ /^ *[t|T]ambi[e|é]n/ unless values.empty?
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
    
    def fork_index
      index = PPEE.search_index(inherited, first_action)      
      raise "FORK INDEX NOT FOUND= #{first_action} ... #{inherited}" if index.nil?
      index += 1 unless fork_overriden?
      index
    end
    
    def join_index
      index = last_action.blank? ? fork_index : PPEE.search_index(inherited, last_action)
      raise "JOIN INDEX NOT FOUND= #{last_action} ... #{inherited}" if index.nil?
      raise "JOIN INDEX OUT OF BOUNDS= #{last_action} ... #{inherited}" if index >= inherited.size
      index
    end
    
    def inherited
      principal.actions
    end
    
    def fork_overriden?
      original_first_action.start_with?('no ')
    end
    
    def has_continue_clause?
      original_last_action =~ /^[Cc]ontin[úu]o( [Ee]n)? */
    end

  end
end
