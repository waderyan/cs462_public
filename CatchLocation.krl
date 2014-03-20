ruleset CatchLocation {
  meta {
    name "Location Catcher"
    description <<
      phonesender
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag

  }
  global {
    display = function() {
      info = <<
          <div style="margin: 20px">
            <h2>Location Catcher</h2>
            <ul>
              <li><span>lat: #{ent:lat}</span></li>
              <li><span>long: #{ent:long}</span></li>
              <li><span>venue: #{ent:venue}</span></li>
            </ul>
          </div>
        >>;
        info;
    }
  }
  rule location_catch {
    select when location notification
    pre {
      lat = event:attr("lat");
      long = event:attr("long");
      venue = event:attr("venue");
    }
    send_directive(venue) with checkin = venue;
    fired {
      set ent:lat lat;
      set ent:long long;
      set ent:venue venue;
    }
  }
  rule display {
     select when web cloudAppSelected
    {
        SquareTag:inject_styling();
        CloudRain:createLoadPanel("Location Catcher", {}, display());       
        emit <<
          console.log("cloud App selected")
        >>;
    }
  }
}