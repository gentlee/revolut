# Test app for revolut #

### Project description: ###

* MVVM + KVO.
* Storyboard only.
* Reuse similar views.
* Rates are random and updated every 30 seconds.

### Requirements: ###

Make an app that exchanges currencies using [ECB rates](http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml).

* Use Objective-C or Swift.
* Exchange rates should be updating every 30 seconds.
* 3 currencies to be exchanged: EUR, USD, GBP.
* 2 currencies are shown on screen at one time. Switch between currencies using carousel (after last currency goes first). 
* User can edit either of currency fields causing second to recalculate its value. Also should recalculate field when switching between currencies.
* Show active currency rate.
* On “Exchange” tap perform exchange operation.
* User has 100 units of each currency on launch of the app.
* If the user has insufficient funds before exchange, need to inform him about that.


Extra attention to code quality.

Upload your code to github or bitbucket.

You are free to use any external dependencies if you need them. (But do not abuse them).
You are not obliged to reproduce the design attached, just need to make the app look user-friendly and easy to use.

* [UI Example](https://drive.google.com/open?id=0B5UMc7RikYaEZUJKMi05TkY0MVk).
* [Sample video](https://www.youtube.com/watch?v=c0zPSiKYipc), showing app workflow.