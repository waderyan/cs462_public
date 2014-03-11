ruleset examine_location {
  meta {
    name "examine_location"
    description <<
      examine_location
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
    use module b505194x4 alias location_data
  }
  global {
    checkinToHtml = function(v) {

        info = <<
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{v.pick("$..venue")}</span></li>
              <li><span>City: #{v.pick("$..city")}</span></li>
              <li><span>Shout: #{v.pick("$..shout")}</span></li>
              <li><span>Created At: #{v.pick("$..createdAt")}</span></li>
            </ul>
          </div>
        >>;
        info;
    }
  }
  rule show_fs_location {
    // TODO not sure if this is right
    select when web cloudAppSelected
    {
        SquareTag:inject_styling();
       // notify("LOCATION_DATA", location_data:get_location_data("fs_checkin").as("str"));
        notify("TEST_DATA", location_data:get_test());
        notify("STATIC_DATA", location_data:get_something_static());
        CloudRain:createLoadPanel("Inspector", {}, checkinToHtml(location_data:get_location_data("fs_checkin")));       
        emit <<
          console.log("show_fs_location")
        >>;
    }
  }
}