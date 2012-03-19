# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
   @movie = Movie.create!(movie)
  end
end

Then /I should see only movies from ratings: (.*)/ do |ratings|
  @selected_rating = ratings.split(/\W+/)
  @movies = Movie.all
  @movies.each do |movie|
    if @selected_rating.include? movie.rating
      step %Q{I should see "#{movie.title}"}
    else
      step %Q{I should not see "#{movie.title}"}
    end
  end
  all("table#movies/tbody tr").count.should == Movie.where(:rating => @selected_rating).size
end

Then /I should see all of the movies/ do
  @movies = Movie.all
  @movies.each do |movie|
    step %Q{I should see "#{movie.title}"}
  end
  all("table#movies/tbody tr").count.should == @movies.length
  
end

Then /I should see none of the movies/ do
  
  all("table#movies/tbody tr").count.should == 0
  
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Given /I click "(.*)"/ do |sort|
    step %Q{I follow "#{sort}"}
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|

  put page.body =~ /.*#{e1}.*#{e2}.*/
 
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

When /I (un)?check all ratings/ do |uncheck|
  if uncheck
    Movie.all_ratings.each do |rating|
      step %Q{I uncheck "ratings_#{rating}"}
    end    
  else
    Movie.all_ratings.each do |rating|
      step %Q{I check "ratings_#{rating}"}
    end
  end
end
