pragma solidity ^0.4.23;

contract FEDCoin{ //Do not audit the Fed.
    
    string constant public name = "Street Rat Coin"; //street rat coin
    string constant public symbol = "SRat"; 
   
    uint8 constant public decimals = 2; //$0.00
    
    uint256 constant public initialSupply = 23000000000000; // 2.3 Trillion.
    
    address public federalReserveWallet; // Main FEDCoin funds address.

    uint256 public totalMoneySupply = 0; //keeps track of total money supply.
    //add token name, supply, etc.
    
    mapping (address => uint256) public balances; //create a map addresses x value
   
    mapping (address => bool) public Admin; //Map admins or ppl allowed to print/widthdrawl from main fund.
    
    mapping (address => bool) public banStatus;  //Maps address to their ban status. 1 == Banned || 0 == not banned.
    
    constructor() public{ //Coin constructor
        
        federalReserveWallet = msg.sender; //owner/holder of main funds is contract deployer.

        Admin[federalReserveWallet] = true; //Add contract wallet to list of admins.

        totalMoneySupply = initialSupply; // Total current money in circulation.
       
        balances[federalReserveWallet] = initialSupply; //Initialize Central bank starting balance minus payoffs.
       
    }
    
    
    function transferFEDCoin(address from, address to, uint256 amount ) public returns(bool) { //Transfer street rat from one person to another.
        
        require( (balances[from] >= amount)); // greater than amount they control.
        require( !banStatus[from] && !banStatus[to]); //If 1 banned member is envolved banned transactions of FEDCoin.
        
        balances[from] -= amount;//update balances
        balances[to] += amount;
        
        return true;
    }
    
    function withdrawalFEDCoin(address recipient, uint256 amount) public returns (bool){ //Withdrawl funds from main wallet. Requires admin rights.
        
        require(Admin[msg.sender]);//check if not an admin; 
        require(balances[federalReserveWallet] >= amount);
        
        balances[federalReserveWallet] -= amount; //Remove funds from main account fed holder.
        balances[recipient] += amount;            //Add to funds recipint.
        
        return true;//add event?
    }
    
    
    function printMoreFED(uint256 mintAmount) public returns(bool) { //print a supplied amount of street rat.
    
        if(Admin[msg.sender]) return;//check if not an admin; 
        //max print?
        totalMoneySupply += mintAmount;
        balances[federalReserveWallet] += mintAmount; //Max amount? //exceptions.
        //add event?
        return true;
    }
    
    
    function addCentralBanker(address newBanker) public returns(bool){ //Add address as central banker. better method?
        require(Admin[msg.sender]);//check if not an admin; 
       
        Admin[newBanker] = true;
        return true;
       
        //add event?
    }
    
    
    function removeCentralBanker(address banker) public returns(bool){  //Remove address as central banker.
        require(federalReserveWallet != msg.sender);//Make sure contract wallet can't be removed as admin.
        require(!Admin[msg.sender]);//check if not an admin; 
        
        Admin[banker] = false; //Remove Central Banker privledges.
        return true;
        //add event?
    }
    
    
    function lockAccount(address toBan) public returns(bool){ //Stops locked account from sending/receiving any street rat.
        require(Admin[msg.sender]);//check if not an admin; 
        banStatus[toBan] = true;   //Activate ban
        return true;
    }
    
    
    function unlockAccount(address unBan) public{ //unlocks account so the street rats can flow again.
        require(Admin[msg.sender]);//check if not an admin; 
        banStatus[unBan] = false; //Remove ban
    }
    
    //Add is owned function. unique event error handling/ generic check type previledge?
    
      /* function() public payable{ //Callback function? function to run when paid in ETH.
     //coming soon.
    }*/
    
}