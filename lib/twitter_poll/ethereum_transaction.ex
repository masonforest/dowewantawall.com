defmodule TwitterPoll.EthereumTransaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "ethereum_transactions" do

    timestamps()
  end

  @doc false
  def changeset(ethereum_transaction, attrs) do
    ethereum_transaction
    |> cast(attrs, [])
    |> validate_required([])
  end
end
