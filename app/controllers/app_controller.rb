require 'uri'
require 'net/http'
require 'json'

class AppController < ApplicationController

  def index
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset?columns=ASSET_DATABASE_ID&columns=CURRENCY&columns=LABEL&columns=TYPE&columns=LAST_CLOSE_VALUE_IN_CURR&date=2012-01-01&CURRENCY=EUR")
    assets = JSON.parse get(url).read_body
  end

  def index_dep
    #https://dolphin.jump-technology.com:3389/api/v1/asset?columns=ASSET_DATABASE_ID&columns=LABEL&columns=TYPE&columns=LAST_CLOSE_VALUE_IN_CURR&columns=CURRENCY&date=2012-01-01&TYPE=STOCK&CURRENCY=EUR
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset?columns=ASSET_DATABASE_ID&columns=LABEL&columns=TYPE&columns=LAST_CLOSE_VALUE_IN_CURR&columns=CURRENCY&date=2012-01-01&TYPE=STOCK")
    #url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset?columns=ASSET_DATABASE_ID&columns=LABEL&columns=TYPE&columns=LAST_CLOSE_VALUE_IN_CURR&columns=CURRENCY&date=2012-01-01&TYPE=STOCK&CURRENCY=EUR")
    @res = JSON.parse get(url).read_body
    @res.each do |asset|
      #if (asset["ASSET_DATABASE_ID"]["value"].equal?("258")||asset["ASSET_DATABASE_ID"]["value"].equal?("322")||asset["ASSET_DATABASE_ID"]["value"].equal?("130")||asset["ASSET_DATABASE_ID"]["value"].equal?("194")||asset["ASSET_DATABASE_ID"]["value"].equal?("195")||asset["ASSET_DATABASE_ID"]["value"].equal?("131")||asset["ASSET_DATABASE_ID"]["value"].equal?("260")||asset["ASSET_DATABASE_ID"]["value"].equal?("164")|| asset["ASSET_DATABASE_ID"]["value"].equal?("265")||asset["ASSET_DATABASE_ID"]["value"].equal?("44")||asset["ASSET_DATABASE_ID"]["value"].equal?("301")|| asset["ASSET_DATABASE_ID"]["value"].equal?("15")||asset["ASSET_DATABASE_ID"]["value"].equal?("16")||asset["ASSET_DATABASE_ID"]["value"].equal?("307")||asset["ASSET_DATABASE_ID"]["value"].equal?("84")||asset["ASSET_DATABASE_ID"]["value"].equal?("22")||asset["ASSET_DATABASE_ID"]["value"].equal?("279")||asset["ASSET_DATABASE_ID"]["value"].equal?("313")||asset["ASSET_DATABASE_ID"]["value"].equal?("251")||asset["ASSET_DATABASE_ID
      #"]["value"].equal?("158"))
        p asset["LABEL"]
        p asset["ASSET_DATABASE_ID"]
        p asset["LAST_CLOSE_VALUE_IN_CURR"]
        p asset["TYPE"]
    end
    #puts @res.size


    url2 = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/572/dyn_amount_compo")
    @pot = JSON.parse get(url2).read_body
    #get_ratio
    put_portfolio
  end

  def create_random
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/572/dyn_amount_compo")
    @re = JSON.parse get(url).read_body
    @re["values"]["2012-01-01"].each |asset|
    ptf = '{"label":"PORTFOLIO_USER8","currency":{"code":"EUR"},"type":"front","values":{"2012-01-01":[{"asset":{"asset":169,"quantity":1.0}},{"asset":{"asset":109,"quantity":2.567394095}}]}}'

    # exactement de 20 actifs

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

  def get_assets
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/asset?columns=ASSET_DATABASE_ID&columns=LABEL&columns=TYPE&columns=LAST_CLOSE_VALUE_IN_CURR&columns=CURRENCY&date=2012-01-01&TYPE=STOCK&CURRENCY=USD")
    @asset = JSON.parse get(url).read_body

  end
  def get_portfolio
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/572/dyn_amount_compo")
    @g_Portfolio = JSON.parse get(url).read_body
  end
  def put_portfolio
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/portfolio/572/dyn_amount_compo")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Put.new(url)
    request.basic_auth 'epita_user_8', 'dolphin61357'
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '10a3570e-f9a2-afe4-18bb-4d31536b4439'
    request.body = "{\n    \"label\": \"PORTFOLIO_USER8\",\n    \"currency\": {\n        \"code\": \"EUR\"\n    },\n    \"type\": \"front\",\n    \"values\": {\n        \"2012-01-01\": [\n            {\n                \"asset\": {\n                    \"asset\": 258,\n                    \"quantity\": 28.826869225\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 322,\n                    \"quantity\": 41.2371134021\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 130,\n                    \"quantity\": 242.7611065634\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 194,\n                    \"quantity\": 25.5790116229\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 195,\n                    \"quantity\": 30.8653406916\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 131,\n                    \"quantity\": 26.0781392894\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 260,\n                    \"quantity\": 26.7950456604\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 164,\n                    \"quantity\": 33.462682216\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 265,\n                    \"quantity\": 160.2403348638\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 44,\n                    \"quantity\": 93.5313354292\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 301,\n                    \"quantity\": 214.389157054\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 15,\n                    \"quantity\": 44.9183752269\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 16,\n                    \"quantity\": 45.8558298213\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 307,\n                    \"quantity\": 7.4889908091\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 84,\n                    \"quantity\": 62.7162220149\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 22,\n                    \"quantity\": 40.9836065574\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 279,\n                    \"quantity\": 151.4420921786\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 313,\n                    \"quantity\": 19.5203178595\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 251,\n                    \"quantity\": 23.3870523011\n                }\n            },\n            {\n                \"asset\": {\n                    \"asset\": 158,\n                    \"quantity\": 30.8359730982\n                }\n            }\n        ]\n    }\n}"

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



  def iterate_asset(t)
    t.each do |asset|
      #p asset["CURRENCY"]["value"]
      if asset["TYPE"]["value"] != "STOCK"
        t.delete(asset)
      end
      r = JSON.parse get_ratio([20], [572])
      if
        
      end

    end
  end

  def iterate_portfolio(p)
    p["values"]["2012-01-01"].each do |asset|
      # ID = ["asset"]["asset"]
      # quantity = ["asset"]["quantity"]
    end

  end

  def get_ratio(ratio, asset)
    url = URI("https://dolphin.jump-technology.com:3389/api/v1/ratio/invoke")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request.basic_auth 'epita_user_8', 'dolphin61357'
    request["content-type"] = 'application/json'
    request["cache-control"] = 'no-cache'
    request["postman-token"] = '1ba6f74d-e67d-0ced-e00c-b6d0a0ff990d'
    h = {"ratio" => ratio, "asset" => asset, "bench" => "null", "startDate" => "2012-01-01", "endDate" => "2017-01-01", "frequency" => "null"}
    #request.body = "{ \r\n\"ratio\":#{ratio},\r\n\"asset\":#{asset},\r\n\"bench\":null,\r\n\"startDate\":\"2015-01-01\",\r\n\"endDate\":\"2017-01-01\",\r\n\"frequency\":null\r\n}"
    request.body = h.to_json

    response = http.request(request)
    return response.read_body
  end

end
