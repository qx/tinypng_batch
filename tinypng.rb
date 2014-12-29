#!/usr/bin/env ruby
require "net/https"
require "uri"
require "thread"
class Tinypng


  @@filepath=""

  def getpath
    puts(Dir.pwd)
    @@filepath=Dir.pwd


  end


  def getFiles
    Dir.glob(@@filepath+'/*.jpg') do |rb_file|
      # do work on files ending in .rb in the desired directory
      Thread.new do
        puts rb_file
        compress rb_file
      end
      sleep 3

    end
    puts 'ready to compress png'
    Dir.glob(@@filepath+'/*.png') do |rb_file|
      # do work on files ending in .rb in the desired directory
      Thread.new do
        puts rb_file
        compress rb_file
      end
      sleep 3
    end
  end

  def compress file

    key = "ENTER YOUR API KEY"
    input = file
    output = file

    uri = URI.parse("https://api.tinypng.com/shrink")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Uncomment below if you have trouble validating our SSL certificate.
    # Download cacert.pem from: http://curl.haxx.se/ca/cacert.pem
    # http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")

    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth("api", key)

    response = http.request(request, File.binread(input))
    if response.code == "201"
      # Compression was successful, retrieve output from Location header.
      puts "Compression success "+file
      File.binwrite(output, http.get(response["location"]).body)
    else
      # Something went wrong! You can parse the JSON body for details.
      puts "Compression failed "+file +' recompress'
      sleep 3
      Thread.new do
        compress file
      end

    end

  end

  if __FILE__ == $0
    su=Tinypng.new
    su.getpath
    su.getFiles
  end
end
