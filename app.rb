require "dotenv"
require "oauth2"
require "google_drive"
require "pp"

Dotenv.load

def workseet
  client = OAuth2::Client.new(
                  ENV["client_id"],
                  ENV["client_secret"],
                  site: "https://accounts.google.com",
                  token_url: "/o/oauth2/token",
                  authorize_url: "/o/oauth2/auth")
  auth_token = OAuth2::AccessToken.from_hash(client,{:refresh_token => ENV["refresh_token"], :expires_at => 3600})
          auth_token = auth_token.refresh!
  session = GoogleDrive.login_with_oauth(auth_token.token)

  @ws = session.spreadsheet_by_key(ENV["sheet_id"]).worksheets[0]
end

def atend
  puts "[*] Input your student ID"
  @id = gets.chomp!

  case @id
  when "00000000"
    puts "[*] Exit from attendance"
    exit
  end

  @ws.rows.each_with_index do |data, i|
    if data[1].to_s == @id then
      if data[0] == "0" then
        puts "Welcome to the room!"
        @ws[i+1,1] = "1"
        @ws.save
      elsif data[0] == "1" then
        puts "See you again!"
        @ws[i+1,1] = "0"
        @ws.save
      else
        puts "Sorry, unrecognized flag is opened and you are exited from the room."
        @ws[i+1,1] = "0" # Force zero
        @ws.save
      end
    end
  end
end

puts "[*] Access to Google spreadsheet"

workseet

puts "[*] Start attendance"

loop do
  atend
end
