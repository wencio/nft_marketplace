//SPDX-License-Identifier: MIT License
pragma solidity  ^0.8.11;
import "./IERC721.sol";

contract Market {

    // public - anyone can call 
    // private - only this contract can call this
    //internal - only this contract and inheriting contracts can call 
    //external - only external calls

    enum ListingStatus {

        Active,
        Sold,
        Cancelled
    }

    struct Listing{

        ListingStatus status;
        address seller;
        address token;
        uint tokenId;
        uint price;
    }

    event Listed (

        uint listingId,
        address seller,
        address token, 
        uint tokenId,
        uint price


    );

    event Sale (

        uint listingId,
        address buyer,
        address token, 
        uint  tokenId,
        uint price

    );

    event Cancel(

        uint listingId,
        address seller
    );

    uint private _listingId  = 0;

    mapping (uint=> Listing) private _listings;

   
    function listToken (address token, uint tokenId,uint price) external {

        // address(this) is to our contract .. to be sure we have enough tokens to sell, we put tokens to our contract 
        IERC721(token).transferFrom(msg.sender,address(this),tokenId);

        Listing memory listing = Listing (ListingStatus.Active,msg.sender,token,tokenId,price);

        _listingId++;

        _listings[_listingId] = listing;


//1 ETH == 1 * 10^18

        emit Listed(
            _listingId,
            msg.sender,
            token,
            tokenId,
            price
        );

    }

// normal functions can read and write 
// view - read-only- can read not write 
// pure -no read,no write


    function getListing(uint ListingId) public view returns (Listing memory){
        return _listings[ListingId];


    }

    function buyToken(uint listingId) external payable {

        Listing storage listing = _listings[listingId];
        require(listing.status == ListingStatus.Active,"Listing is not active");
        require(msg.sender != listing.seller,"Seller cannot be the buyer");
        require (msg.value >= listing.price,"Insufficient payment");
        listing.status = ListingStatus.Sold;
        IERC721(listing.token).transferFrom( address(this),msg.sender,listing.tokenId);
        payable(listing.seller).transfer(listing.price);
        emit Sale (listingId,msg.sender,listing.token,listing.tokenId,listing.price);

    }

    function cancel(uint listingId) public {
        Listing storage listing = _listings[listingId];
        require(msg.sender == listing.seller,"Only Seller can cancel the contract ");
        require(listing.status == ListingStatus.Active,"Listing is not active");
        listing.status = ListingStatus.Cancelled;
        IERC721(listing.token).transferFrom( address(this),msg.sender,listing.tokenId);
        emit Cancel(listingId,listing.seller);


     




    }
    
    }









