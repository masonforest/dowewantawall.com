const TwitterPoll = artifacts.require("TwitterPoll");

contract('TwitterPoll', function(accounts) {
  describe("#submitVotes", function() {
    it("appends yesVotes", async () => {
      let instance = await TwitterPoll.deployed();
      await instance.submitVotes(["alice"], []);
      assert.deepEqual(await instance.getYesVotes(), ["alice"]);
    });

    it("appends noVotes", async () => {
      let instance = await TwitterPoll.deployed();
      await instance.submitVotes([], ["bob"]);
      assert.deepEqual(await instance.getNoVotes(), ["bob"]);
    });
  });
});
