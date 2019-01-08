const TwitterPoll = artifacts.require("TwitterPoll");

module.exports = function(deployer) {
  deployer.deploy(TwitterPoll, "Should the United States build a wall on its Southern border between itself and Mexico?");
};
