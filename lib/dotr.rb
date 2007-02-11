module DotR
  module Styled # :nodoc:
    def method_missing(method, *args)
      return super unless /^(\w+)=$/ =~ method.to_s && args.size == 1
      style_attrs()[$1.to_sym] = args.first
    end

    def style
      return '' if style_attrs.empty?
      " [" + style_attrs.keys.sort_by { |k| k.to_s }.map { |k| "#{k}=\"#{style_attrs[k]}\"" }.join(',') + "]"
    end

    private

    def style_attrs
      @style_attrs ||= {}
    end
  end

  # This class represents a directed graph that can be rendered to a graphics
  # image using its #diagram method.
  #
  # Example:
  #   d = DotR::Digraph.new do |g|
  #     g.node('node1') do |n|
  #       n.label = "MyLabel"
  #       n.fontsize="8"
  #     end
  #     g.node('node2', :label => 'SecondNode') do |n|
  #       n.connection('node1', :label => 'relates to')
  #     end
  #   end
  #   File.open('diagram.png', 'w') { |f| f.write(d.diagram(:png)) }
  class Digraph
    include Styled
    attr_accessor :name

    # Create a new Digraph.  If a block is provided it will be called with
    # the graph as a parameter.
    #
    # Specify styles on this object by setting instance attributes.
    # Possible attributes include 'label' and 'fontsize'; the attribute names and
    # possible values correspond to the style attributes described in the 'dot' manual.
    def initialize(name="diagram", style={}, &block)
      @name = name
      @nodes = []
      style_attrs.update(style)
      yield self if block
    end

    # Create a Node in the graph with a given name.  If a block is provided
    # it will be called with the node as a parameter, for convenient adding of
    # connections or specification of style attributes.
    def node(name, style={}, &block)
      @nodes << Node.new(name, style, &block)
    end

    # Create a connection in the graph between two nodes with the given names.
    # If a block is provided # it will be called with the connection as a parameter,
    # for convenient specification of styles.
    #
    # Nodes with the given names are implicitly created if they have not
    # been explicitly added.  See Node#connection
    def connection(from_node_name, to_node_name, style={}, &block)
      node(from_node_name) do |n|
        n.connection(to_node_name, style, &block)
      end
    end

    # Returns the dot input script equivalent of this digraph
    def to_s
      script = []
      render_to(script)
      script.flatten.join("\n") + "\n"
    end

    # Render the diagram to a graphic image, returning the raw image data as
    # a string.
    #
    # Possible values for +format+ include +:svg+, +:png+, +:ps+, +:gif+
    def diagram(format=:png)
      Tempfile.open("diag") do |input|
        input.write(self.to_s)
        input.flush
        return IO.popen("dot -T#{format} #{input.path}", 'rb') { |dot| dot.read }
      end
    end

    private

    def render_to(output_lines)
      output_lines << "digraph \"#{name}\" {"
      @nodes.each { |node| node.render_to(output_lines) }
      style_attrs.each do |k,v|
        output_lines << "  #{k}=\"#{v}\";"
      end
      output_lines << '}'
    end
  end


  private

  # Represents a node in a digraph.  Instances of this class are created by calling
  # Digraph#node.
  #
  # Specify styles on this object by setting instance attributes.
  # Possible attributes include 'label' and 'shape'; the attribute names and
  # possible values correspond to the style attributes described in the 'dot' manual.
  class Node
    include Styled
    attr_reader :name

    def initialize(name, style={}, &block)  #:nodoc:
      @name = name
      @connections = []
      self.label = name
      style_attrs.update(style)
      yield self if block
    end

    def connection(other_node_name, style={}, &block)
      @connections << Connection.new(self.name, other_node_name, style, &block)
    end

    def render_to(output_lines)  #:nodoc:
      output_lines << "  \"#{self.name}\"" + style + ";"
      @connections.each { |c| c.render_to(output_lines) }
    end
  end

  # Represents a connection between two nodes in a digraph.
  # Instances of this class are created by calling Digraph#connection or
  # Node#connection.
  #
  # Specify styles on this object by setting instance attributes.
  # Possible attributes include 'label' and 'shape'; the attribute names and
  # possible values correspond to the style attributes described in the 'dot' manual.
  class Connection
    include Styled
    attr_reader :from_name, :to_name

    def initialize(from_name, to_name, style={}, &block)  #:nodoc:
      @from_name = from_name
      @to_name = to_name
      style_attrs.update(style)
      yield self if block
    end

    def render_to(output_lines)  # :nodoc:
      output_lines << "  \"#{from_name}\" -> \"#{to_name}\"" + style + ";"
    end
  end
end

