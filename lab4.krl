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

    movieToHtml = function(movie) {
      info = <<
       <img src="#{movie.pick($.posters.thumbnail}">
       <p><span>Title</span>: #{movie.pick("$.title")}</p>
       <p><span>Release Year</span>: #{movie.pick("$.year")}</p>
       <p><span>MPAA Rating</span>: #{movie.pick("$.mpaa_rating")}</p>
       <p><span>Synopsis</span>: #{movie.pick("$.synopsis")}</p>
       <h3>Ratings</h3>
       <p><span>Critics Rating</span>: #{movie.pick("$.ratings.critics_rating")}</p>
       <p><span>Audience Rating</span>: #{movie.pick("$.ratings.audience_rating")}</p>
       <p><span>Critics Score</span>: #{movie.pick("$.ratings.critics_score")}</p>
       <p><span>Audience Score</span>: #{movie.pick("$.ratings.audience_score")}</p>
      >>;
      info;
    }

    getMovieInfo = function(title) {
      result = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json",
        {
          "apikey" : api_key, 
          "q" : title
        }
      ).pick("$.content").decode(); 
      
      noresult = << 
        <p>No results for #{title}. Please try again</p> 
      >>;
      ret = (result.pick("$.total").as("num") > 0) => movieToHtml(result.pick("$.movies[0]")) | noresult;
      ret;
    }
  }
  rule Rotten {
    select when web cloudAppSelected
    pre {
      html = <<
        <form id="movie_form" onsubmit="return false;">
          <legend>Movie Search</legend>
          <fieldset>
            <input type="text" name="title" placeholder="title"/>
            <input type="submit" value="Submit" />
          </fieldset>
        </form>
        <div id="movie">
        </div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Lookup Movie", {}, html);
      watch("#movie_form","submit");
    }
  }

  rule form_submit {
    select when web submit "#movie_form"
    pre {
      results = getMovieInfo(event:attr("title"));
    }
    {
      replace_inner("#movie",results);
    }
  }
}