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
      thumbnail = movie.pick("$..posters.original");

      tdStyle = "padding: 10px;";
      info = <<
       <img style="float: right; margin-right: 50px; width: 250px; height: 250px;" src="#{thumbnail}">
       <div style="margin: 20px; padding: 10px;">
         <table style="border: none;">
            <tr>
                <td style="#{tdStyle}"><span>Title</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.title")}</span></td>
            </tr>
             <tr>
                <td style="#{tdStyle}"><span>Release Year</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.year")}</span></td>
            </tr>
             <tr>
                <td style="#{tdStyle}"><span>MPAA Rating</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.mpaa_rating")}</span></td>
            </tr>
             <tr>
                <td style="#{tdStyle}"><span>Runtime</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.runtime")}</span></td>
            </tr>
            <tr>
                <td style="#{tdStyle}"><span>Critics Rating</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.ratings.critics_rating")}</span></td>
            </tr>
             <tr>
                <td style="#{tdStyle}"><span>Audience Rating</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.ratings.audience_rating")}</span></td>
            </tr>
             <tr>
                <td style="#{tdStyle}"><span>Critics Score</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.ratings.critics_score")}</span></td>
            </tr>
             <tr>
                <td style="#{tdStyle}"><span>Audience Score</span></td>
                <td style="#{tdStyle}"><span>#{movie.pick("$.ratings.audience_score")}</span></td>
            </tr>
         </table>
         <p><span>Synopsis</span>: #{movie.pick("$.synopsis")}</p>
       </div>
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
        <div id="movie">
        </div>
        <form style="margin: 20px;" id="movie_form" onsubmit="return false;">
          <fieldset>
            <input type="text" name="title" placeholder="Movie Title"/>
          </fieldset>
          <fieldset>
            <input type="submit" value="Search" />
          </fieldset>
        </form>
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