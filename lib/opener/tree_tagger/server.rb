require 'sinatra/base'
require 'httpclient'
require 'opener/webservice'

module Opener
  class TreeTagger
    ##
    # Polarity tagger server powered by Sinatra.
    #
    class Server < Webservice
      set :views, File.expand_path('../views', __FILE__)
      text_processor TreeTagger
      accepted_params :input
    end # Server
  end # PolarityTagger
end # Opener
