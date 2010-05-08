require "#{File.dirname(__FILE__)}/../Base"
require "#{File.dirname(__FILE__)}/Snake"
require "#{File.dirname(__FILE__)}/CLI"

session = BoardGames::Snake::CLI.new
session.run!
