require 'spec_helper'

describe BrandsController do

  describe "GET 'page'" do
    it "returns http success" do
      get 'page'
      response.should be_success
    end
  end

  describe "GET 'subpage'" do
    it "returns http success" do
      get 'subpage'
      response.should be_success
    end
  end

  describe "GET 'brand_index'" do
    it "returns http success" do
      get 'brand_index'
      response.should be_success
    end
  end

  describe "GET 'brand_category'" do
    it "returns http success" do
      get 'brand_category'
      response.should be_success
    end
  end

  describe "GET 'brand_subcategory'" do
    it "returns http success" do
      get 'brand_subcategory'
      response.should be_success
    end
  end

  describe "GET 'brand_series'" do
    it "returns http success" do
      get 'brand_series'
      response.should be_success
    end
  end

  describe "GET 'brand_block'" do
    it "returns http success" do
      get 'brand_block'
      response.should be_success
    end
  end

end
