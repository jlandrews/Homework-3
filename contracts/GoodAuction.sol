pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title GoodAuction */
contract GoodAuction is AuctionInterface {
	/* New data structure, keeps track of refunds owed to ex-highest bidders */
	mapping(address => uint) refunds;

	/* Bid function, shifts to push paradigm
	 * Must return true on successful send and/or bid, bidder
	 * reassignment
	 * Must return false on failure and allow people to
	 * retrieve their funds
	 */
	function bid() payable external returns(bool) {
		if (msg.value > highestBid) {
			refunds[highestBidder] += highestBid;
			highestBidder = msg.sender;
			highestBid = msg.value;
			return true;
		} else {
			refunds[msg.sender] += msg.value;
			return false;
		}
	}

	/* New withdraw function, shifts to push paradigm */
	function withdrawRefund() external returns(bool) {
		uint amount = refunds[msg.sender];
		refunds[msg.sender] = 0;
		msg.sender.transfer(amount);
		return true;
	}

	/* Allow users to check the amount they can withdraw */
	function getMyBalance() constant external returns(uint) {
		return refunds[msg.sender];
	}

	/* Give people their funds back */
	function () payable {
		revert();
	}
}
