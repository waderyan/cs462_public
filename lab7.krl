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
    // https://cs.kobj.net/sky/event/881B7F00-AE35-11E3-8D4F-E906293232C8/1/location/current?_rids=b505194x6


    // Questions:
    // 1) how do I raise this event? - where do I put the above url?
    // 2) why am I getting an http error for this rule set on validation?
  }
  global {
  	dist = function(x1, y1, x2, y2) {
  		r90 = math:pi() / 2;
  		rEk = 6378;

  		rlata = math:deg2rad(x1);
    	rlonga = math:deg2rad(y1);
    	rlatb = math:deg2rad(x2);
    	rlongb = math:deg2rad(y2);

    	// dist between two coordinates in km
    	dE = math:great_circle_distance(rlonga,r90 - rlata, rlongb,r90 - rlatb, rEk);
    	dE;
  	}
  }
  rule nearby {
    select when location current
    pre {
      lata = event:attr("lat");
      longa = event:attr("long");

      v = location_data:get_location_data("fs_checkin");

      latb = v.pick("$..lat");
      longb = v.pick("$..long");

      d = dist(lata, longa, latb, longb);
      threshold = 50; // arbitrarily set
    }
    if (d < threshold) then {
    	notify("hello", "select when location current is within threshold");
    } 
    fired {
    	raise location event nearby for b505194x7 with distance = d;
  	} else {
  		raise location event far for b505194x7 with distance = d;
  	}
  }
}