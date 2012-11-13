require "spec_helper"

describe WebForms do
  describe "order" do
    let(:mail) { WebForms.order }

    it "renders the headers" do
      mail.subject.should eq("Order")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

  describe "site_page_form" do
    let(:mail) { WebForms.site_page_form }

    it "renders the headers" do
      mail.subject.should eq("Site page form")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
