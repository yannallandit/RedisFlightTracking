# RedisFlightTracking

## Purpose
This project explain how to incorporate the WW aircrafts list into a Redis database stored in a container.

## How to build your image
The aircraft database is initially provided in a csv format. You might have to "clean" the file before using it as it is not always ready to use.

1 wget the lastest csv file from https://opensky-network.org/datasets/metadata/. The one provided here is from the 14th of April 2020.

2 If not using the file provided here, clean it up using vi or sed.

3 Import the data into an existing Redis instance using the following command: 

`# awk -F ',' 'FNR > 1 {print "hmset "($1)" icao24 "($1)" registration "($2)" manufacturericao "($3)" manufacturername "($4)" model "($5)" typecode "($6)" serialnumber "($7)" linenumber "($8)" icaoaircrafttype "($9)" operator "($10)" operatorcallsign "($11)" operatoricao "($12)" operatoriata "($13)" owner "($14)" testreg "($15)" registered "($16)" reguntil "($17)" status "($18)" built "($19)" firstflightdate "($20)" seatconfiguration "($21)" engines "($22)" modes "($23)" adsb "($24)" acars "($25)" notes "($26)" categoryDescription "($27)}' ./aircraftDatabase.csv | redis-cli --pipe

4 It will generate a file called dump.rdb. Copy this file into your working directory, where you build your Docker image containing the Dockerfile.

5 If using the provided dump.rdb file, gunzip it before usage.

6 Build you docker image:

`# docker build -t redisft .

7 You are ready to use the Redis container with your own data.

## How to use the existing container
1 An existing container is stored in docker.io: https://hub.docker.com/repository/docker/yallandit/redisft

2 Start the redisft container:

`# docker run --name redisft  -p 6379:6379 -d redisft

3 Check it is up and running

`# docker ps

4 Get connected to your redis DB:

`# docker exec -ti redisft bash
`# [root@f4c4af1329ff data]# redis-cli

5 Check if the data are available:

`# 127.0.0.1:6379> hget a9dfd8 engines
`# "CONT MOTOR O-470 SERIES"


