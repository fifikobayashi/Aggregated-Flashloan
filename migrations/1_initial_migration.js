const AggregatedFlashloans = artifacts.require("AggregatedFlashloans");

module.exports = function (deployer) {
  deployer.deploy(AggregatedFlashloans);
};
