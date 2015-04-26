#coding: UTF-8

Plugin.create(:"mikutter-photo-amazon") {
  def open_amazon_photo(url)
    if !url.is_a?(String)
      return nil
    end

    result_io = nil

    asin = url.split(/[\/\?\%]/).find { |_| _ =~ /^[0-9A-Z]{10}$/ }

    if asin
       client = HTTPClient.new
       res = client.get("http://images.amazon.com/images/P/#{asin}.09_SL500_.jpg")

       if res.header["Content-Type"][0] =~ /^image\//
         result_io = if res.header["Content-Type"][0] =~ /gif/
           # どうもgifが帰ってくるとエラーっぽい
           nil
         else
           StringIO.new(res.content, "rb")
         end
       end
    end

    result_io
  end


  defimageopener("amzn.to", /http\:\/\/amzn.to/) { |display_url|
    client = HTTPClient.new
    res = client.get(display_url)

    open_amazon_photo(res.header["location"][0])
  }


  defimageopener("amazon", /http\:\/\/www\.amazon\./) { |display_url|
    open_amazon_photo(display_url)
  }
}
