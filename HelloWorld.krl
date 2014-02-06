ruleset HelloWorldApp {
  meta {
    name "Hello World"
    description <<
      Hello World
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
  }
  dispatch {
  }
  global {
    getVal = function(key) {
      pairs = page:url("query").split(re/&/g);
      c = pairs.filter(function(x) {x.substr(0, 4) eq key});
      str = (c.length() > 0) => c[0] | "";
      pair = (str neq "") => str.split(re/=/g) | [];
      res = (pair.length() > 0) => pair[1] | "";
      res
    };
  }
  rule first_rule {
    select when pageview ".*" setting ()
    notify("Hello World", "This is a sample rule.") with sticky = true;
  }
  rule HelloMonkey {
    select when pageview ".*"
    pre {
       //name = (page:url("query") eq "") => "Monkey" | page:url("query");
       name = getVal("name");
    }
    notify("Hello " + name, "This is a monkey rule") with sticky = true;
  }
  rule HelloWorld {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Hello, World!</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Hello World!", {}, my_html);
    }
  }
}