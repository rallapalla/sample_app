require 'spec_helper'

describe User do
  
  before { @user = User.new(name: "Example User", email: "user@email.com", password: "foobar", password_confirmation: "foobar" ) }
  
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when user name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      adresses = %w[user@foo,COM A_US-ERf.b.org first.last@foobaz. asd@co]
      adresses.each do |invalid_adress|
        @user.email = invalid_adress
        expect(@user).not_to be_valid
      end
    end
  end
  
  describe "when email format is valid" do
    it "should be valid" do
      adresses = %w[user@foo.COM A_US-ER@f.b.org f1r57.l457@f00baz.co.jp]
      adresses.each do |valid_adress|
        @user.email = valid_adress
        expect(@user).to be_valid
      end
    end
  end
  
  describe "when email adress is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "example@user.com", password: " ", password_confirmation: " " )
    end
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid_password") }
      
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
end
