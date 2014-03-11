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
      v2 = {"venue" : "fredvenue", "city": "fredcity", "shout": "fredshout", "createdAt" : "fredcreatedAt" };

      venue = v.pick("$.venue");
      city = v.pick("$.city");
      shout = v.pick("$.shout");
      createdAt = v.pick("$.createdAt");
        info = <<
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{v{"venue"}}</span></li>
              <li><span>City: #{v{"city"}}</span></li>
              <li><span>Shout: #{v{"shout"}}</span></li>
              <li><span>Created At: #{v{"createdAt"}}</span></li>
            </ul>
          </div>
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{venue}</span></li>
              <li><span>City: #{city}</span></li>
              <li><span>Shout: #{shout}</span></li>
              <li><span>Created At: #{createdAt}</span></li>
            </ul>
          </div>
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{v.pick("$..venue")}</span></li>
              <li><span>City: #{v.pick("$..city")}</span></li>
              <li><span>Shout: #{v.pick("$..shout")}</span></li>
              <li><span>Created At: #{v.pick("$..createdAt")}</span></li>
            </ul>
          </div>
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{v2.pick("$..venue")}</span></li>
              <li><span>City: #{v2.pick("$..city")}</span></li>
              <li><span>Shout: #{v2.pick("$..shout")}</span></li>
              <li><span>Created At: #{v2.pick("$..createdAt")}</span></li>
            </ul>
          </div>
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{v2{"venue"}}</span></li>
              <li><span>City: #{v2{"city"}}</span></li>
              <li><span>Shout: #{v2{"shout"}}</span></li>
              <li><span>Created At: #{v2{"createdAt"}}</span></li>
            </ul>
          </div>
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{v2.pick("$.venue")}</span></li>
              <li><span>City: #{v2.pick("$.city")}</span></li>
              <li><span>Shout: #{v2.pick("$.shout")}</span></li>
              <li><span>Created At: #{v2.pick("$.createdAt")}</span></li>
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