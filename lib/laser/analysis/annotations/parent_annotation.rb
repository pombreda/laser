module Laser
  module SexpAnalysis
    # This is a simple inherited attribute applied to each node,
    # giving a pointer to that node's parent. That way AST traversal
    # is easier.
    # This is the annotator for the parent annotation.
    class ParentAnnotation < BasicAnnotation
      add_property :parent, :next, :prev
      add_computed_property :ancestors do
        case parent
        when nil then []
        else parent.ancestors + [parent]
        end
      end

      # Replaces the general node visit method with one that assigns
      # the current scope to the visited node.
      def default_visit(node)
        children = node.children
        children.each_with_index do |elt, idx|
          next unless SexpAnalysis::Sexp === elt
          elt.parent = node
          elt.next = children[idx+1]
          elt.prev = children[idx-1] if idx >= 1
        end
        visit_children(node)
      end
    end
  end
end