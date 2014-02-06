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
  }
  rule first_rule {
    select when pageview ".*" setting ()
    notify("Hello World", "This is a sample rule.") with sticky = true;
  }
  rule HelloMonkey {
    select when pageview ".*"
    pre {
       queries = page:url("query").split(re/&/)
       name = (queries.index("name") < 0) => "Monkey" | querieis[queries.index("name") + 1];
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