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
  rule show_form {
    select when pageview ".*"
    pre {
      replace = << <div id="my_main"></div> >>;
      my_form = <<
          <form id="my_form" onsubmit="return false">
            <input type="text" name="first" placeholder="first" />
            <input type="text" name="last" placeholder="last" />
            <input type="submit" value="Submit" />
          </form>
        >>;
      my_p = << <p id="my_p"></p> >>;
    }
    {
      append("#main", replace);
      append("#my_main", my_form);
      append("#my_main", my_p);
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
      replace_inner("#my_p", "Welcome #{full}");
    }
    fired {
      set ent:first first;
      set ent:last last;
      set ent:full full;
    }
  }
  rule show_name {
    select when pageview ".*"
    if (not ent:full.isnull() || ent:full neq "") then {
      notify("I'm here", "hello #{ent:full}");
      replace_inner("#my_p", "Welcome #{ent:full}");
    }
  }
  rule clear_name {
    select when pageview ".*"
    pre {
      c = getVal("clear") eq "1" => true | false;
    }
    if (c && (not ent:full.isnull())) then {
      notify("Clearing", "Goodbye #{ent:full}");
    }
    fired {
      clear ent:full if c;
      clear ent:first if c;
      clear ent:last if c;
    }
  }
}