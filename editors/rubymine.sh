brew install --quiet --cask rubymine

dockutil --add  '/Applications/RubyMine.app' --replacing 'RubyMine' --after 'Visual Studio Code' &> /dev/null

# TO AUTOMATE: Install plugins.
#       Key Promoter X
#       Rainbow Brackets
#       Enable rainbow variables
