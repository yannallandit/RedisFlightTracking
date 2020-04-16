FROM centos:7

RUN yum update -y && yum install -y gawk.x86_64 wget.x86_64 sed.x86_64
RUN yum groupinstall -y "Development Tools"

# Install Redis.
RUN \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf 

VOLUME ["/data"]

ADD . /data/

WORKDIR /data

CMD [ "redis-server", "/etc/redis/redis.conf" ] 
#CMD awk -F ',' 'FNR > 1 {print "hmset "($1)" icao24 "($1)" registration "($2)" manufacturericao "($3)" manufacturername "($4)" model "($5)" typecode "($6)" serialnumber "($7)" linenumber "($8)" icaoaircrafttype "($9)" operator "($10)" operatorcallsign "($11)" operatoricao "($12)" operatoriata "($13)" owner "($14)" testreg "($15)" registered "($16)" reguntil "($17)" status "($18)" built "($19)" firstflightdate "($20)" seatconfiguration "($21)" engines "($22)" modes "($23)" adsb "($24)" acars "($25)" notes "($26)" categoryDescription "($27)}' ./aircraftDatabase.csv | redis-cli --pipe 

EXPOSE 6379

