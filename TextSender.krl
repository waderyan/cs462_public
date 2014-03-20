ruleset TextSender {
  meta {
    name "Phone Sender"
    description <<
      phonesender
    >>
    key twilio {"account_sid" : "AC424049b8589671bff69d5a0d74b60e17",
                "auth_token"  : "dee94754596f9183fec3adcc1a37a785"
    }
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
    // ID:881B7F00-AE35-11E3-8D4F-E906293232C8
    // ACe8a279d1160fe29c824714cdec5605a5
    // b5cecc690e6b23d016dbc6977ece774d
    // b505194x7.prod
         
    use module a8x115 alias twilio with twiliokeys = keys:twilio()
  }
  global {
    display = function() {
      info = <<
          <div style="margin: 20px">
            <h2>Text Sender</h2>
            <ul>
              <li><span>distance: #{ent:distance}</span></li>
              <li><span>state: #{ent:state}</span></li>
            </ul>
          </div>
        >>;
        info;
    }
  }
  rule send_location {
    select when explicit location_nearby
    pre {
      d = event:attr("distance");
    }
    twilio:send_sms('8018651729', '3852357279', "distance " + d.as("str"));
    fired {
      set ent:state "close";
      set ent:distance d;
    }
  }
  rule too_far {
    select when explicit location_far
    pre {
      tonumber = "8018651729";
      fromnumber = "3852357279";
      d = event:attr("distance");
    }
    twilio:send_sms(tonumber, fromnumber, "too far");
    fired {
      set ent:state "far";
      set ent:distance d;
    }
  }
  rule display {
     select when web cloudAppSelected
    {
        SquareTag:inject_styling();
        CloudRain:createLoadPanel("Text Sender", {}, display());       
        emit <<
          console.log("cloud App selected")
        >>;
    }
  }
}