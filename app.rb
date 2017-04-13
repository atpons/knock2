require "oauth2"
require "google_drive"
require "pp"

  client_id     = "238747854127-mel6m371bghkdd67ni6g636itlehu3gk.apps.googleusercontent.com"
  client_secret = "HRmj9AfPocLbbbZW2H2aikrS"
  refresh_token = "1/byMU-P5EXzA7jK9LA-TEQbXoxITqTwty4wESM_KL2QM"
  client = OAuth2::Client.new(
    client_id,
    client_secret,
    site: "https://accounts.google.com",
    token_url: "/o/oauth2/token",
    authorize_url: "/o/oauth2/auth")
  auth_token = OAuth2::AccessToken.from_hash(client,{:refresh_token => refresh_token, :expires_at => 3600})
  auth_token = auth_token.refresh!
  session = GoogleDrive.login_with_oauth(auth_token.token)
  @ws = session.spreadsheet_by_key("10YdHNhDhykbdtzl2BbmO_Dfa8RgHD9n3mk3OHL-TUOE").worksheets[0]

puts "Please input your student id:"
@id = gets.chomp!

@ws.rows.each_with_index do |data, i|
  if data[1].to_s == @id then
    if data[0] == "0" then
      @ws[i+1,1] = "1"
      @ws.save
    elsif data[0] == "1" then
      @ws[i+1,1] = "0"
      @ws.save
    else
      @ws[i+1,1] = "0" # 強制zero
      @ws.save
    end
  end
end
