module Laser
  module SexpAnalysis
    # This annotation attempts to resolve a method call to a set of methods
    # that may be the target of that invocation. This relies on both the
    # name of the method, the receiver's type, and then its arity. Lots of
    # bugs can be found here!
    class MethodResolutionAnnotation < BasicAnnotation
      add_property :method_estimate
      
      add :super do |node|
        matched_method = resolve_super_call(node)
        node.method_estimate = Set.new([matched_method])
        call_arity = ArgumentExpansion.new(node[1]).arity
        unless matched_method.arity.compatible?(call_arity)
          raise IncompatibleArityError.new(
              "Called super with #{call_arity} implicit arguments, but " +
              "the superclass implementation takes #{matched_method.arity} arguments.",
              node)
        end
      end
      
      add :zsuper do |node|
        matched_method = resolve_super_call(node)
        node.method_estimate = Set.new([matched_method])
        call_arity = node.scope.method.arity
        unless matched_method.arity.compatible?(call_arity)
          raise IncompatibleArityError.new(
              "Called super with #{call_arity} implicit arguments, but " +
              "the superclass implementation takes #{matched_method.arity} arguments.",
              node)
        end
      end
      
      def resolve_super_call(node)
        current_method = node.scope.method
        if current_method.nil?
          raise NotInMethodError.new('Cannot call super outside of a method.', node)
        end
        superclass = node.scope.self_ptr.klass.superclass
        if (method = superclass.instance_methods[current_method.name])
          return method
        end
        raise NoSuchMethodError.new("Called super in method '#{current_method.name}', " +
                                    "but no superclass has a method with that name.", node)
      end
      
      def with_default_method_estimate(node)
        yield
      rescue NoSuchMethodError => err
        node.method_estimate = []
        raise err
      end
      
      add :unary do |node, op, rhs|
        type = rhs.expr_type
        name = op.to_s
        with_default_method_estimate(node) do
          node.method_estimate = filter_by_arity(
              methods_for_type_name(type, name, node), name, Arity::EMPTY, node)
        end
      end
      
      add :binary do |node, lhs, op, rhs|
        type = lhs.expr_type
        name = op.to_s
        with_default_method_estimate(node) do
          node.method_estimate = filter_by_arity(
              methods_for_type_name(type, name, node), name, Arity.new(1..1), node)
        end
      end
      
      add :method_add_arg do |node, meth, args|
        visit meth
        existing_methods = meth.method_estimate
        if existing_methods.any?
          expansion = ArgumentExpansion.new(args)
          node.method_estimate = filter_by_arity(
              meth.method_estimate, existing_methods.first.name, expansion.arity, node)
        end
      end
      
      add :fcall do |node, meth|
        type = node.scope.lookup('self').expr_type
        name = meth.expanded_identifier
        with_default_method_estimate(node) do
          node.method_estimate = methods_for_type_name(type, name, node)
        end
      end
      
      add :call do |node, recv, sep, meth|
        type = recv.expr_type
        name = meth.expanded_identifier
        with_default_method_estimate(node) do
          node.method_estimate = methods_for_type_name(type, name, node)
        end
      end

      add :var_ref do |node|
        next unless node.binding.nil?
        type = node.scope.lookup('self').expr_type
        name = node.expanded_identifier
        with_default_method_estimate(node) do
          node.method_estimate = filter_by_arity(
              methods_for_type_name(type, name, node), name, Arity::EMPTY, node)
        end
      end
      
      def methods_for_type_name(type, name, node)
        methods = type.matching_methods(name)
        if methods.empty?
          raise NoSuchMethodError.new("Could not find any methods named #{name}.", node)
        end
        methods
      end
      
      def filter_by_arity(methods, name, arity, node)
        pruned_methods = methods.select { |meth| meth.arity.compatible?(arity) }
        if pruned_methods.empty?
          raise NoSuchMethodError.new("Could not find any methods named #{name} that take 0 arguments.", node)
        end
        pruned_methods
      end
    end
  end
end