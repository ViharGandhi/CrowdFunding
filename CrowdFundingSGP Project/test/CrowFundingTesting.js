const CrowdFunding = artifacts.require("CrowdFunding");
contract("CrowdFundingContractTesting",(accounts)=>{
    var contractinstance;
    before(async()=>{
        contractinstance = await CrowdFunding.deployed();
    })
    //Contract Should be deployed
    it("Contract Should be Deployed",async()=>{
        console.log(`Contract Deployed At ${contractinstance.address}`);
    })
    //Verifiying Contract owner is the person who deployes the contract
    it("Contract Owner",async()=>{
        const owner = await contractinstance.owner();
        assert.equal(owner,accounts[0])
    })
    //Creating a request
    it("Creating a request",async()=>{
        const RequestCreation = await contractinstance.CreateRequest(accounts[2],"For Treatment","NEEDY1",1000,2000);
        const REQ = await contractinstance.create.call(0);
        assert(REQ[0] = "NEEDY1"  && REQ[1]==accounts[2]&&REQ[2]=="For Treatment" && REQ[4] == 2000);
    })
    //Donationg Money
    it("Able to Donate Money to someone",async()=>{
        //Here We Create request no2 and then donated money 
       await contractinstance.CreateRequest(accounts[3] , "For Starting a new Bussiness","NEEDY2",1000,2000);
       await contractinstance.DonateMoney("Donor",0,{from:accounts[1] ,value:100});
       await contractinstance.DonateMoney("Donor",1,{from:accounts[1] ,value:100});
       const REQ0 = await contractinstance.create.call(0);
       const REQ1  = await contractinstance.create.call(1);
       assert(REQ1[5]==100);
       assert(REQ1[7]==1);
       assert(REQ0[5]==100);
       assert(REQ0[7]==1);
       await contractinstance.DonateMoney("Donor",0,{from:accounts[5] ,value:100});
       await contractinstance.DonateMoney("Donor",1,{from:accounts[5] ,value:100});
       const REQ00 = await contractinstance.create.call(0);
       const REQ11  = await contractinstance.create.call(1);
       assert(REQ11[5]==200);
       assert(REQ11[7]==2);
       assert(REQ00[5]==200);
       assert(REQ00[7]==2);
       //Registerd Donor
       const DonationData = await contractinstance.Donated.call(accounts[5],0);
       console.log(`Account Five Donated ${BigInt(DonationData)}`);
    })
    it("Abel To Donate Money or not",async()=>{
        await contractinstance.DonateMoney("Donor",0,{from:accounts[5] ,value:100});
        accounts[5].call(await contractinstance.Vote(0))
    })
    

})