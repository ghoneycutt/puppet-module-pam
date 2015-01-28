module Puppet::Parser::Functions
  newfunction(:validate_pam_directives, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all values are arrays with hashes with all the keys required for
    a pam directive.

    Abort catalog
    compilation if any value fails this check.
    ENDHEREDOC

    unless args.length == 1 then
      raise Puppet::ParseError, ("validate_pam_directive(): wrong number of arguments (#{args.length}; Requires 1 argument)")
    end

    directives = args[0]
    unless directives.is_a? Array
      raise Puppet::ParseError, ("Value passed to validate_pam_directives() must be a Array, got #{hash.class}")
    end


    directives.each_index do |directive_index|
    directive = directives.at directive_index

      unless directive.is_a? Hash
      raise Puppet::ParseError, ("All values in the directives array must be a hash. Value at index #{directive_index} is a #{directive.class}")
    end
      unless directive.has_key? 'control'
        raise Puppet::ParseError, ("PAM directive #{directive} (Index: #{directive_index}) does not include a value for 'control'")
      end

      unless directive.has_key? 'module-path'
        raise Puppet::ParseError, ("PAM directive #{directive} (Index: #{directive_index}) does not include a value for 'module-path'")
      end

      unless directive.has_key? 'module-arguments'
        raise Puppet::ParseError, ("PAM directive #{directive} (Index: #{directive_index}) does not include a value for 'module-arguments'")
      end
    end

  end
end
