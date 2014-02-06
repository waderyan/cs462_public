ruleset notifyTest {
  meta {
    name "Notify Test
    description <<
      NotifyTest
    >>
    author ""
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
    notify("Hello World 1", "This is a sample rule.") with sticky = true;
  }
  rule second_rule {
    select when pageview ".*" setting ()
    notify("Hello World 2", "This is a sample rule.") with sticky = true;
  }
}