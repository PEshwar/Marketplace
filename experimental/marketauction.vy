# Auction to sell items on marketplace
# This would be called from the front-end Dapp. 

# State variables
# Seller receives money from the leading bidder
seller: public(address)
startTimeOfAuction: public(timestamp)
endTimeOfAuction: public(timestamp)

# Leading bid details(while auction is in progress)
leadingBidder: public(address)
leadingBid: public(wei_value)

# Indicator if auction has ended
ended: public(bool)

# Create a marketplace auction on behalf of seller
# @param: _bidding_duration : Duration of bid
# @param: seller address `_seller`.
@public
def __init__(_seller: address, _bidding_duration: timedelta):
    self.seller = _seller
    self.startTimeOfAuction = block.timestamp
    self.endTimeOfAuction = self.startTimeOfAuction + _bidding_duration

# Bid on the marketplace auction with the value sent
# together with this transaction.
# The value will only be refunded if the
# auction is not won.
@public
@payable
def bidOnAuction():
    # Check if bidding duration is over.
    assert block.timestamp < self.endTimeOfAuction
    # Check if bid is high enough
    assert msg.value > self.leadingBid
    if not self.leadingBid == 0:
        # Sends money back to the previous leading bidder
        send(self.leadingBidder, self.leadingBid)
    self.leadingBidder = msg.sender
    self.leadingBid = msg.value


# End the auction and send the leading bid
# to the seller.
@public
def endAuction():

    # Check if auction endtime has been reached
    assert block.timestamp >= self.endTimeOfAuction
    # Check if this function has already been called
    assert not self.ended
    self.ended = True
    send(self.seller, self.leadingBid)