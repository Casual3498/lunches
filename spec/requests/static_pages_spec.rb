require 'rails_helper'

describe "StaticPages", type: :request do

 let(:base_title) { "Lunches" }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }

    it { should have_title (full_title(page_title)) }
  end

  describe "Privacy Notice page" do
    before { visit privacy_notice_path }

    let(:heading)    { 'Privacy Policy' }
    let(:page_title) { 'Privacy Notice' }

    it_should_behave_like "all static pages"

    xit { should_not have_content ('template') }
  end

  describe "Conditions of Use page" do
    before { visit conditions_of_use_path }

    let(:heading)    { 'Terms of Use' }
    let(:page_title) { 'Conditions of Use' }
  	
    it_should_behave_like "all static pages"

    xit { should_not have_content('template') }  
  end

  describe "Home page" do
    before { visit home_path}

    it { should have_css("img[src^='/assets/kotletki_s_pureshkoi'][src$='.jpg']") }

    it { should have_css("img[alt='Lunch picture']") }

    it { should have_css 'title', text: /^#{base_title}$/, visible: false }

  end


  it "should have the right links on the layout" do
    visit root_path
    click_link "Sign up"
    expect(page).to have_title(full_title('Sign up')) 
    visit root_path
    click_link "Sign in"
    expect(page).to have_title(full_title('Sign in'))
    visit root_path
    click_link "Lunches"
    expect(page).to have_css 'title', text: /^#{full_title('')}$/, visible: false
  end

end
