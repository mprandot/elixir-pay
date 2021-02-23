defmodule Rocketpay.User do

  use Ecto.Schema
  import Ecto.Changeset

  alias Ector.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [
    :name,
    :age,
    :email,
    :password,
    :nickname
  ]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string
    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint([:email])
    |> unique_constraint([:nickname])
    |> validate_length(:password, min: 5)
    |> put_password_hash()
  end

  #|> validate_length(:password_hash, min: 2)
  #|> validate_number(:age, greater_than_or_equal_to: 2)
  #|> validate_number(:emaill, greater_than_or_equal_to: 2)

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
