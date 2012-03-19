# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
   @movie = Movie.new(movie)
   puts @movie.title
  end
end

Then /I should see only movies from ratings: (.*)/ do |ratings|
  @selected_rating = ratings.split(/\W+/)
  @movies = Movie.all
  @movies.each do |movie|
    if @selected_rating.include? movie.rating
      setp %Q{I should see "#{movie.title}"}
    else
      setp %Q{I should not see "#{movie.title}"}
    end
  end
  Movie.where(:rating => @selected_rating).size.should == all("table#movies tr").count  
end
#
#Then /I should see all of the movies/
#  @movies = Movie.all
#  @movies.each do |movie|
#    setp %Q{I should see "#{movie.title}"}
#  end
#end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert false, "Unimplmemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  
  ratings = rating_list.split(/\W+/)
  ratings.each do |rating|
     step %Q{I check "ratings_#{rating}"}
   end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end
