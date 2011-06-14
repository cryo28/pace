# Pace (and EventMachine) works best when your job can block
# on a socket and proceed to process jobs (almost) concurrently.
#
# A good explanation can be found here:
#   http://www.igvita.com/2008/05/27/ruby-eventmachine-the-speed-demon/

require "pace"

puts "Waiting for jobs..."

Pace.start(ENV["QUEUE"] || "normal") do |job|
  start_time = Time.now

  http = EM::Protocols::HttpClient.request(
    :host    => "www.google.com",
    :port    => 80,
    :request => "/"
  )
  http.callback do |r|
    Pace.log(job.inspect, start_time)
  end
end
