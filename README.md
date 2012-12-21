# DotR

DotR is a tiny ruby library that makes it easy to construct directed
graphs in a variety of graphic formats using the 'dot' utility from
the Graphviz suite of programs.

In order to use DotR you must have Graphviz installed.
See http://www.graphviz.org for installation instructions and examples
of the output that is possible.

For more information or to contact author Steve Purcell,
please visit http://dotr.sanityinc.com.

## Example

```ruby
d = DotR::Digraph.new do |g|
  g.node('node1') do |n|
    n.label = "MyLabel"
    n.fontsize="8"
  end
  g.node('node2', :label => 'SecondNode') do |n|
    n.connection('node1', :label => 'relates to')
  end
end

File.open('diagram.png', 'w') { |f| f.write(d.diagram(:png)) }
```

## Resources

* [Home page](https://github.com/purcell/dotr)

* [Graphviz home page and sample output](http://www.graphviz.org)

## Copyright

Copyright (c) 2006 Steve Purcell.

## Licence

DotR is distributed under the same terms as Ruby itself.

<hr>

[![](http://api.coderwall.com/purcell/endorsecount.png)](http://coderwall.com/purcell)

[![](http://www.linkedin.com/img/webpromo/btn_liprofile_blue_80x15.png)](http://uk.linkedin.com/in/stevepurcell)

[Steve Purcell's blog](http://www.sanityinc.com/) // [@sanityinc on Twitter](https://twitter.com/sanityinc)
