class MoviesController < ApplicationController
  helper_method :hilight
  helper_method :selected_rating?
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    session[:sort] = params[:sort] unless  params[:sort].nil?
    
    
    
    
    if !params[:ratings].nil? || !params[:sort].nil?
      if !params[:ratings].nil?
        array_ratings = params[:ratings].keys
        return @movies = Movie.where(rating: array_ratings).order(session[:sort])
      else
        return @movies = Movie.all.order(session[:sort])
      end
    else
      return @movies = Movie.all
    end
    
    if(!session[:ratings].nil? || !session[:sort].nil?)
      redirect_to movies_path("ratings" =>session[:ratings], "order" => session[:sort] )
    end 
  end
 
    

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
 def hilight(column)
   
    if(session[:sort] == column)
      return 'hilite'
    else
      return nil
    end
 end
 
  def selected_rating?(rating)
    selected_rating = session[:ratings]
    return true if selected_rating.nil?
    selected_rating.include? rating
  end

end
