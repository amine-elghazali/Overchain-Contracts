const BlackListedContract = artifacts.require("BlackListedContract");

module.exports = function (deployer) {
  deployer.deploy(BlackListedContract);
};