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
    // TODO module key
    use module b505194x4 alias location_data
  }
  global {
    checkinToHtml = function(val) {
        info = <<
          <div style="margin: 20px">
            <h2>Examine Checkin Information</h2>
            <ul>
              <li><span>Venue: #{val("fs_checkin")}</span></li>
              <li><span>City: #{val("fs_checkin")}</span></li>
              <li><span>Shout: #{val("fs_checkin")}</span></li>
              <li><span>Created At: #{val("fs_checkin")}</span></li>
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
        notify("hello", location_data:get_location_data("fs_checkin"));
        CloudRain:createLoadPanel("Examine Checkin Information", {}, checkinToHtml(location_data:get_location_data("fs_checkin")));       
        emit <<
          console.log("show_fs_location")
        >>;
    }
  }
}