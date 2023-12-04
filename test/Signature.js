const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Signature", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deploySignatureContract() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Signature = await ethers.getContractFactory("SignatureContract");
    const Signatures = await Signature.deploy();

    return { Signatures, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should be deployed", async function () {
      const data = await loadFixture(deploySignatureContract);
      expect(data).not.equal(undefined);
    });
  });
});
