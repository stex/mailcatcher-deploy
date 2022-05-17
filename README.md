# mailcatcher-deploy

**DEPRECATED and ARCHIVED** since this is no longer how it should be done. Use a docker image (preferably mailhog) instead!

A simple deploy script to install the necessary gems and run mailcatcher on your server.

## Usage

First, install the necessary gems locally:

    $ bundle install
    
Now, create a `.env` file with the correct deploy values for your configuration.
You can use `.env.example` as a template.

Afterwards, setup the deploy folders

    $ mina setup
    
Now, deploy and install the necessary gems

    $ mina deploy
    
If everything went well, you can now start mailcatcher

    $ mina mailcatcher:start
