require 'sinatra'

ips = ['54.207.38.79', '13.53.173.17']

get '/hello/:name' do
  name = params['name']

  region = `curl http://localhost/region`

  string = "Hello #{name}!"

  stops = `curl http://localhost/regions/`
  string += " I went to #{stops}."
  
  return string
end

get '/region' do
  host = `curl http://169.254.169.254/latest/meta-data/hostname`

  region = host.split('.')[1]

  return region
end

get '/regions/:past?' do
  stops = params['past'].split(',') if params['past']
  stops ||= []

  region = `curl http://localhost/region`

  stops << region

  if stops.size < 2
    ip = ips.sample

    hops = `curl http://#{ip}/regions/#{stops.join ','}`
  end

  hops ||= stops.join ','
end
