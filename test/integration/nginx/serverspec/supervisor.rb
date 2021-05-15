require 'spec_helper'

# Required by serverspec
set :backend, :exec

describe service('supervisor') do
  it { should be_enabled   }
  it { should be_running   }
end
