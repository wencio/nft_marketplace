const Migrations = artifacts.require("Migrations");
const DanniNFT = artifacts.require("DanniNFT");
const Market = artifacts.require("Market");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(DanniNFT);
  deployer.deploy(Market);
};
