module Laser
  module SexpAnalysis
    # This class models a scope in Ruby. It has a constant table,
    # a self pointer, and a parent pointer to the enclosing scope.
    # It also has a local variable table.
    class Scope
      class ScopeLookupFailure < StandardError
        attr_accessor :scope, :query
        def initialize(scope, query)
          @scope, @query = scope, query
          super("OpenScope #{@scope.inspect} does not contain #{query.inspect}")
        end
      end

      attr_accessor :constants, :parent, :locals
      attr_reader :self_ptr
      def initialize(parent, self_ptr, constants={}, locals={})
        unless respond_to?(:lookup_local)
          raise NotImplementedError.new(
              'must create OpenScope or ClosedScope. Not just Scope.')
        end
        @parent, @self_ptr, @constants, @locals = parent, self_ptr, constants, locals
        @locals['self'] = Bindings::GenericBinding.new('self', self_ptr)
      end
      
      def initialize_copy(other)
        @locals = other.locals.dup
        @constants = other.constants.dup
      end
      
      def self_ptr=(other)
        @self_ptr = other
        @locals['self'] = Bindings::GenericBinding.new('self', other)
      end
      
      def add_binding!(new_binding)
        case new_binding.name[0,1]
        when /[A-Z]/
          constants[new_binding.name] = new_binding
        else
          locals[new_binding.name] = new_binding
        end
      end
      
      def path
        self_ptr.path
      end

      # Looks up a binding with the given name.
      # Raises ScopeLookupFailure if the binding is not found.
      def lookup(str)
        if str =~ /^[A-Z]/ && constants[str]
        then constants[str]
        elsif str =~ /^[A-Z]/ && parent
          begin
            parent.lookup(str)
          rescue ScopeLookupFailure => err
            err.scope = self
            raise err
          end
        elsif str[0,1] == '$'
          # global, create on demand.
          Scope::GlobalScope.locals[str] ||= Bindings::GlobalVariableBinding.new(str, LaserObject.new)
        else lookup_local str
        end
      end

      def lookup_path(path)
        parts = path.split('::')
        parts.inject(self) { |scope, part| scope.lookup(part).scope }
      end
      
      # Does this scope see the given variable name?
      def sees_var?(var)
        lookup(var) rescue false
      end
    end
    
    class OpenScope < Scope
      def lookup_local(str)
        if locals[str]
        then locals[str]
        elsif parent then parent.lookup_local(str)
        else raise ScopeLookupFailure.new(self, str)
        end
      end
    end
    
    class ClosedScope < Scope
      def lookup_local(str)
        locals[str] or raise ScopeLookupFailure.new(self, str)
      end
    end
  end
end