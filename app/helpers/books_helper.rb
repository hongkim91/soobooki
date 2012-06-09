module BooksHelper
  def format_amazon_pub_date(pd)
    if pd.nil?
      pub_date = nil
    elsif pd.length == 4
        pub_date = DateTime.civil(pd[0..3].to_i,1,1).strftime("%Y")
    elsif pd.length == 7
        pub_date = DateTime.civil(pd[0..3].to_i,pd[5..6].to_i,1).strftime("%b, %Y")
    else
      pub_date = DateTime.civil(pd[0..3].to_i,pd[5..6].to_i,pd[8..9].to_i)
        .strftime("%b %-d, %Y")
    end
  end
end
