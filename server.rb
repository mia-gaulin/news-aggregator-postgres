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

ARTICLE_FILE = 'articles.csv'

get '/' do
  redirect '/articles'
end

get '/articles' do
  'Hello world'
  # @articles = File.readlines('articles.csv')
  erb :index
end

get '/articles/new' do
  erb :new_index
end

post '/articles/new' do
  # add_article(params)

  redirect '/articles'
end

def add_article(params)
  article = [params[:title], params[:url], params[:description]]
  CSV.open(ARTICLE_FILE, 'a') do |file|
    file << article
  end
end
