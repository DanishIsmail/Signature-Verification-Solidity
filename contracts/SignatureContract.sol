// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignatureContract {

    uint256 private totalAmont; 
    address private owner;
    mapping(address => bool) private whiteLitedWallet;

    constructor(){
        whiteLitedWallet[msg.sender] = true;
        owner = msg.sender;
    }

     modifier onlyOwner(){
        require(owner == msg.sender, "you are not owner");
        _;
    }

    modifier onlyAllowedWallets(){
        require(whiteLitedWallet[msg.sender] == true, "you are not alowed");
        _;
    }

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    function verifySignature(bytes32 payloadHash, Signature memory signature) internal pure returns (address) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, payloadHash));
        address signer = ecrecover(prefixedHash, signature.v, signature.r, signature.s);
        return signer;
    }

    function mintWithSignature(uint256 amount, bytes32 payloadHash, Signature memory signature)  public onlyAllowedWallets{
        // Verify the signature
        address signer = verifySignature(payloadHash, signature);
        require(signer == msg.sender, "Invalid signer");
        require(amount >= 0, "amount should not be zero");

        totalAmont = totalAmont + amount;
    }

    function addWhiteListedWallet(address walletAddress) public onlyOwner{
        require(walletAddress != address(0), "address shold not be zero");
        require(whiteLitedWallet[walletAddress] != true, "wallet alreadt exist");
        whiteLitedWallet[walletAddress] = true;
    }

    function allowToUse(address walletAddress) public onlyOwner{
        require(walletAddress != address(0), "address shold not be zero");
        require(whiteLitedWallet[walletAddress] == false, "wallet Does not exist or alread allowed");
        whiteLitedWallet[walletAddress] = true;
    }

    function removeAllowedWallet(address walletAddress) public onlyOwner{
        require(walletAddress != address(0), "address shold not be zero");
        require(whiteLitedWallet[walletAddress] == true, "wallet does not exist");
        delete  whiteLitedWallet[walletAddress];
    }

    function isWalletAllowed(address walletAddress) public view returns(bool){
        return whiteLitedWallet[walletAddress] == true;
    }
}

