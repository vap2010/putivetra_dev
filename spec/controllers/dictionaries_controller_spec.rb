require 'spec_helper'

describe DictionariesController do

  describe "GET 'slovar_index'" do
    it "returns http success" do
      get 'slovar_index'
      response.should be_success
    end
  end

  describe "GET 'slovar'" do
    it "returns http success" do
      get 'slovar'
      response.should be_success
    end
  end

  describe "GET 'slovar_letter'" do
    it "returns http success" do
      get 'slovar_letter'
      response.should be_success
    end
  end

  describe "GET 'slovar_word'" do
    it "returns http success" do
      get 'slovar_word'
      response.should be_success
    end
  end

end
