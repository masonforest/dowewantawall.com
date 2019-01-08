defmodule TwitterPoll.Repo.Migrations.CreateEthereumTransactions do
  use Ecto.Migration

  def change do
    create table(:ethereum_transactions) do
      add :ethereum_transaction_hash, :binary
    end

    create table(:ethereum_transactions_votes, primary_key: false) do
      add :ethereum_transaction_id, references(:ethereum_transactions)
      add :vote_id, references(:votes)
    end
  end
end
