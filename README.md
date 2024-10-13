# YNAB Amazon

Helper scripts to download all your Amazon transactions and find which ones are not tracked in YNAB, or alternatively if there are any YNAB transactions that don't correspond to Amazon transactions.

## Setup

```
# 1. Run the GM scripts `user-script.js` on your Amazon transactions page
# https://www.amazon.com/cpe/yourpayments/transactions
#
# 2. Export your YNAB Amazon transactions
#
# 3. Run the `find_untracked.rb` script to compare
> find_untracked.rb ~/Downloads
```
