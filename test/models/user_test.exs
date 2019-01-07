defmodule TwitterPoll.UserTest do
  use TwitterPoll.ModelCase

  alias TwitterPoll.User

  @valid_attrs %{profile_piture_url: "some profile_piture_url", username: "some username"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
