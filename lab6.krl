ruleset location_data {
  meta {
    name "Lab 6"
    description <<
      Labv6
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
    provides get_location_data
  }
  global {
    set app:mymap = {};
    get_location_data = function(key) {
      res = app:mymap(key);
      res;
    }
  }
  rule add_location_item {
    select when pds new_location_data
    pre {
      k = event:attr("key")
      v = event:attr("value")
    }
    {
      send_directive(k) with location = v
      emit <<
          console.log("add_location_item")
        >>;
    }
    fired {
        app:mymap.put({k, v});
    }
  }
}