# frozen_string_literal: true

require_relative 'lib/tree'

test = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

test.insert(2)
test.pretty_print
test.insert(6)
test.pretty_print
test.delete(2)
test.pretty_print
