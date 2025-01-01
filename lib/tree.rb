# frozen_string_literal: true

require_relative 'node'

# class Tree
class Tree
  def initialize(array)
    @array = array.uniq.sort!
    @root = root_set(array)
  end

  def root_set(array)
    build_tree(array, 0, array.length - 1)
  end

  def build_tree(array, index_start, index_end)
    return nil if index_start > index_end

    mid = (index_start + index_end) / 2

    root = Node.new(array[mid])

    root.left = build_tree(array, index_start, mid - 1)
    root.right = build_tree(array, mid + 1, index_end)

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true) # rubocop:disable Style/OptionalBooleanParameter
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
