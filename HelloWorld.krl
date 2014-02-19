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
  rule show_form {
    select when pageview ".*"
    pre {
      replace = << <div id="my_main">Add to Main Div</div> >>;
      my_form = <<
          <form id="my_form" onsubmit="return false">
            <input type="text" name="first" placeholder="first" />
            <input type="text" name="last" placeholder="last" />
            <input type="submit" value="Submit" />
          </form>
        >>;
    }
    {
      append("#main", replace);
      append("#my_main", my_form);
      watch("#my_form", "submit");
    }
  }
}