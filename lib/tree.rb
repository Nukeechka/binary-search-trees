# frozen_string_literal: true

require_relative 'node'

# class Tree
class Tree # rubocop:disable Metrics/ClassLength
  attr_reader :root, :array

  def initialize(array)
    @array = array.uniq!.sort!
    @root = root_set(array)
    @temp_results = []
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

  def insert(value, root = @root)
    return Node.new(value) if root.nil?

    return root if root.data == value

    if root.data < value
      root.right = insert(value, root.right)
    else
      root.left = insert(value, root.left)
    end
    root
  end

  def delete(value, root = @root) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    return root if root.nil?

    if root.data > value
      root.left = delete(value, root.left)
    elsif root.data < value
      root.right = delete(value, root.right)
    else
      return root.right if root.left.nil?

      return root.left if root.right.nil?

      successor = get_successor(root)
      root.data = successor.data
      root.right = delete(successor.data, root.right)
    end
    root
  end

  def find(value, root = @root)
    return nil if root.nil?

    return root if root.data == value

    if root.data < value
      find(value, root.right)
    else
      find(value, root.left)
    end
  end

  def level_order # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    return nil if @root.nil?

    return @array unless block_given?

    temp = []
    result = []
    q = []
    q.push(@root)
    temp.push(@root)
    until q.empty?
      current = q.first
      unless current.left.nil?
        q.push(current.left)
        temp.push(current.left)
      end
      unless current.right.nil?
        q.push(current.right)
        temp.push(current.right)
      end
      q.shift
    end
    temp.each do |node|
      result << yield(node)
    end
    result
  end

  def preorder
    return @array unless block_given?

    result = []
    preorder_traversal
    @temp_results.each do |data|
      result << yield(data)
    end
    @temp_results = []
    result
  end

  def inorder
    return @array unless block_given?

    result = []
    inorder_traversal
    @temp_results.each do |data|
      result << yield(data)
    end
    @temp_results = []
    result
  end

  def postorder
    return @array unless block_given?

    result = []
    postorder_traversal
    @temp_results.each do |data|
      result << yield(data)
    end
    @temp_results = []
    result
  end

  def height(root)
    return if @root.nil?
    return -1 if root.nil?

    left_height = height(root.left)
    right_height = height(root.right)
    [left_height, right_height].max + 1
  end

  def depth(node, root = @root)
    return -1 if root.nil?

    dist = -1

    return dist + 1 if root.data == node.data

    dist = depth(node, root.left)
    return dist + 1 if dist >= 0

    dist = depth(node, root.right)
    return dist + 1 if dist >= 0

    dist
  end

  private

  def preorder_traversal(root = @root)
    return if root.nil?

    @temp_results << root.data
    preorder_traversal(root.left)
    preorder_traversal(root.right)
  end

  def inorder_traversal(root = @root)
    return if root.nil?

    inorder_traversal(root.left)
    @temp_results << root.data
    inorder_traversal(root.right)
  end

  def postorder_traversal(root = @root)
    return if root.nil?

    postorder_traversal(root.left)
    postorder_traversal(root.right)
    @temp_results << root.data
  end

  def root_set(array)
    build_tree(array, 0, array.length - 1)
  end

  def get_succesor(current)
    current = current.right
    current = current.left while !current.nil? && !current.left.nil?
    current
  end
end
