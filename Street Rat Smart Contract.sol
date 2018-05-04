pragma solidity ^0.4.18;

contract SRat{
     //add token name, supply, address mappings.
    string constant public name = "Street Rat Coin"; //street rat coin
    
    string constant public symbol = "SRat"; 
   
    uint8 constant public decimals = 2; //$0.00
    
    uint256 constant public initialSupply = 23000000000000; // 2.3 Trillion.
    
    address federalReserveWallet; // I mean street rat coin...

    uint256 public totalMoneySupply = 0; //keeps track of total money supply.
  
    
    mapping (address => uint256) public balanceOf; //create a map addresses x value
   
    mapping (address => bool) public banStatus;  //Maps address to their ban status. 1 == Banned || 0 == not banned.
    
    mapping (address => bool) public adminStatus; //Map admins or ppl allowed to print/widthdrawl from main fund.
    
    function SRat() public{ //Coin constructor
        
        federalReserveWallet = msg.sender; //owner/holder of main funds is contract deployer.

        adminStatus[federalReserveWallet] = true; //Add contract wallet to list of admins.

        totalMoneySupply = initialSupply; // Total current money in circulation.
       
        balanceOf[federalReserveWallet] = initialSupply; //Initialize Central bank starting balance minus payoffs.
       
    }
    
    modifier isAdmin {   //Modifier fuction for modular admin check.
        require(adminStatus[msg.sender]);
        _;
    }
    
    
    function transferFEDCoin(address from, address to, uint256 amount ) public returns(bool) { //Transfer street rat from one person to another.
        
        require( (balanceOf[from] >= amount)); // greater than amount they control.
        require( !banStatus[from] && !banStatus[to]); //If 1 banned member is envolved banned transactions of FEDCoin.
        
        balanceOf[from] -= amount;//update balances
        balanceOf[to] += amount;
        
        return true;
    }
    
    function withdrawalFEDCoin(address recipient, uint256 amount) isAdmin public returns (bool){ //Withdrawl funds from main wallet. Requires admin rights.

        require(balanceOf[federalReserveWallet] >= amount);
        
        balanceOf[federalReserveWallet] -= amount; //Remove funds from main account fed holder.
        balanceOf[recipient] += amount;            //Add to funds recipint.
        
        return true;//add event?
    }
    
    
    function  printMoreFED (uint256 mintAmount) isAdmin public returns(bool) { //print a supplied amount of street rat.
        
        require((mintAmount + totalMoneySupply) <= 100000000000000);  //Cap 100000000000000 or 100 trillion.
        totalMoneySupply += mintAmount;
        balanceOf[federalReserveWallet] += mintAmount;  //Add minted amount to contract wallet
        //add event?
        return true;
    }
    
    
    function addCentralBanker(address newBanker) isAdmin public returns(bool){ //Add address as central banker. better method?
       
        adminStatus[newBanker] = true;
        return true;
       
        //add event?
    }
    
    
    function removeCentralBanker(address banker) isAdmin public returns(bool){  //Remove address as central banker.
        require(federalReserveWallet != msg.sender);//Make sure contract wallet can't be removed from admin.
        
        adminStatus[banker] = false; //Remove Central Banker privledges.
        return true;
        //add event?
    }
    
    
    function lockAccount(address toBan) isAdmin public returns(bool){ //Stops locked account from sending/receiving any street rat coin.

        banStatus[toBan] = true;   //Activate ban
        return true;
    }
    
    
    function unlockAccount(address unBan) isAdmin public returns(bool){ //unlocks account so the street rats can flow again.
        
        banStatus[unBan] = false; //Remove ban
        return true;
    }
    
    //Add is owned function. unique event error handling/ generic check type previledge?
    
      /*
       function kill() public { //self-destruct function, 
   if(msg.sender == owner) {
    selfdestruct(owner); 
        }
      function() public payable{ //Callback function? function to run when paid in ETH.
     //coming soon.
    }*/
    
}