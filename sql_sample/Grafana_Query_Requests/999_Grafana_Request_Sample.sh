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
  "maxDataPoints": 1920 }' 'http://www.swoarly.de:3333/query' > last_5_minutes.txt

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
  "maxDataPoints": 1920 }' 'http://www.swoarly.de:3333/query' > last_15_minutes.txt

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
  "maxDataPoints": 1920 }' 'http://www.swoarly.de:3333/query' > last_30_minutes.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_1_hour.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_3_hour.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_6_hour.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_12_hour.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_24_hour.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > "to"day.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > this_week.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > this_month.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > this_year.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_2_days.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_6_month.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > last_2_years.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > yesterday.txt

#Day bevore yesterday
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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > day_bevore_yesterday.txt

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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > previous_week.txt
  
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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > zoom_30_minutes.txt
  
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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > zoom_2_minutes.txt
  
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
  "maxDataPoints": 944 }' 'http://www.swoarly.de:3333/query' > zoom_minimum.txt