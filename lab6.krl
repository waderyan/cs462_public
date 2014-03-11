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
    provides get_location_data, get_something_static, get_test
  }
  global {
    get_location_data = function(k) {
      res = app:mymap.values([k]) || "map not set";
      res;
    }

    get_something_static = function() {
      "something_static";
    }

    get_test = function() {
      res = app:myname || "name not set";
      res;
    }
  }
  rule add_location_item {
    select when pds new_location_data
    pre {
      name = event:attr("test");
      // newmap = app:mymap || {};
     
      k = event:attr("key");
      val = event:attr("value");
      newmap = ({}.put([k], val));
    }
    //send_directive(k) with location = val;
    always {
        set app:mymap newmap;
        set app:myname name;
    }
  }
}