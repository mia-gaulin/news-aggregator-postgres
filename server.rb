require 'sinatra'
require 'pg'
require 'pry'
require_relative "./app/models/article"

set :views, File.join(File.dirname(__FILE__), "app", "views")

configure :development do
  set :db_config, { dbname: "news_aggregator_development" }
end

configure :test do
  set :db_config, { dbname: "news_aggregator_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

get '/' do
  redirect '/articles'
end

get '/articles' do
  @articles = Article.all

  erb :index
end

get '/articles/new' do
  erb :new_index
end

post '/articles' do
  article = Article.new("title" => params[:article_title], "url" => params[:article_url], "description" => params[:article_description])

  if article.valid?
    article.save
    redirect '/articles'
  end
  if
    @errors = "Please completely fill out form"
    erb :new_index
  elsif
    @errors = "Invalid URL"
    erb :new_index
  end
end
