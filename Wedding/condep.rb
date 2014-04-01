require 'pp'
require 'HTTParty'
require 'leftronic'
require 'rubygems'
require 'action_view'

## THESE ARE MY NOTES, WITHOUT THEM I AM USELESS, WITHOUT MY NOTES, I AM USELESS ##
=begin
 my access key 5b0103a2a9ba639b279b48a08d3634c4f38cb30b
go = most_recent_commit['commit']
 go['author']
=end
##########################THOSE WERE MY NOTES #####################################


class DateHelper
include  ActionView::Helpers::DateHelper
end

class ContinuousDeploy
  def initialize
  end

  def iterate_hash(hash, i_want)
    @i_want = i_want
    hash.each_pair do |k,v|
      if 	hash.has_key?("#{i_want}")
        puts "Key... #{k}"
        puts  "value... #{v}"
      elsif	v.is_a?(Hash)
        iterate_hash(v, @i_want)
      else
        puts "#{k} is the key ..... ... .... #{v} is the value"
      end
    end
  end


  def self.time_dif(date_time_of_commit)
    current_time = Time.now.utc.iso8601
    current_time = Time.parse(current_time)
    commit_time = Time.parse("#{date_time_of_commit}")

  h = DateHelper.new
  h.distance_of_time_in_words current_time, commit_time
  end

  def self.get_failures
    res = HTTParty.get('http://puppet-dashboard.aus1.homeaway.live:3000/nodes/failed')
    jon = res.match(/<a href=\"\/nodes\/failed\">*[1-9].+?<\/a>/).to_s.scan(/[1-9]/).join
  end

  def update_failed(branch)
    @branch = branch
    update_failed = Leftronic.new("password").number("Num Failed",ContinuousDeploy.get_failures)



    auth = {:username => 'sclayton', :password => 'password' }

    pp git_res = HTTParty.get("http://github.enterpriseurl.com/api/v3/repos/operations/puppet-modules/commits/#{@branch}", :basic_auth => auth)
    git_res['commit']

    most_recent_commit = git_res
    name = most_recent_commit["commit"]["author"]["name"]
    date_time_of_commit = most_recent_commit["commit"]["author"]["date"]
    message = most_recent_commit ["commit"]["message"]


    pp update = Leftronic.new("password").list("#{@branch}",["Last Commit Was","#{ContinuousDeploy.time_dif(date_time_of_commit)}  ago","Commited By", "#{name}", "Commit Notes", "#{message}" ])
  end


  def master_to_dev
    current_time = Time.now.utc
    five_minutes_ago = (Time.now - 300).utc.iso8601
    two_hours_ago  = (Time.now - 7200).utc.iso8601
    @yesterday = (Time.now - 86400).utc.iso8601

    auth = {:username => 'sclayton', :password => 'password' }

     git_res = HTTParty.get("http://github.enterpriseurl.com/api/v3/repos/sclayton/puppet-modules/commits?since=#{@yesterday}/master", :basic_auth => auth)


    gist = git_res.to_a
    @shas ||= Array.new
    gist.each do |h|
      most_recent_commit_time = Time.parse(h["commit"]["author"]["date"])
      difference_in_time = ((current_time - most_recent_commit_time) / 60).round
      if difference_in_time > 5
        @shas.push h['sha']
      end

    end
  @most_recent_sha = @shas[0]

  @shas.each do |x|



    master_to_dev = HTTParty.post('http://github.enterpriseurl.com/api/v3/repos/sclayton/puppet-modules/merges', :basic_auth => auth, :headers=>{'Content-Type' => "application/json"},
                                  :body => {
                                      "base" => "dev",
                                      'head'=>"#{x}"}.to_json)
  pp master_to_dev
  end

  end

  def dev_to_stage
    current_time = Time.now.utc
    five_minutes_ago = (Time.now - 300).utc.iso8601
    two_hours_ago  = (Time.now - 7200).utc.iso8601
    @yesterday = (Time.now - 86400).utc.iso8601

    auth = {:username => 'sclayton', :password => 'password' }

    git_res = HTTParty.get("http://github.enterpriseurl.com/api/v3/repos/sclayton/puppet-modules/commits?since=#{@yesterday}/dev", :basic_auth => auth)


    gist = git_res.to_a
    @shas ||= Array.new
    gist.each do |h|
      most_recent_commit_time = Time.parse(h["commit"]["author"]["date"])
      difference_in_time = ((current_time - most_recent_commit_time) / 60).round
      if difference_in_time > 120
        @shas.push h['sha']
      end

    end
    @most_recent_sha = @shas[0]
    @shas.each do |x|

      dev_to_stage = HTTParty.post('http://github.enterpriseurl.com/api/v3/repos/sclayton/puppet-modules/merges', :basic_auth => auth, :headers=>{'Content-Type' => "application/json"},
                                    :body => {
                                        "base" => "stage",
                                     'head'=>"#{x}"}.to_json)
    pp dev_to_stage
  end
  end
end

h = ContinuousDeploy.new
if ARGV[0] == 'to_dev'
h.master_to_dev
h.update_failed('dev')

elsif ARGV[0] == 'to_stage'
h.dev_to_stage
h.update_failed('stage')
end



