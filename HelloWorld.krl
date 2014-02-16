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
  rule show_form {
    select when pageview
    pre {
      replace = << <div id="main">Add to Main Div</div> >>;
      my_form = <<
        <form id="form" onsubmit="return false">
          <input type="text" name="first" />
          <input type="text" name="last" />
          <input type="submit" value="Submit" />
        </form>
        >>;
    }
    append("#main", replace);
    append("#main", my_form);
    watch("#form", "submit");
  }
  rule respond_submit {
    select when web submit "#form"
    pre {
      first = event:attr("first");
      last = event:attr("last");
      full = first + " " + last;
    }
    fired {
      set ent:first first;
      set ent:last last;
      set ent:full full;
    }
  }
  rule first_rule {
    select when pageview ".*" setting ()
    notify("Hello World", "This is a sample rule.") with sticky = true;
  }
  rule ClearCnt {
    select when pageview ".*"
    if page:url("query").match(re/clear/) then {
      notify("Count is cleared", "") with sticky = true;
    }
    fired {
      clear ent:count;
    }
  }
  rule HelloMonkey {
    select when pageview ".*"
    pre {
       //name = (page:url("query") eq "") => "Monkey" | page:url("query");
       name = (getVal("name") eq "") => "Monkey" | getVal("name");
       // Change ent to app to have this count for the rule set
       count = ent:count;
    }
    if ent:count < 5 then {
      notify("Hello " + name, "Count is " + ent:count) with sticky = true;
    }
    fired {
      ent:count += 1 from 0;
    }
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