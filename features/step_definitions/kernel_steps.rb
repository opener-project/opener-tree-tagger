Given /^the fixture file "(.*?)"$/ do |filename|
  @input = File.read(fixture_file(filename))
  @filename = filename
end

Given /^I put it through the kernel$/ do
  @output, * = kernel.run(@input)
end

Then /^the output should match the fixture "(.*?)"$/ do |filename|
  fixture_output = File.read(fixture_file(filename))
  @output.should eql(fixture_output)
end

def fixture_file(filename)
  File.expand_path("../../../features/fixtures/#{filename}", __FILE__)
end

def tmp_file(filename)
  File.expand_path("../../../tmp/#{filename}", __FILE__)
end

def kernel
  Opener::TreeTagger.new(:args => ['--no-time'])
end
