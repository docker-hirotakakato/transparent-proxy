require 'spec_helper'

describe port(3128) do
  it { should be_listening }
end
