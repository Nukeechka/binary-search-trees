# frozen_string_literal: true

require_relative 'lib/tree'

array = Array.new(15) { rand(1..100) }
test = Tree.new(array)
test.insert(124)
test.insert(125)
test.pretty_print
p test.balanced?
test.rebalance
test.pretty_print
p test.balanced?
