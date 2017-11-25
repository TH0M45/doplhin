require 'uri'
require 'net/http'
require 'json'

class AppController < ApplicationController

  def index

  end

  def new
  end

  def show
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  #CHECK
  def get_assets
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset?columns=ASSET_DATABASE_ID&columns=LABEL&columns=TYPE&columns=LAST_CLOSE_VALUE_IN_CURR&columns=CURRENCY&date=2012-01-01&TYPE=STOCK&CURRENCY=USD")
    @asset = JSON.parse get(url).read_body
  end

  #CHECK
  def create_portfolio_asset(id, quantity)
    asset = {"asset" => {"asset" => id, "quantity" => quantity}}
    return asset
  end

  #CHECK
  def get_portfolio
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/572/dyn_amount_compo")
    @g_Portfolio = JSON.parse get(url).read_body
  end

  #CHECK
  def generate_portfolio(tab_asset)
    # tab_asset ==> tableau de la forme [[id, nb], [id, nb], [id, nb], [id, nb], [id, nb]]
    tab = []
    tab_asset.each do |t|
      tab.push create_portfolio_asset(t[0], t[1])
    end
    p_body = {"2012-01-01" => tab}
    p_header = {"label" => "PORTFOLIO_USER8", "currency" => {"code" => "EUR"}, "type" => "front", "values" => p_body}
    #put_portfolio(p_header)
  end


  def put_portfolio(portfolio)
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/572/dyn_amount_compo")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Put.new(url)
    request.basic_auth 'epita_user_8', 'dolphin61357'
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '10a3570e-f9a2-afe4-18bb-4d31536b4439'
    request.body = portfolio.to_json
    response = http.request(request)
    puts response.read_body
  end



  def get(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request.basic_auth 'epita_user_8', 'dolphin61357'
    request["cache-control"] = 'no-cache'
    #request["postman-token"] = 'fe1f347c-c612-2217-4f90-ef8db466bdb1'

    return response = http.request(request)
  end


  #CHECK
  def iterate_asset(t)
    asset_tab = []
    t.each do |asset|
      value = []
      value.push(asset["ASSET_DATABASE_ID"]["value"])
      value.push((asset["LAST_CLOSE_VALUE_IN_CURR"]["value"]).sub(",",".")to_f)
      asset_tab.push(asset["ASSET_DATABASE_ID"]["value"].to_i)
    end

    h_sharpe = get_ratio_in_hash(20, tab)
    h_rend = get_ratio_in_hash(21, tab)
    h_vol = get_ratio_in_hash(18, tab)

    #tt = tt.sort_by {|k,v| v}
    #tt = tt.reverse[0,21]
    tt.each do |tabb|
      url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset/#{tabb[0].to_i}?columns=LAST_CLOSE_VALUE_IN_CURR")
      tabb.insert(2, (JSON.parse get(url).read_body)["LAST_CLOSE_VALUE_IN_CURR"]["value"].sub(",",".").to_f)
      tabb.insert(3, (500000/tabb[2]).to_i)
    end

    # 500 000€

  end

  def get_ratio_in_hash(id_ratio, asset_tab)
    h = {}
    tab = JSON.parse get_ratio([id_ratio], asset_tab, [])
    tab.keys.each do |v|
        h[v] = tab[v][id_ratio.to_s]["value"].sub(",",".").to_f
    end
    return h
  end

  def iterate_portfolio(p)
    p["values"]["2012-01-01"].each do |asset|
      # ID = ["asset"]["asset"]
      # quantity = ["asset"]["quantity"]
    end

  end

  #CHECK
  def get_ratio(ratio, asset, bench)
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/ratio/invoke")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request.basic_auth 'epita_user_8', 'dolphin61357'
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '1ba6f74d-e67d-0ced-e00c-b6d0a0ff990d'
    b = "null"
    if bench != []
      b = bench
    end
    h = {"ratio" => ratio, "asset" => asset, "bench" => b, "startDate" => "2012-01-01", "endDate" => "2017-01-01", "frequency" => "null"}
    request.body = h.to_json

    response = http.request(request)
    return response.read_body
  end

  def eval_portfolio
    return JSON.parse get_ratio([20], [572], [])
  end

end
