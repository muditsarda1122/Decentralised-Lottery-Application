//https://www.youtube.com/watch?v=aFI_XPll_mg&list=PLgPmWS2dQHW_CuryjGPkyH0PNXJ2B0hAk&index=7
//try deploying it with rinkeby network and see the contract work on real blockchain(end of the video)


// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract Lottery {
    //declaring the entities
    address public manager; 
    address payable[] public participants;

    //constructor is used to declare the owner of the contract 
    constructor() public{
        manager = msg.sender; //ownership given to manager's address. Global variable
    }

    //code below will push the address of the sender in the array from which we need to select one at random
    receive() external payable{
        require(msg.value == 1 ether); //participant needs to pay exactly 1 ether to enter the lottery
        participants.push(payable(msg.sender));
    }

    //this function will return the total pool of money in the lottery
    function GetBalance() public view returns(uint) {
        require(msg.sender == manager); //only manager can look at the balance
        return address(this).balance;
    }

    //keccak256 is a hashing algoriths, every time the timestamp will be different and hence same random number will never be generated
    function RandomNumberGeneration() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager); //only manager can find the winner
        require(participants.length>=3); //there is a minimum number of participants required 
        uint r = RandomNumberGeneration();
        address payable winner;
        uint index = r % participants.length; //the modulus operator will always return a value < participants.length, hence we will get a random index everytime 
        winner = participants[index];
        winner.transfer(GetBalance()); //winner's address will get the total money
        participants = new address payable[](0); //once the winner is decided, the array will be renewed
    }

}