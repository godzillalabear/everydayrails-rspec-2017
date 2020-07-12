require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )
  end

  context "with name and user" do
    let(:project){ Project.new(owner: @user, name: "Test Project") }

    it "should be vaild" do
      expect(project).to be_valid
    end
  end

  context "project without a name" do
    before do
      @project = Project.new(name: nil)
      @project.valid?
    end
    
    it "is invalid" do
      expect(@project.errors[:name]).to include("can't be blank")
    end
  end

  context "project without an owner" do
    before do
      @project = Project.new(owner: nil)
      @project.valid?
    end
    it "is invalid" do
      expect(@project.errors[:owner]).to include("must exist")
    end
  end

  it "does not allow duplicate project names per user" do
    
    @user.projects.create(
      name: "Test Project"
    )

    new_project = @user.projects.build(
      name: "Test Project",
    )

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "allows two users to share a project name" do
    @user.projects.create(
      name: "Test Project",
    )

    other_user = User.create(
      first_name: "Jane",
      last_name: "Tester",
      email: "janetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )

    other_project = other_user.projects.build(
      name: "Test Project",
    )

    expect(other_project).to be_valid
  end
end
