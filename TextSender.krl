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
  }
  rule send_location {
    select when location nearby
    pre {
      myphone = "+8018651729";
      d = event:attr("distance");
    }
    {
      twilio:sms("The distance is " + d);
    }
  }
}