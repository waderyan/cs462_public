ruleset foursquare {
  meta {
    name "Lab 5"
    description <<
      Labv5
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
  }
  global {
    checkinToHtml = function() {
        info = <<
          <div>
            <h2>Foursquare Checkin Information</h2>
            <ul>
              <li><span>Venue: #{ent:venue}</span></li>
              <li><span>City: #{ent:city}</span></li>
              <li><span>Shout: #{ent:shout}</span></li>
              <li><span>Created At: #{ent:createdAt}</span></li>
            </ul>
          </div>
        >>;
        info;
    }
  }
  rule process_fs_checkin {
    select when foursquare checkin
    pre {
      c = event:attr("checkin").decode();
      venue = c.pick("$.venue.name").as("str");
      city = c.pick("$.venue.location.city").as("str");
      shout = c.pick("$.shout").as("str");
      createdAt = c.pick("$.createdAt").as("num");
    }
    {
      emit <<
          console.log("foursquare checkin")
        >>;
    }
    fired {
        set ent:venue venue;
        set ent:city city;
        set ent:shout shout;
        set ent:createdAt createdAt;
    }
  }

  rule display_checkin {
    select when web cloudAppSelected
    {
        SquareTag:inject_styling();
        CloudRain:createLoadPanel("Foursquare Checkin Information", {}, checkinToHtml());       
        emit <<
          console.log("cloud App selected")
        >>;
    }
  }
}