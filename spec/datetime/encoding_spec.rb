require File.expand_path('../../spec_helper', __FILE__)

ruby_version_is "1.9" do
  describe "DateTime string encoding methods" do
    it "should return strings in US-ASCII encoding" do
      d = DateTime.now
      d.asctime.encoding.name.should == 'US-ASCII'
      d.ctime.encoding.name.should == 'US-ASCII'
      d.httpdate.encoding.name.should == 'US-ASCII'
      d.inspect.encoding.name.should == 'US-ASCII'
      d.iso8601.encoding.name.should == 'US-ASCII'
      d.jisx0301.encoding.name.should == 'US-ASCII'
      d.rfc2822.encoding.name.should == 'US-ASCII'
      d.rfc3339.encoding.name.should == 'US-ASCII'
      d.rfc822.encoding.name.should == 'US-ASCII'
      d.strftime('%S:%M:%H').encoding.name.should == 'US-ASCII'
      d.to_s.encoding.name.should == 'US-ASCII'
      d.xmlschema.encoding.name.should == 'US-ASCII'
    end
  end
end