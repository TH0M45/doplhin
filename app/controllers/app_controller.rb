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
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset?columns=ASSET_DATABASE_ID&columns=LABEL&columns=TYPE&columns=LAST_CLOSE_VALUE_IN_CURR&columns=CURRENCY&date=2012-01-01&TYPE=STOCK&TYPE=FUND&CURRENCY=EUR")
    init_asset = JSON.parse get(url).read_body
  end

  #CHECK
  def create_portfolio_asset(id, quantity)
    asset = {"asset" => {"asset" => id, "quantity" => quantity}}
    return asset
  end

  #CHECK
  def get_portfolio
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/595/dyn_amount_compo")
    @g_Portfolio = JSON.parse get(url).read_body
  end

  #CHECK
  def generate_portfolio(quantity_tab)
    # tab_asset ==> tableau de la forme [[id, nb], [id, nb], [id, nb], [id, nb], [id, nb]]
    tab = []
    quantity_tab.each do |t|
      tab.push create_portfolio_asset(t[0], t[1])
    end
    p_body = {"2012-01-01" => tab}
    p_header = {"label" => "PORTFOLIO_USER8", "currency" => {"code" => "EUR"}, "type" => "front", "values" => p_body}
    return p_header
    #put_portfolio(p_header)
  end


  def put_portfolio(portfolio)
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/595/dyn_amount_compo")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Put.new(url)
    request.basic_auth 'user_test', 'jumpTest'
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
    request.basic_auth 'user_test', 'jumpTest'
    request["cache-control"] = 'no-cache'
    #request["postman-token"] = 'fe1f347c-c612-2217-4f90-ef8db466bdb1'

    return response = http.request(request)
  end


  #CHECK
  def iterate_asset(init_asset)
    price_tab = []
    init_asset.each do |asset|
      value = []
      value.push(asset["ASSET_DATABASE_ID"]["value"])
      value.push((asset["LAST_CLOSE_VALUE_IN_CURR"]["value"]).sub(",",".").to_f)
      price_tab.push(value)
    end

    h_sharpe = get_ratio_in_hash(20, price_tab)
    t_sharpe = h_sharpe.sort_by {|k,v| v}
    t_sharpe = t_sharpe.reverse[0,20]
    # 0-21 pour le portfolio
    h_rend = get_ratio_in_hash(21, t_sharpe)
    h_vol = get_ratio_in_hash(18, t_sharpe)
    # liste des 20 meilleur ratio de sharpe

    #tt = tt.sort_by {|k,v| v}
    #tt = tt.reverse[0,21]
    #tt.each do |tabb|
    #  url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset/#{tabb[0].to_i}?columns=LAST_CLOSE_VALUE_IN_CURR")
    #  tabb.insert(2, (JSON.parse get(url).read_body)["LAST_CLOSE_VALUE_IN_CURR"]["value"].sub(",",".").to_f)
    #  tabb.insert(3, (500000/tabb[2]).to_i)
    #end
    poids = optimization(t_sharpe, h_rend, h_vol, price_tab)
    quant = w_to_q(poids, price_tab)
    port = generate_portfolio(quant)
    put_portfolio(port)
  end

  #CHECK
  def get_ratio_in_hash(id_ratio, asset_tab)
    h = {}
    tab = []
    asset_tab.each do |t|
      tab.push t[0].to_i
    end
    ratio_tab = JSON.parse get_ratio([id_ratio], tab, [])
    ratio_tab.keys.each do |v|
        h[v] = ratio_tab[v][id_ratio.to_s]["value"].sub(",",".").to_f
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
    request.basic_auth 'user_test', 'jumpTest'
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

  #CHECK
  def eval_portfolio
    return JSON.parse get_ratio([20], [595], [])
  end

  def fill_portfolio

  end

  def optimization(t_sharpe, h_rend, h_vol, price_tab)
    #if poids ==
    t_poids = []
    t_sharpe.each do |sh|
      value = []
      value.push(sh[0])
      value.push(0.01)
      t_poids.push(value)
    end
      mark = 80
    until mark == 0
      mark -= 1
      index = 0
      tmp = 0 #calcul_sharpe(t_poids, h_rend, h_vol, price_tab)
      i = 0
      until i == 20
        if t_poids[i][1] < 0.1
          t_poids[i][1] += 0.01
          new_sharpe = calcul_sharpe(t_poids, h_rend, h_vol, price_tab)
          # put new portfolio
          # post invoke ratio [20] [595] []
          if new_sharpe > tmp
            index = i
            tmp = new_sharpe
          end
          t_poids[i][1] -= 0.01
        end
        i += 1
      end
      t_poids[index][1] += 0.01
      p tmp
    end
    return t_poids
  end

#t_poids = [[171,], [],[],[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]]

  def calcul_sharpe(t_poids, h_rend, h_vol, price_tab)
    quant = w_to_q(t_poids, price_tab)
    port = generate_portfolio(quant)
    put_portfolio(port)
    ratio = JSON.parse get_ratio([20], [595], [])
    p (ratio["595"]["20"]["value"]).sub(",",".").to_f
    return (ratio["595"]["20"]["value"]).sub(",",".").to_f
  end

  def w_to_q(w_tab, price_tab)
    # w_tab ==> tableau de la forme [[id, weight], [id, weight], [id, weight], [id, weight]
    quantity_tab = []
    somme = 10000000
    w_tab.each do |tup|
      value = []
      value.push(tup[0])
      if tup[1] == 0.01
        value.push(((somme * tup[1]) / (price_tab.to_h)[tup[0]]).to_i + 1)
      else
        value.push(((somme * tup[1]) / (price_tab.to_h)[tup[0]]).to_i)
      end
      quantity_tab.push(value)
    end
    return quantity_tab
  end

end
