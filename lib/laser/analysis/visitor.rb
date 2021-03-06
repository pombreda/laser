module Laser
  module Analysis
    # Visitor: a set of methods for visiting an AST. The
    # default implementations visit each child and do no
    # other processing. By including this module, and
    # implementing certain methods, you can do your own
    # processing on, say, every instance of a :rescue AST node.
    # The default implementation will go arbitrarily deep in the AST
    # tree until it hits a method you define.
    module Visitor
      extend ModuleExtensions
      def self.included(klass)
        klass.__send__(:extend, ClassMethods)
        klass.__send__(:extend, ModuleExtensions)
        class << klass
          attr_writer :filters
          def filters
            @filters ||= []
          end
        end
      end
      module ClassMethods
        extend ModuleExtensions
        # A filter is a general-purpose functor run on a subset of the nodes in
        # an AST. It includes a set of possible ways to match a node, including
        # node types and general procs, and it includes a block to run in order
        # to do some interesting manipulation of the matching node.
        Filter = Struct.new(:args, :blk) do
          def matches?(node)
            args.any? do |filter|
              case filter
              when ::Symbol then node.type == filter
              when Proc then filter.call(node, *node.children)
              end
            end
          end
          
          def inspect
            args.inspect
          end
          
          # Runs the filter on the given node, with the visitor object as the
          # 'self'. That way we create the illusion of methods using the #add
          # syntax.
          #
          # If any analysis-specific errors are raised and not caught, they are
          # simply attached to the node's errors list. If the filter would like
          # to continue operating after an error is raised, it must catch it
          # and attach the error itself.
          def run(node, visitor)
            begin
              visitor.instance_exec(node, *node.children, &blk)
            rescue Error => err
              err.ast_node = node
              node.errors << err
            rescue StandardError => err
              err.message.replace(err.message + " (Visitor #{self.inspect} Occurred at node #{node.inspect})")
              raise err
            end
          end
        end
        # Adds a new filter with the given matching strategies and a block to run
        # upon matching a node.
        def add(*args, &blk)
          (self.filters ||= []) << Filter.new(args, blk)
        end
      end
      
      attr_reader :text
      # Annotates the given node +root+, assuming the tree represents the source contained in
      # +text+. This is useful for text-based discovery that has to happen, often to capture
      # lexing information lost by the Ripper parser.
      #
      # root: Sexp
      # text: String
      def annotate_with_text(root, text)
        @text = text
        @lines = nil
        annotate! root
      end
      
      # Entry point for annotation. Should be called on the root of the tree we
      # are interested in annotating.
      #
      # root: Sexp
      def annotate!(root)
        visit root
      end

      # Visits a given node. Will be automatically called by the visitor and can (and often
      # should) be called manually.
      #
      # node: Sexp
      def visit(node)
        case node
        when Sexp
          case node[0]
          when ::Symbol
            try_filters node or default_visit node
          when Array
            default_visit(node)
          end
        end
      end
      
      # Visits the children of the node, by calling #visit on every child of
      # node that is a Sexp.
      #
      # node: Sexp
      def visit_children(node)
        node.children.select {|x| Sexp === x}.each {|x| visit(x) }
      end
      # By default, we should visit every child, trying to find something the visitor
      # subclass has overridden.
      alias_method :default_visit, :visit_children
      
      # Tries all known filters on the given node, and if the filter matches, then
      # the filter is run on the node. Returns whether or not any filters matched.
      #
      # node: Sexp
      # return: Boolean
      def try_filters(node)
        any_ran = false
        self.class.filters.each do |filter|
          if filter.matches?(node)
            filter.run(node, self)
            any_ran = true
          end
        end
        any_ran
      end

      ################## Source text manipulation methods ###############

      def lines
        @lines ||= text.lines.to_a
      end

    end
  end
end
