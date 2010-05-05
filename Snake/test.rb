require '~/Code/Ruby/BoardGames/Base'
require '~/Code/Ruby/BoardGames/Snake/Snake'

session1 = BoardGames::Snake::Session.new(40, 20)
session1.run
