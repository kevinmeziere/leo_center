require "open-uri"
require "json"

module GrowthForecast
  class Client
    def initialize(host, port)
      @host = host.freeze
      @port = port
      @base_uri = "http://#{@host}:#{@port}/".freeze
    end

    attr_reader :host, :port

    def export(service_name, section_name, graph, opt=nil)
      path = "xport/#{service_name}/#{section_name}/#{graph}"
      if opt && opt.is_a?(Hash)
        path.concat("?")
        param_str = opt.map {|k, v| "#{k}=#{v}" }.join("&")
        path.concat(param_str)
      end
      return request(path)
    end
    
    private

    JSON_OPTS = { symbolize_names: true }.freeze

    def request(path)
      path = URI.encode(path)
      uri = URI.join(@base_uri, path)
      json = OpenURI.open_uri(uri).read
      return JSON.parse(json, JSON_OPTS)
    end
  end
end

GF = GrowthForecast # alias