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
    // curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "value={'venue':{'name':'test venue', 'location' : {city':'Provo'}}, 'shout':'shouting', 'createdAt':1394122605}&_rids=b505194x6" https://cs.kobj.net/sky/event/881B7F00-AE35-11E3-8D4F-E906293232C8/1/location/current
    // 
    // https://cs.kobj.net/sky/event/881B7F00-AE35-11E3-8D4F-E906293232C8/1/location/current?_rids=b505194x6

    // Questions:
    // 1) how do I raise this event? - where do I put the above url?
    // 2) why am I getting an http error for this rule set on validation?
    // 3) is this how to do an if - else?
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
  }
  rule nearby {
    select when location cur
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