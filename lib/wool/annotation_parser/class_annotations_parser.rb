# Autogenerated from a Treetop grammar. Edits may be lost.


require 'wool/annotation_parser/useful_parsers_parser'
module Wool
  module Parsers
    module Class
      include Treetop::Runtime

      def root
        @root ||= :class_based_constraint
      end

      include GeneralPurpose

      def _nt_class_based_constraint
        start_index = index
        if node_cache[:class_based_constraint].has_key?(index)
          cached = node_cache[:class_based_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0 = index
        r1 = _nt_hash_constraint
        if r1
          r0 = r1
        else
          r2 = _nt_array_constraint
          if r2
            r0 = r2
          else
            r3 = _nt_generic_constraint
            if r3
              r0 = r3
            else
              r4 = _nt_dont_care_constraint
              if r4
                r0 = r4
              else
                r5 = _nt_tuple_constraint
                if r5
                  r0 = r5
                else
                  @index = i0
                  r0 = nil
                end
              end
            end
          end
        end

        node_cache[:class_based_constraint][start_index] = r0

        r0
      end

      module HashConstraint0
        def variance_constraint1
          elements[0]
        end

        def variance_constraint2
          elements[4]
        end
      end

      module HashConstraint1
        def constraints
          [Types::GenericClassType.new(
              'Hash', :covariant, [variance_constraint1.constraints,
              variance_constraint2.constraints])]
        end
      end

      def _nt_hash_constraint
        start_index = index
        if node_cache[:hash_constraint].has_key?(index)
          cached = node_cache[:hash_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0, s0 = index, []
        r1 = _nt_variance_constraint
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            r3 = _nt_space
            if r3
              s2 << r3
            else
              break
            end
          end
          r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
          s0 << r2
          if r2
            if has_terminal?('=>', false, index)
              r4 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('=>')
              r4 = nil
            end
            s0 << r4
            if r4
              s5, i5 = [], index
              loop do
                r6 = _nt_space
                if r6
                  s5 << r6
                else
                  break
                end
              end
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
              s0 << r5
              if r5
                r7 = _nt_variance_constraint
                s0 << r7
              end
            end
          end
        end
        if s0.last
          r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
          r0.extend(HashConstraint0)
          r0.extend(HashConstraint1)
        else
          @index = i0
          r0 = nil
        end

        node_cache[:hash_constraint][start_index] = r0

        r0
      end

      module DontCareConstraint0
        def constraints
          [Types::ClassType.new('Object', :covariant)]
        end
      end

      def _nt_dont_care_constraint
        start_index = index
        if node_cache[:dont_care_constraint].has_key?(index)
          cached = node_cache[:dont_care_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        if has_terminal?('_', false, index)
          r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
          r0.extend(DontCareConstraint0)
          @index += 1
        else
          terminal_parse_failure('_')
          r0 = nil
        end

        node_cache[:dont_care_constraint][start_index] = r0

        r0
      end

      module ArrayConstraint0
        def type
          elements[2]
        end

      end

      module ArrayConstraint1
        def constraints
          [Types::GenericClassType.new(
              'Array', :covariant, [elements[2].constraints])]
        end
      end

      def _nt_array_constraint
        start_index = index
        if node_cache[:array_constraint].has_key?(index)
          cached = node_cache[:array_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0, s0 = index, []
        if has_terminal?('[', false, index)
          r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure('[')
          r1 = nil
        end
        s0 << r1
        if r1
          s2, i2 = [], index
          loop do
            r3 = _nt_space
            if r3
              s2 << r3
            else
              break
            end
          end
          r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
          s0 << r2
          if r2
            r4 = _nt_type
            s0 << r4
            if r4
              s5, i5 = [], index
              loop do
                r6 = _nt_space
                if r6
                  s5 << r6
                else
                  break
                end
              end
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
              s0 << r5
              if r5
                if has_terminal?(']', false, index)
                  r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(']')
                  r7 = nil
                end
                s0 << r7
              end
            end
          end
        end
        if s0.last
          r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
          r0.extend(ArrayConstraint0)
          r0.extend(ArrayConstraint1)
        else
          @index = i0
          r0 = nil
        end

        node_cache[:array_constraint][start_index] = r0

        r0
      end

      module TupleType0
        def constraints
          [Types::TupleType.new(super)]
        end
      end

      def _nt_tuple_constraint
        start_index = index
        if node_cache[:tuple_constraint].has_key?(index)
          cached = node_cache[:tuple_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        r0 = _nt_parenthesized_type_list
        r0.extend(TupleType0)

        node_cache[:tuple_constraint][start_index] = r0

        r0
      end

      module GenericConstraint0
        def variance_constraint
          elements[0]
        end

        def type_list
          elements[4]
        end

      end

      module GenericConstraint1
        def constraints
          class_constraint = variance_constraint.constraints.first
          [Types::GenericClassType.new(
              class_constraint.class_name, class_constraint.variance,
              type_list.constraints)]
        end
      end

      def _nt_generic_constraint
        start_index = index
        if node_cache[:generic_constraint].has_key?(index)
          cached = node_cache[:generic_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_variance_constraint
        s1 << r2
        if r2
          s3, i3 = [], index
          loop do
            r4 = _nt_space
            if r4
              s3 << r4
            else
              break
            end
          end
          r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          s1 << r3
          if r3
            if has_terminal?('<', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('<')
              r5 = nil
            end
            s1 << r5
            if r5
              s6, i6 = [], index
              loop do
                r7 = _nt_space
                if r7
                  s6 << r7
                else
                  break
                end
              end
              r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
              s1 << r6
              if r6
                r8 = _nt_type_list
                s1 << r8
                if r8
                  s9, i9 = [], index
                  loop do
                    r10 = _nt_space
                    if r10
                      s9 << r10
                    else
                      break
                    end
                  end
                  r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
                  s1 << r9
                  if r9
                    if has_terminal?('>', false, index)
                      r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('>')
                      r11 = nil
                    end
                    s1 << r11
                  end
                end
              end
            end
          end
        end
        if s1.last
          r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          r1.extend(GenericConstraint0)
          r1.extend(GenericConstraint1)
        else
          @index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          r12 = _nt_variance_constraint
          if r12
            r0 = r12
          else
            @index = i0
            r0 = nil
          end
        end

        node_cache[:generic_constraint][start_index] = r0

        r0
      end

      module VarianceConstraint0
        def constant
          elements[0]
        end

      end

      module VarianceConstraint1
        def constraints
          constant.constraints.map { |x| x.variance = :invariant; x }
        end
      end

      module VarianceConstraint2
        def constant
          elements[0]
        end

      end

      module VarianceConstraint3
        def constraints
          constant.constraints.map { |x| x.variance = :contravariant; x }
        end
      end

      def _nt_variance_constraint
        start_index = index
        if node_cache[:variance_constraint].has_key?(index)
          cached = node_cache[:variance_constraint][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        i0 = index
        i1, s1 = index, []
        r2 = _nt_constant
        s1 << r2
        if r2
          if has_terminal?("=", false, index)
            r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("=")
            r3 = nil
          end
          s1 << r3
          if r3
            i4 = index
            if has_terminal?('>', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('>')
              r5 = nil
            end
            if r5
              r4 = nil
            else
              @index = i4
              r4 = instantiate_node(SyntaxNode,input, index...index)
            end
            s1 << r4
          end
        end
        if s1.last
          r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          r1.extend(VarianceConstraint0)
          r1.extend(VarianceConstraint1)
        else
          @index = i1
          r1 = nil
        end
        if r1
          r0 = r1
        else
          i6, s6 = index, []
          r7 = _nt_constant
          s6 << r7
          if r7
            if has_terminal?("-", false, index)
              r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("-")
              r8 = nil
            end
            s6 << r8
          end
          if s6.last
            r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
            r6.extend(VarianceConstraint2)
            r6.extend(VarianceConstraint3)
          else
            @index = i6
            r6 = nil
          end
          if r6
            r0 = r6
          else
            r9 = _nt_constant
            if r9
              r0 = r9
            else
              @index = i0
              r0 = nil
            end
          end
        end

        node_cache[:variance_constraint][start_index] = r0

        r0
      end

      module Constant0
      end

      module Constant1
        def constraints
          [Types::ClassType.new(text_value, :covariant)]
        end
      end

      def _nt_constant
        start_index = index
        if node_cache[:constant].has_key?(index)
          cached = node_cache[:constant][index]
          if cached
            cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
            @index = cached.interval.end
          end
          return cached
        end

        s0, i0 = [], index
        loop do
          i1, s1 = index, []
          if has_terminal?('::', false, index)
            r3 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('::')
            r3 = nil
          end
          if r3
            r2 = r3
          else
            r2 = instantiate_node(SyntaxNode,input, index...index)
          end
          s1 << r2
          if r2
            if has_terminal?('\G[A-Z]', true, index)
              r4 = true
              @index += 1
            else
              r4 = nil
            end
            s1 << r4
            if r4
              s5, i5 = [], index
              loop do
                if has_terminal?('\G[A-Za-z_]', true, index)
                  r6 = true
                  @index += 1
                else
                  r6 = nil
                end
                if r6
                  s5 << r6
                else
                  break
                end
              end
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
              s1 << r5
            end
          end
          if s1.last
            r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
            r1.extend(Constant0)
          else
            @index = i1
            r1 = nil
          end
          if r1
            s0 << r1
          else
            break
          end
        end
        if s0.empty?
          @index = i0
          r0 = nil
        else
          r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
          r0.extend(Constant1)
        end

        node_cache[:constant][start_index] = r0

        r0
      end

    end

    class ClassParser < Treetop::Runtime::CompiledParser
      include Class
    end

  end
end