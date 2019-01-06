import _ from "lodash";
import Web3 from "web3";
import "babel-polyfill";
import assert from "assert";

import {
  deploy
} from "./utils";

describe("TwitterPoll", function() {
  var contract;
  var web3;

  beforeEach(async function() {
    web3 = new Web3("http://localhost:8545");
    contract = await deploy(web3, "TwitterPoll.sol", "Paper or Plastic?", "Paper", "Plastic");
  });

  describe("#submitVotes", function() {
    it("appends votes for option a", async () => {
      await submitVotes(["alice"], []).send();
      assert.deepEqual(await votes(), [["alice"], []]);
    });

    it("appends votes for option b", async () => {
      await submitVotes([], ["alice"]).send();
      assert.deepEqual(await votes(), [[], ["alice"]]);
    });

    it("appends votes for both options", async () => {
      await submitVotes(["alice"], ["bob"]).send();
      await submitVotes(["carol"], ["dave"]).send();
      assert.deepEqual(await votes(), [["alice", "carol"], ["bob", "dave"]]);
    });

    function submitVotes(...votes) {
      return contract.methods.submitVotes(..._.map(votes, (option) => _.map(option, web3.utils.asciiToHex)));
    }

    async function votes() {
      return await Promise.all(([0, 1]).map(async (optionIndex) => 
        await Promise.all(_.range(0, await contract.methods.voteCount(optionIndex).call()).map(async (index) => {
          let bytes = await contract.methods.votes(optionIndex, index).call();
          return _.trimEnd(web3.utils.hexToAscii(bytes), "\u0000")
        }))
      ))
    }
  })
});
