RSpec.shared_examples_for "must contain data in content and title" do 
    it { should have_content(data) }
    it { should have_title("Lunches | " + data) }
end