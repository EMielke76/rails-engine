require 'rails_helper' do
  it { should have_many(:items) }
  it { should have_many(:invoices) }
end 
