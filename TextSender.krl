ruleset TextSender {
  meta {
    name "Phone Sender"
    description <<
      phonesender
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
    // ID:881B7F00-AE35-11E3-8D4F-E906293232C8
    key twilio {"account_sid" : “ACe8a279d1160fe29c824714cdec5605a5",
                "auth_token"  : “b5cecc690e6b23d016dbc6977ece774d"
    }
         
    use module a8x115 alias twilio with twiliokeys = keys:twilio()
  }
  rule send_location {
    select when location nearby
    pre {
      tonumber = "+18018651729";
      fromnumber = "+13852357279";
      d = event:attr("distance");
    }
    {
      twilio:send_sms(tonumber, fromnumber, "distance " + d);
    }
  }
}