require File.dirname(__FILE__) + '/spec_helper'

describe Translate do
  before(:each) do
    Translate.send :remove_instance_variable, "@locales_dir" if Translate.instance_variable_get("@locales_dir")
  end
  
  describe "locales_dir" do
    it "should have the correct default" do
      Translate.locales_dir.should == Rails.root.join("config", "locales").to_s
    end

    it "should be possible to set it" do
      Translate.locales_dir = Rails.root.join("config", "locales").to_s
      Translate.locales_dir.should == Rails.root.join("config", "locales").to_s
    end

    it "should autmatically coerce inputs to strings on assignment" do
      Translate.locales_dir = Rails.root.join("config", "locales")
      Translate.locales_dir.should == Rails.root.join("config", "locales").to_s
    end
  end
end
