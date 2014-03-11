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
    get_location_data = function(key) {
      // res = ent:mymap(key);
      // res;
      // "I am in get_location_data";
      ent:myname;
    }
  }
  rule add_location_item {
    select when pds new_location_data
    pre {
      name = event:attr("test");
    //  newmap = ent:mymap || {};
    //  k = event:attr("key");
    //  v = event:attr("value");
    //  newmap = newmap.put([k],v);
    }
    //send_directive(k) with location = v;
    always {
      //  set ent:mymap newmap;
      set ent:myname name;
    }
  }
}