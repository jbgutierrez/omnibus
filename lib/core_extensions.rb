def Object.hash_initializer(*attribute_names)
  define_method(:initialize) do |*args|
    data = args.first || {}
    attribute_names.each do |attribute_name|
      instance_variable_set "@#{attribute_name}", data[attribute_name]
    end
  end
end