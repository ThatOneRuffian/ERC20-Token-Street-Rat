pragma solidity ^0.4.18;

contract SRat{
     //add token name, supply, address mappings.
    string constant public name = "Street Rat Coin"; //street rat coin
    
    string constant public symbol = "SRat"; 
   
    uint8 constant public decimals = 2; //$0.00
    
    uint256 constant public initialSupply = 23000000000000; // 2.3 Trillion.
    
    address public federalReserveWallet; // I mean street rat coin...

    uint256 public totalMoneySupply = 0; //keeps track of total money supply.
  
    address payer = msg.sender;
    
    uint256 payAmount = msg.value; //Gwei  
    
    mapping (address => uint256) public balanceOf; //create a map addresses x value
   
    mapping (address => bool) public banStatus;  //Maps address to their ban status. 1 == Banned || 0 == not banned.
    
    mapping (address => bool) public adminStatus; //Map admins or ppl allowed to print/widthdrawl from main fund.
    
    
    function SRat() public{ //Coin constructor
        
        federalReserveWallet = msg.sender; //owner/holder of main funds is contract deployer.

        adminStatus[federalReserveWallet] = true; //Add contract wallet to list of admins.

        totalMoneySupply = initialSupply; // Total current money in circulation.
       
        balanceOf[federalReserveWallet] = initialSupply; //Initialize Central bank starting balance minus payoffs.
       
    }
    
    event writeLog(
        string msg
        );


    modifier isAdmin {   // admin check.
        require(adminStatus[msg.sender]);
        _;
    }
    
    
    modifier isDeployer{
        require(msg.sender == federalReserveWallet);
        _;
    }
    
    
    function transfer(address to, uint256 amount ) public returns(bool) { //Transfer street rat from one person to another.
        
        require( (balanceOf[msg.sender] >= amount)); // greater than amount they control.
        require( !banStatus[msg.sender] && !banStatus[to]); //If 1 banned member is envolved banned transactions of FEDCoin.
        
        balanceOf[msg.sender] -= amount;//update balances
        balanceOf[to] += amount;
        
        return true;
    }
    
    
    function withdrawalToken(address recipient, uint256 amount) isAdmin public returns (bool){ //Withdrawl funds from main wallet. Requires admin rights.
       
        require(recipient != federalReserveWallet); //Fed -> Fed makes no sense. Save gas.
        require(balanceOf[federalReserveWallet] >= amount);
        
        balanceOf[federalReserveWallet] -= amount; //Remove funds from main account fed holder.
        balanceOf[recipient] += amount;            //Add to funds recipint.
        
        return true;
    }
    
    
    function widthdrawlETH(address recipient, uint256 amount) isDeployer public returns(bool){
        
        require(amount <= federalReserveWallet.balance);
        return recipient.send(amount);
    }
    
    
    function  printMoreTokens (uint256 mintAmount) isAdmin public returns(bool) { //print a supplied amount of street rat.
        
        require((mintAmount + totalMoneySupply) <= 100000000000000);  //Cap 100000000000000 or 100 trillion.
        totalMoneySupply += mintAmount;
        balanceOf[federalReserveWallet] += mintAmount;  //Add minted amount to contract wallet

        return true;
    }
    
    
    function addCentralBanker(address newBanker) isDeployer public returns(bool){ //Add address as central banker. better method?
       
        adminStatus[newBanker] = true;
        return true;
    }
    
    
    function removeCentralBanker(address banker) isDeployer public returns(bool){  //Remove address as central banker.
        
        require(banker != federalReserveWallet);//Make sure contract wallet can't be removed from admin.
        
        adminStatus[banker] = false; //Remove Central Banker privledges.
        return true;
    }
    
    
    function lockAccount(address toBan) isAdmin public returns(bool){ //Stops locked account from sending/receiving any street rat coin.

        banStatus[toBan] = true;   //Activate ban
        return true;
    }
    
    
    function unlockAccount(address unBan) isAdmin public returns(bool){ //unlocks account so the street rats can flow again.
        
        banStatus[unBan] = false; //Remove ban
        return true;
    }
    
   
    function voidContract() isDeployer public { //self-destruct function. It's been good....shut it down.
        
        writeLog("Contract destroyed.");
        selfdestruct(federalReserveWallet); 
    }
           
     function() public payable{ 
         

        writeLog("Payment Received. Thank you."); 
        
    }
    
}