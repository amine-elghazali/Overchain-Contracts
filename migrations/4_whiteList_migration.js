const WhiteListedContract = artifacts.require("WhiteListedContract");

module.exports = function (deployer) {
  deployer.deploy(WhiteListedContract);
};