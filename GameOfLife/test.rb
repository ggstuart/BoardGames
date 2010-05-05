require '~/Code/Ruby/BoardGames/Base'
require '~/Code/Ruby/BoardGames/GameOfLife/GameOfLife'
require '~/Code/Ruby/BoardGames/GameOfLife/CLI'

cli = BoardGames::GameOfLife::CLI.new
cli.run!
