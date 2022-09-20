//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
contract CrowdFunding{
     uint Index =0;
     address public owner;
     uint[] Calculations;
    constructor(){
        owner = msg.sender;
    }
    event Receipt(string Name,uint AmountDonated,uint Time);
    struct Create{
        string Name;
        address To;
        string Purpose;
        uint Deadline;
        uint Target;
        uint Raised;
        uint TokenId;
        uint Voters;
    }
    Create[] public create;
    mapping(string => Create)public Data;
    mapping(address => uint)public VotingTo;
    mapping(address => mapping(uint => uint))public Donated;
    mapping(address => bool) public Voted;
    function CreateRequest(address _To,string memory _purpose,string memory _Name,uint _deadline,uint _Target)public{
        create.push(Create({Name:_Name,To:_To,Purpose:_purpose,Deadline:_deadline+block.timestamp,Target:_Target,Raised:0,TokenId:Index,Voters:0}));
        Data[_Name]= create[Index];
        Calculations.push(0);
        Index++;
    }
    function DonateMoney(string memory Name,uint tokenID)public payable{
        require(create[tokenID].Deadline > block.timestamp && create[tokenID].Raised+msg.value<=create[tokenID].Target && msg.value>0,"Someting went wrong from ur side");
        if(Donated[msg.sender][tokenID] ==0){
            create[tokenID].Voters++;
        }
        Donated[msg.sender][tokenID]+=msg.value;
        create[tokenID].Raised+=msg.value;
        VotingTo[msg.sender] = tokenID;
        emit Receipt(Name,msg.value,block.timestamp);
    }
    function Vote(uint TokenID) public{
        require(Donated[msg.sender][TokenID]>0&&Voted[msg.sender]==false,"Either you are have already voted or you havent donated");
        Voted[msg.sender] = true;
        Calculations[TokenID]++;

    }
    function Completed(uint TokenID)public view returns(bool){
        if(create[TokenID].Raised>=create[TokenID].Target || block.timestamp>create[TokenID].Deadline){
            return true;
        }
        return false;
    }
    function transfermoney(uint TokenID) public payable{
        require(msg.sender == owner);
        payable(create[TokenID].To).transfer(create[TokenID].Raised);

    }
    function CalculateTheEligiblity(uint TokenID)public{
        require(create[TokenID].Deadline < block.timestamp&&msg.sender==owner,"Wait for the camapign to complete");
        uint TotalDonars = create[TokenID].Voters;
        uint TotalVotes = Calculations[TokenID];
        uint ans = (TotalVotes/TotalDonars)*100;
        if(ans>=50){
            transfermoney(TokenID);
        }else{
            message();
        }
    }
    function message()public pure returns(string memory){
        return "Sorry people chose not to doante you money";
    } 
}
//Steps
/*
1) Creare 2 requests
2)see both request
3)5 Addresses will  Donate money 
4) All 5 addresss will vote
5) One external non-donor will try to vote
6)Transfer of money
*/