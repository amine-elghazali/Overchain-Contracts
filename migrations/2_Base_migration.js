const BaseContract = artifacts.require("BaseContract");

module.exports = function (deployer) {
  deployer.deploy(BaseContract);
};