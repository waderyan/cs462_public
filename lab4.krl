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
  global {
    api_key = "af5bw6yg28j8auzft5pmk2fn";
    getMovieInfo = function(title) {
      result = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json",{"apikey" : api_key, "q" : title}).pick("$.content").decode(); total = result.pick("$.total").as("num");
      movie = <<
       <img src="#{results.pick("$.movies[0]..thumbnail")}">
       <p><span style="font-weight:bold;">Title</span>: #{results.pick("$.movies[0].title")}</p>
       <p><span style="font-weight:bold;">Release Year</span>: #{results.pick("$.movies[0].year")}</p>
       <p><span style="font-weight:bold;">Synopsis</span>: #{results.pick("$.movies[0].synopsis")}</p>
       <p><span style="font-weight:bold;">Critics Rating</span>: #{results.pick("$.movies[0]..critics_rating")}</p>
      >>;
      
      error = <<
        <p>No results found for #{title}. Please search again.</p>
      >>;
      html = (total > 0) => movie | error;
      html;
    }
  }
  rule Rotten {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <div id="movie_result">
        </div>
        <form id="my_form" onsubmit="return false;">
          <input type="text" name="title" placeholder="title"/>
          <input type="submit" value="Submit" />
        </form>
      >>;

    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Lookup Movie", {}, my_html);
      watch("#my_form","submit");
    }
  }

  rule form_submit {
    select when web submit "#my_form"
    pre {
      movie = event:attr("title");
      results = getMovieInfo(movie);
    }
    {
      replace_inner("#movie_result",results);
    }
  }
}