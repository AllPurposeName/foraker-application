require "minitest/autorun"
require "minitest/pride"
require "ostruct"
require_relative "linked_resume"

class ResumeNodeTest < MiniTest::Test

  def test_it_has_a_phrase
    expected = "Hello World!"
    resume_node = ResumeNode.new({phrase: expected})

    assert_equal expected, resume_node.phrase
  end

  def test_it_has_a_type
    expected = :kitty_cat
    resume_node = ResumeNode.new({type: expected})

    assert_equal expected, resume_node.type
  end

  def test_it_has_a_next_node
    expected_phrase = "Oswald is the best dog ever"
    expected_type   = :WoooWoooWoo
    resume_node = ResumeNode.new({})

    resume_node.push({phrase: expected_phrase, type: expected_type})

    assert_equal expected_phrase, resume_node.next_node.phrase
    assert_equal expected_type,   resume_node.next_node.type
  end

  def test_it_gives_a_type_signout_based_on_types
    value = :value
    key   = :key

    head = ResumeNode.new({type: key})
    body = head.push({type: key})
    abs  = body.push({type: value})
    tail = abs.push({type: value})

    assert_equal ":\n  ", head.type_signout
    assert_equal ": ",    body.type_signout
    assert_equal "\n",    abs.type_signout
    assert_equal "\n", tail.type_signout
  end
end

class CirriculumVitaeTest < MiniTest::Test
  attr_reader :cv

  def setup
    @cv = CurriculumVitae.new("./linked_test.yml")
  end

  def test_it_always_has_a_root_node
    assert cv.root_node
  end

  def test_it_has_a_loaded_resume
    assert_equal ({"hello" => "is anybody in there"}), cv.resume
    assert cv.resume
  end

  def test_it_can_push_to_the_root_node
    expected_phrase = "NewPhrase"
    expected_type  = "NewType"
    refute cv.root_node.value
    assert_equal :key, cv.root_node.type
    cv.push({phrase: expected_phrase, type: expected_type})

    assert_equal expected_phrase, cv.root_node.phrase
    assert_equal expected_type,  cv.root_node.type
  end

  def test_it_counts_0_for_an_empty_list
    assert_equal 0, cv.count
  end

  def test_it_counts_2_for_a_list_with_two
    cv.push({})
    cv.push({})

    assert_equal 2, cv.count
  end

  def test_it_counts_keys_only
    expected = 5
    cv.push({type: :shark})
    expected.times { cv.push({type: :key}) }
    cv.push({type: :orca})
    cv.push({type: :swordfish})
    cv.push({type: :tuna})

    assert_equal expected, cv.key_count
  end

  def test_it_counts_values_only
    expected = 8
    cv.push({type: :key})
    expected.times { cv.push({type: :value}) }
    cv.push({type: :box})
    cv.push({type: :screw})
    cv.push({type: :chest})

    assert_equal expected, cv.value_count
  end
end

class EmptyNodeTest < MiniTest::Test
  attr_reader :empty

  def setup
    @empty = EmptyNode.new(OpenStruct.new({node_type: "instanceVariable"}))
  end

  def test_it_gives_a_false_key_type
    assert_equal :key, empty.type
  end

  def test_it_gives_a_null_count
    assert_equal 0, empty.count(nil)
    assert_equal 0, empty.count(:key)
    assert_equal 0, empty.count(:value)
  end

  def test_it_gives_a_null_value
    nil
  end
end
