class MoviesController < ApplicationController
  before_filter :logged_in?

  def create
  end

  def search
    @api = params[:api]
    if @api == "naver"
      req_params = {'query' => params[:query]}
      req_params['target'] = "movie"
      req_params['display'] = 15
      req_params['key'] = "06b710eb5a338f01debad39d1245b73a"

      query = req_params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
      url = URI::HTTP.build(:host  => 'openapi.naver.com',
                       :path  => '/search',
                       :query => query)
      @response = HTTParty.get(url.to_s)
    elsif @api == "tomato"
      req_params = {'q' => params[:query]}
      req_params['apikey'] = "zpeftuy9nqqc22avcbps57w4"
      req_params['page_limit'] = "10"

      query = req_params.map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join('&')
      url = URI::HTTP.build(:host  => 'api.rottentomatoes.com',
                       :path  => '/api/public/v1.0/movies.json',
                       :query => query)
      @response = HTTParty.get(url.to_s)
    end
    respond_to do |format|
      format.js
    end
  end
end
