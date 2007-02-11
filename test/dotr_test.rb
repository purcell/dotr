$:.unshift(File.dirname(__FILE__) + "/../lib")

require 'test/unit'
require 'dotr'

class DotRDigraphTest < Test::Unit::TestCase

  def test_empty_digraph
    d = DotR::Digraph.new('myname')
    assert_digraph_equals <<-END, d
      digraph "myname" {
      }
    END
  end

  def test_single_node
    d = DotR::Digraph.new do |graph|
      graph.node('somenode')
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "somenode" [label="somenode"];
      }
    END
  end

  def test_connection_with_node
    d = DotR::Digraph.new do |graph|
      graph.node 'somenode' do |node|
        node.connection('someothernode')
      end
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "somenode" [label="somenode"];
        "somenode" -> "someothernode";
      }
    END
  end

  def test_connection_without_node
    d = DotR::Digraph.new do |graph|
      graph.connection('somenode', 'someothernode')
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "somenode" [label="somenode"];
        "somenode" -> "someothernode";
      }
    END
  end

  def test_can_style_nodes_with_block
    d = DotR::Digraph.new do |graph|
      graph.node('somenode') do |node|
        node.label = "MyLabel"
        node.fontsize="8"
      end
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "somenode" [fontsize="8",label="MyLabel"];
      }
    END
  end

  def test_can_style_connections_with_block
    d = DotR::Digraph.new do |graph|
      graph.connection('somenode', 'someothernode') do |node|
        node.label = "MyLabel"
        node.fontsize="8"
      end
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "somenode" [label="somenode"];
        "somenode" -> "someothernode" [fontsize="8",label="MyLabel"];
      }
    END
  end

  def test_can_style_nodes_with_hash
    d = DotR::Digraph.new do |graph|
      graph.node('somenode', :label => "MyLabel", :fontsize => 8)
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "somenode" [fontsize="8",label="MyLabel"];
      }
    END
  end

  def test_can_style_connections_with_hash
    d = DotR::Digraph.new do |graph|
      graph.connection('somenode', 'someothernode', :label => "MyLabel", :fontsize => 8)
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "somenode" [label="somenode"];
        "somenode" -> "someothernode" [fontsize="8",label="MyLabel"];
      }
    END
  end

  def test_can_style_nodes_independently
    d = DotR::Digraph.new do |graph|
      graph.node('foo', :fontsize => 8)
      graph.node('bar', :fontsize => 5, :label => "Bar")
    end
    assert_digraph_equals <<-END, d
      digraph "diagram" {
        "foo" [fontsize="8",label="foo"];
        "bar" [fontsize="5",label="Bar"];
      }
    END
  end

  def test_can_style_empty_graph
    d = DotR::Digraph.new('myname', :fontsize => 6)
    assert_digraph_equals <<-END, d
      digraph "myname" {
        fontsize="6";
      }
    END
  end

  private

  def assert_digraph_equals expected, digraph
    prefix = expected.scan(/^(\s+)/).first
    assert_equal(expected.strip.gsub(/^#{prefix}/, ''), digraph.to_s.strip)
  end

end
