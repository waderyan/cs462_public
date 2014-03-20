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
    // b505194x3.prod 
    // 31AFDBBA-A3B9-11E3-A94B-E895FCD408FB
    // curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "checkin={'venue':{'name':'test venue', 'location' : {city':'Provo'}}, 'shout':'shouting', 'createdAt':1394122605}&_rids=b505194x3" http://cs.kobj.net/sky/event/31AFDBBA-A3B9-11E3-A94B-E895FCD408FB/1/foursquare/checkin
  }
  global {
    checkinToHtml = function() {
        info = <<
          <div style="margin: 20px">
            <h2>Foursquare Checkin Information</h2>
            <ul>
              <li><span>Venue: #{ent:venue}</span></li>
              <li><span>City: #{ent:city}</span></li>
              <li><span>Shout: #{ent:shout}</span></li>
              <li><span>Created At: #{ent:createdAt}</span></li>
              <li><span>Lat: #{ent:lat}</span></li>
              <li><span>Long: #{ent:long}</span></li>
            </ul>
          </div>
        >>;
        info;
    }
    subscribers = [
      {
        "cid": "34CEC05C-B063-11E3-A4B0-7E9F833561DC"
      },
      {
        "cid": "3D2ED3D6-B063-11E3-85CD-FADFAAD0D405"
      }
    ];
  }
  rule process_fs_checkin {
    select when foursquare checkin
    pre {
      c = event:attr("checkin").decode();
      venue = c.pick("$.venue.name").as("str");
      city = c.pick("$.venue.location.city").as("str");
      shout = c.pick("$.shout").as("str");
      createdAt = c.pick("$.createdAt").as("num");
      lat = c.pick("$.venue.location.lat").as("num"); // check these
      long = c.pick("$.venue.location.lng").as("num"); // check these
    }
    {
      send_directive(venue) with checkin = venue;
      emit <<
          console.log("Rule fired: foursquare checkin")
        >>;
    }
    fired {
        set ent:venue venue;
        set ent:city city;
        set ent:shout shout;
        set ent:createdAt createdAt;
        set ent:lat lat;
        set ent:long long;

        raise explicit event notify_subscribers for b505194x3 with la = lat and lo = long and v = venue;
       // raise explicit event location_cur for b505194x6 with latitude = lat and longitude = long;
        raise pds event new_location_data for b505194x4 with test = venue and key = "fs_checkin" and value = {"venue" : venue, "city": city, "shout": shout, "createdAt" : createdAt, "long" : long, "lat" : lat };
      //  raise pds event new_location_data for b505194x4 with test = venue and key = "fs_checkin" and value = {"venue" : "bob", "city": "bobcity", "shout": "bobshout", "createdAt" : "bobcreatedAt" };
    }
  }
  
  rule dispatcher {
    select when explicit notify_subscribers
      foreach subscribers setting (subscriber)
        event:send(subscriber,"location","notification")
            with attrs = {"lat" : event:attr("la"),
                          "long": event:attr("lo"),
                          "venue": event:attr("v")
                          };
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