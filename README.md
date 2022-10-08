# Scraping Dailymotion Archives

Dailymotion has archives of videos [here](https://www.dailymotion.com/archived/index.html).  It has the following hierarchy:

1. Year
2. Month
3. Day
4. Morning, Noon , Evening
5. Urls of videos (titles and url)

The code starts at the highest level and goes down by searching for links with specific attributes. At the level 5, it places a **Asynchronous** request
for all urls using Curl. Once response is received for all urls, attributes are parsed from html. Finally, the video title and url are saved in a dataframe.

The code can be configured to run for only few years of data.

### TODO

 - As the data to be parsed is quite huge from 2006-2022, Async probably should be implemented at a higher level.

 - Also, the code needs to be deployed on VM on GCP or AWS since it will run for quite a number of hours.




