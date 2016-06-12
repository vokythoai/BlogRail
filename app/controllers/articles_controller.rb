class ArticlesController < ApplicationController

  before_action :set_article, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /articles
  # GET /articles.json
  def index
    require 'rubygems'
    require 'mechanize'
    agent = Mechanize.new
    host = ["http://kenh14.vn","http://gamek.vn","http://vnexpress.net","http://dantri.com.vn"]
    host.each do |h|
      begin
        page = agent.get(h)
      rescue
        puts "Error #{$!}"
      end

      @docs = Nokogiri::HTML(page.body)
      @content = @docs.css('a')
      @data = @content
      array = ['.html','.htm','.chn','http']
      @content.each_with_index do |i,c|
        title = i['title']
        url = i['href']

        if (title != nil) && array.any? {|word| url.to_s.include?(word)}
          unless url.to_s.include? "http//e."
            if (url.to_s.include? "http") == false
              PostData.create(title: title.to_s,url: h + url.to_s)
              fetch_data(h + url.to_s)
            else
              PostData.create(title: title.to_s,url: url.to_s)
              fetch_data (url.to_s)
            end
          end
        end
      end

    end

    # PostData.order("id desc").each do |p|
    #   fetch_data(p.url.to_s)
    # end

    @data = PostData.all










  end

  # GET /articles/1
  # GET /articles/1.json
  def show
      @comments = Comment.where(article_id: @article.id)
      @comment = Comment.new

  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fetch_data url
      require 'rubygems'
      require 'mechanize'
      agent = Mechanize.new
      if (url.to_s.include? "https") == false
        begin
          page = agent.get(url)
        rescue
          puts "Error #{$!}"
        end


        @docs = Nokogiri::HTML(page.body)
        @content = @docs.css('a')
        insert_data @content,url
      end

    end

    def insert_data content , host
     array = ['.html','.htm','.chn','http']
      content.each_with_index do |i,c|
        title = i['title']
        url = i['href']

        if (title != nil) && array.any? {|word| url.to_s.include?(word)}
          unless url.to_s.include? "http//e."
            if (url.to_s.include? "http") == false
              root = host.split("/")[2]


                PostData.create(title: title.to_s,url: "http://"+root.to_s + url.to_s)

            else
              PostData.create(title: title.to_s,url: url.to_s)

            end
          end
        end
      end
    end

    def article_params

      params.fetch(:article).permit(:title,:text,:user_id,:avatar)
    end
end
