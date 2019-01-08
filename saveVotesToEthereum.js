require('dotenv').config();
var pgFormat = require('pg-format');
const { Client } = require("pg");
const { privateToAddress } = require('ethereumjs-util');
const fs = require("fs");
const _ = require("lodash");
const Web3 = require("web3");
const {promisify} = require('util');
const readFileAsync = promisify(fs.readFile);

const { PRIVATE_KEY } = process.env;
const { INFURA_API_KEY } = process.env;
const { INFURA_NETWORK } = process.env;
const { CONTRACT_ADDRESS } = process.env;
const web3 = new Web3(`https://${INFURA_NETWORK}.infura.io/v3/${INFURA_API_KEY}`);
const CONTRACT_JSON_FILE = "contracts/build/contracts/TwitterPoll.json"; 
const UNSAVED_VOTES_QUERY = "SELECT votes.id, screen_name, choice FROM votes JOIN users on users.id=votes.user_id LEFT JOIN ethereum_transactions_votes ON ethereum_transactions_votes.vote_id=votes.id where ethereum_transactions_votes.vote_id is NULL";
const INSERT_TRANSACTION_QUERY = 'INSERT INTO ethereum_transactions (ethereum_transaction_hash) VALUES (%L) RETURNING id';
const INSERT_TRANSACTION_VOTE_QUERY = 'INSERT INTO ethereum_transactions_votes (ethereum_transaction_id, vote_id) VALUES %L'
const gasPrice = web3.eth.gasPrice;
const gasPriceHex = web3.utils.toHex(gasPrice);
const gasLimitHex = web3.utils.toHex(3000000);

(async () => {
  console.log("Starting saveVotesToEthereum")
  const client = new Client({
    connectionString: process.env.DATABASE_URL
  })
  client.connect()

  let {rows: votes} = await client.query(UNSAVED_VOTES_QUERY);
  console.log(votes);
  if(votes.length > 0) {
    const groupedVotes = _.groupBy(votes, "choice");
    const yesVotes = _.map(groupedVotes[true], "screen_name");
    const noVotes = _.map(groupedVotes[false], "screen_name");
    const { abi } = JSON.parse(await readFileAsync(CONTRACT_JSON_FILE, "utf-8"));
    const address = "0x" + privateToAddress(Buffer.from(PRIVATE_KEY, "hex")).toString("hex");
    
    const contract = new web3.eth.Contract(abi, CONTRACT_ADDRESS);
    const data = contract.methods.submitVotes(yesVotes, noVotes).encodeABI();
    const nonce = await web3.eth.getTransactionCount(address)

    var tx = {
      gasPrice: gasPriceHex,
      gasLimit: gasLimitHex,
      nonce,
      to : CONTRACT_ADDRESS,
      data,
    }

    const signed = await  web3.eth.accounts.signTransaction(tx, "0x" + PRIVATE_KEY);
    console.log(signed);
    const {
      transactionHash,
      status,
    } = await web3.eth.sendSignedTransaction(signed.rawTransaction)
      .on('transactionHash', console.log)
      .on('error', console.log);

    if(status) {
      let transactionBytes = Buffer.from(transactionHash.slice(2), "hex");
      let {rows: [{ id: ethereumTransactionId }]} = await client.query(
        pgFormat(INSERT_TRANSACTION_QUERY, [transactionBytes])
      );
      let ethereumTransactionVotes = votes.map((vote) => 
        [ethereumTransactionId, vote.id]
      );
      await client.query(
        pgFormat(INSERT_TRANSACTION_VOTE_QUERY, ethereumTransactionVotes)
      );
      console.log(`Successfully saved ${votes.length} votes`)
      console.log(`Transaction ID: ${transactionHash}`)
    }

    await client.end()
  }
})()
