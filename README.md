# YNAB Amazon

Helper scripts to download all your Amazon transactions and find which ones are not tracked in YNAB, or alternatively if there are any YNAB transactions that don't correspond to Amazon transactions.

## Setup

First, install dependencies with bundler:

```
> cd ynab-amazon
> bundle
```

1. Run the GM scripts `user-script.js` on your [Amazon transactions page](https://www.amazon.com/cpe/yourpayments/transactions)
2. Export your YNAB Amazon transactions
3. Export your Chase card statement (if you have an Amazon Chase card)
4. Run the `find_untracked.rb` script to compare

```
> bundle exec find_untracked.rb ~/Downloads
```

You can compare budget to the chase card statement with the below arg. You can use this argument whether or not you provide a file path.

```
> bundle exec find_untracked.rb --chase
```

If you don't provide a file path, the script assumes `./actual-files`
