## Usage
To initialize a project with this example, run `truffle unbox webpack` inside an empty directory.

## Building the frontend
1. First run `truffle compile`, then run `truffle migrate` to deploy the contracts onto your network of choice (default "development").
2. Then run `npm run dev` from app folder to build the app and serve it on http://localhost:8080

## Possible upgrades
* Use the webpack hotloader to sense when contracts or javascript have been recompiled and rebuild the application. Contributions welcome!
