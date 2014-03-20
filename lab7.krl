ruleset lab7 {
  meta {
    name "Lab 7"
    description <<
      Labv7
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
    use module b505194x4 alias location_data
    // ID:881B7F00-AE35-11E3-8D4F-E906293232C8
    // b505194x6.prod
    // curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "lat=40.2503479550969&long=-111.652357578278&_rids=b505194x6" https://cs.kobj.net/sky/event/881B7F00-AE35-11E3-8D4F-E906293232C8/1/location/cur
    // 
    // https://cs.kobj.net/sky/event/881B7F00-AE35-11E3-8D4F-E906293232C8/1/location/cur?_rids=b505194x6

    // Questions:
    // 1) how do I raise this event? - where do I put the above url?
    // 2) how to do an if else?
  }
  global {
  	dist = function(xa, ya, xb, yb) {
  		r90 = math:pi() / 2;
  		rEk = 6378;

  		rlata = math:deg2rad(xa);
    	rlonga = math:deg2rad(ya);
    	rlatb = math:deg2rad(xb);
    	rlongb = math:deg2rad(yb);

    	// dist between two coordinates in km
    	dE = math:great_circle_distance(rlonga,r90 - rlata, rlongb,r90 - rlatb, rEk);
    	dE;
  	}
    display = function() {
      info = <<
          <div style="margin: 20px">
            <h2>Lab 7</h2>
            <ul>
              <li><span>distance: #{ent:dist}</span></li>
              <li><span>state: #{ent:state}</span></li>
              <li><span>lata: #{ent:lata}</span></li>
              <li><span>longa: #{ent:longa}</span></li>
              <li><span>latb: #{ent:latb}</span></li>
              <li><span>longb: #{ent:longb}</span></li>
            </ul>
          </div>
        >>;
        info;
    }
  }
  rule nearby {
    select when location cur
    pre {
      lata = event:attr("lat").as("num");
      longa = event:attr("long").as("num");

      v = location_data:get_location_data("fs_checkin");

      latb = v.pick("$..lat").as("num");
      longb = v.pick("$..long").as("num");

      d = dist(lata, longa, latb, longb);
      threshold = 50; // arbitrarily set
    }
    if (d < threshold) then {
      send_directive("nearby") with distance = d;
      emit <<
          console.log("Rule fired: location cur")
      >>;
    } 
    fired {
      set ent:lata lata;
      set ent:longa longa;
      set ent:latb latb;
      set ent:longb longb;
      set ent:dist d;
      set ent:state "near";
      raise explicit event location_nearby for b505194x7 with distance = d;
    } else {
      set ent:lata lata;
      set ent:longa longa;
      set ent:latb latb;
      set ent:longb longb;
      set ent:dist d;
      set ent:state "far";
      raise explicit event location_far for b505194x7 with distance = d;
    }
  }
  rule display {
     select when web cloudAppSelected
    {
        SquareTag:inject_styling();
        CloudRain:createLoadPanel("Lab 7", {}, display());       
        emit <<
          console.log("cloud App selected")
        >>;
    }
  }
}