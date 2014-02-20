ruleset Lab4App {
  meta {
    name "Lab4"
    description <<
      Lab4
    >>
    author "Wade Anderson"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186 alias SquareTag
  }
  dispatch {

  }
  global {
    api_key = "af5bw6yg28j8auzft5pmk2fn";
    movies = function() {
      result = http:get("http://api.rottentomatoes.com/api/public/v1.0.json", {"apikey" : api_key});
      body = result.pick("$.content");
      body
    }
  }
  rule obtain_rating {
    select when pageview url re#imbd# and pageview url re#/title/tt\d+# setting (movie_id)
    {
      notify("Movie", movie_id);
    }
  }
}