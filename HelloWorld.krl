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
  rule respond_submit {
    select when web submit "#my_form"
    pre {
      first = event:attr("first");
      last = event:attr("last");
      full = first+" "+last;
    }
    {
      notify("Submitted", full);
      replace_inner("#main", "Welcome ${full}");
    }
    fired {
      set ent:first first;
      set ent:last last;
      set ent:full full;
    }
  }
}