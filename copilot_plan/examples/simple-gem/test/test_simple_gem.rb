require_relative "../lib/simple_gem"
require "minitest/autorun"

class TestSimpleGem < Minitest::Test
  def test_hello_without_name
    assert_equal "Hello from SimpleGem!", SimpleGem.hello
  end
  
  def test_hello_with_name
    assert_equal "Hello, Ruby!", SimpleGem.hello("Ruby")
  end
  
  def test_time_greeting_returns_string
    result = SimpleGem.time_greeting
    assert_kind_of String, result
    assert_match(/Good (morning|afternoon|evening|night) from SimpleGem!/, result)
  end
  
  def test_time_greeting_with_name
    result = SimpleGem.time_greeting("Alice")
    assert_kind_of String, result
    assert_match(/Good (morning|afternoon|evening|night), Alice!/, result)
  end
end