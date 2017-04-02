#!/bin/sh
#Sample Request Grafana
#Last 5 Minutes
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T19:31:21.490Z",
     "to": "2017-03-27T19:36:21.490Z",
     "raw": { "from": "now-5m", "to": "now" } },
  "rangeRaw": { "from": "now-5m", "to": "now" },
  "interval": "200ms",
  "intervalMs": 200,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 1920 }' 'http://www.swoarly.de:8080/query' > 01_last_5_minutes.txt

# Summary
# 1490642997690
# 1490642997890
# 1490642998090
# + 200
#

#Last 15 Minutes
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T19:22:06.648Z",
     "to": "2017-03-27T19:37:06.648Z",
     "raw": { "from": "now-15m", "to": "now" } },
  "rangeRaw": { "from": "now-15m", "to": "now" },
  "interval": "500ms",
  "intervalMs": 500,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 1920 }' 'http://www.swoarly.de:8080/query' > 02_last_15_minutes.txt

# Summary
# 1490642467148
# 1490642467648
# 1490642468148
# + 500
#

#Last 30 Minutes
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T19:07:46.366Z",
     "to": "2017-03-27T19:37:46.366Z",
     "raw": { "from": "now-30m", "to": "now" } },
  "rangeRaw": { "from": "now-30m", "to": "now" },
  "interval": "1s",
  "intervalMs": 1000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 1920 }' 'http://www.swoarly.de:8080/query' > 03_last_30_minutes.txt

# Summary
# 1490641547366
# 1490641548366
# 1490641549366
# + 1000
#

#Last 1 hour
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T18:41:03.947Z",
     "to": "2017-03-27T19:41:03.947Z",
     "raw": { "from": "now-1h", "to": "now" } },
  "rangeRaw": { "from": "now-1h", "to": "now" },
  "interval": "5s",
  "intervalMs": 5000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 04_last_1_hour.txt

# Summary
# 1490638948947
# 1490638953947
# 1490638958947
# + 5000
#

#Last 3 hour
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T16:41:14.033Z",
     "to": "2017-03-27T19:41:14.033Z",
     "raw": { "from": "now-3h", "to": "now" } },
  "rangeRaw": { "from": "now-3h", "to": "now" },
  "interval": "10s",
  "intervalMs": 10000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 05_last_3_hour.txt

# Summary
# 1490634244033
# 1490634254033
# 1490634264033
# + 10000
#

#Last 6 hour
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T13:41:26.402Z",
     "to": "2017-03-27T19:41:26.402Z",
     "raw": { "from": "now-6h", "to": "now" } },
  "rangeRaw": { "from": "now-6h", "to": "now" },
  "interval": "20s",
  "intervalMs": 20000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 06_last_6_hour.txt

# Summary
# 1490624826402
# 1490624846402
# 1490624866402
# + 20000
#

#Last 12 hour
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T07:41:40.725Z",
     "to": "2017-03-27T19:41:40.726Z",
     "raw": { "from": "now-12h", "to": "now" } },
  "rangeRaw": { "from": "now-12h", "to": "now" },
  "interval": "1m",
  "intervalMs": 60000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 07_last_12_hour.txt

# Summary
# 1490587120726
# 1490587180726
# 1490587240726
# + 60000
#

#Last 24 hour
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-26T19:41:51.539Z",
     "to": "2017-03-27T19:41:51.539Z",
     "raw": { "from": "now-24h", "to": "now" } },
  "rangeRaw": { "from": "now-24h", "to": "now" },
  "interval": "2m",
  "intervalMs": 120000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 08_last_24_hour.txt

# Summary
# 1490530551539
# 1490530671539
# 1490530791539
# + 120000
#

#"to"day
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-26T22:00:00.000Z",
     "to": "2017-03-27T21:59:59.999Z",
     "raw": { "from": "now/d", "to": "now/d" } },
  "rangeRaw": { "from": "now/d", "to": "now/d" },
  "interval": "2m",
  "intervalMs": 120000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 09_today.txt

# Summary
# 1490538839999
# 1490538959999
# 1490539079999
# + 120000
#

#This Week
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-26T22:00:00.000Z",
     "to": "2017-04-02T21:59:59.999Z",
     "raw": { "from": "now/w", "to": "now/w" } },
  "rangeRaw": { "from": "now/w", "to": "now/w" },
  "interval": "10m",
  "intervalMs": 600000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 10_this_week.txt

# Summary
# 1490604599999
# 1490605199999
# 1490605799999
# + 600000
#

#This Month
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-02-28T23:00:00.000Z",
     "to": "2017-03-31T21:59:59.999Z",
     "raw": { "from": "now/M", "to": "now/M" } },
  "rangeRaw": { "from": "now/M", "to": "now/M" },
  "interval": "1h",
  "intervalMs": 3600000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 11_this_month.txt

# Summary
# 1487602799999
# 1487606399999
# 1487609999999
# + 3600000
#

#This Year
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2016-12-31T23:00:00.000Z",
     "to": "2017-12-31T22:59:59.999Z",
     "raw": { "from": "now/y", "to": "now/y" } },
  "rangeRaw": { "from": "now/y", "to": "now/y" },
  "interval": "12h",
  "intervalMs": 43200000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 12_this_year.txt

