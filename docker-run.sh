docker run -d --name tvheadend -v /media/08be7bf5-795a-4f94-8ea7-0e9de2cc2156/docker-config/tvheadend-unstable:/config -v /media/08be7bf5-795a-4f94-8ea7-0e9de2cc2156/tvrecordings:/tvrecordings -v /media/08be7bf5-795a-4f94-8ea7-0e9de2cc2156/sport:/sport -v /etc/localtime:/etc/localtime:ro --net=host nmcaullay/tvheadend-unstable