# Summary
# 1474023599999
# 1474066799999
# 1474109999999
# + 43200000
#

#Last 2 days
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-25T20:42:55.519Z",
     "to": "2017-03-27T19:42:55.519Z",
     "raw": { "from": "now-2d", "to": "now" } },
  "rangeRaw": { "from": "now-2d", "to": "now" },
  "interval": "2m",
  "intervalMs": 120000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 13_last_2_days.txt

# Summary
# 1490530615519
# 1490530735519
# 1490530855519
# + 120000
#

#Last 6 months
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2016-09-27T19:43:16.439Z",
     "to": "2017-03-27T19:43:16.439Z",
     "raw": { "from": "now-6M", "to": "now" } },
  "rangeRaw": { "from": "now-6M", "to": "now" },
  "interval": "6h",
  "intervalMs": 21600000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 14_last_6_month.txt

# Summary
# 1470274996439
# 1470296596439
# 1470318196439
# + 21600000
#

#Last 2 years
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2015-03-27T20:43:41.241Z",
     "to": "2017-03-27T19:43:41.241Z",
     "raw": { "from": "now-2y", "to": "now" } },
  "rangeRaw": { "from": "now-2y", "to": "now" },
  "interval": "12h",
  "intervalMs": 43200000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 15_last_2_years.txt

# Summary
# 1449906221241
# 1449949421241
# 1449992621241
# + 43200000
#

#Yesterday
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-25T23:00:00.000Z",
     "to": "2017-03-26T21:59:59.999Z",
     "raw": { "from": "now-1d/d", "to": "now-1d/d" } },
  "rangeRaw": { "from": "now-1d/d", "to": "now-1d/d" },
  "interval": "1m",
  "intervalMs": 60000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 16_yesterday.txt

# Summary
# 1490509019999
# 1490509079999
# 1490509139999
# + 60000
#

#Day before yesterday
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-24T23:00:00.000Z",
     "to": "2017-03-25T22:59:59.999Z",
     "raw": { "from": "now-2d/d", "to": "now-2d/d" } },
  "rangeRaw": { "from": "now-2d/d", "to": "now-2d/d" },
  "interval": "2m",
  "intervalMs": 120000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 17_day_before_yesterday.txt

# Summary
# 1490369639999
# 1490369759999
# 1490369879999
# + 120000
#

#Previous week
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-19T23:00:00.000Z",
     "to": "2017-03-26T21:59:59.999Z",
     "raw": { "from": "now-1w/w", "to": "now-1w/w" } },
  "rangeRaw": { "from": "now-1w/w", "to": "now-1w/w" },
  "interval": "10m",
  "intervalMs": 600000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 18_previous_week.txt

# Summary
# 1489999799999
# 1490000399999
# 1490000999999
# + 600000
#
  
#Zoom "from" 19:30 "to" 20 
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T17:29:52.248Z",
     "to": "2017-03-27T18:00:32.960Z",
     "raw":
      { "from": "2017-03-27T17:29:52.248Z",
        "to": "2017-03-27T18:00:32.960Z" } },
  "rangeRaw":
   { "from": "2017-03-27T17:29:52.248Z",
     "to": "2017-03-27T18:00:32.960Z" },
  "interval": "2s",
  "intervalMs": 2000,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 19_zoom_30_minutes.txt

# Summary
# 1490635746960
# 1490635748960
# 1490635750960
# + 2000
#
  
#Zoom "from" 19:44 "to" 46
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T17:43:57.978Z",
     "to": "2017-03-27T17:45:56.663Z",
     "raw":
      { "from": "2017-03-27T17:43:57.978Z",
        "to": "2017-03-27T17:45:56.663Z" } },
  "rangeRaw":
   { "from": "2017-03-27T17:43:57.978Z",
     "to": "2017-03-27T17:45:56.663Z" },
  "interval": "100ms",
  "intervalMs": 100,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 20_zoom_2_minutes.txt

# Summary
# 1490636662363
# 1490636662463
# 1490636662563
# + 100
#
  
#Zoom minimum
curl -X POST --header 'Content-Type: application/json;charset=UTF-8' --header 'Accept: application/json' -d '{ "panelId": 1,
  "range":
   { "from": "2017-03-27T17:44:12.632Z",
     "to": "2017-03-27T17:44:12.880Z",
     "raw":
      { "from": "2017-03-27T17:44:12.632Z",
        "to": "2017-03-27T17:44:12.880Z" } },
  "rangeRaw":
   { "from": "2017-03-27T17:44:12.632Z",
     "to": "2017-03-27T17:44:12.880Z" },
  "interval": "10ms",
  "intervalMs": 10,
  "targets":
   [ { "target": "upper_25", "refId": "A", "type": "timeserie" },
     { "target": "upper_50", "refId": "B", "type": "timeserie" } ],
  "format": "json",
  "maxDataPoints": 944 }' 'http://www.swoarly.de:8080/query' > 21_zoom_minimum.txt

# Summary
# 1490636643450
# 1490636643460
# 1490636643470
# + 10
#