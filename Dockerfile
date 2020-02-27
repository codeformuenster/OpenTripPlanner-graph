FROM codeformuenster/opentripplanner:master

COPY ./files ./graphs/cfm

RUN apk --no-cache add zip \
    && mkdir -p ./graphs/cfm \
    && cd ./graphs/cfm \
    && curl -sSfL -o ./STWMS.zip \
        # https://www.stadtwerke-muenster.de/privatkunden/mobilitaet/fahrplaninfos/fahr-netzplaene-downloads/open-data-gtfs/gtfs-download.html
        https://www.stadtwerke-muenster.de/fileadmin/stwms/busverkehr/kundencenter/dokumente/GTFS/stadtwerke_feed_bis_200419.zip \
    # add feed-info.txt to zip
    && zip ./STWMS.zip ./feed_info.txt \
    && curl -sSfL -o ./muenster-regbez.pbf \
        # https://download.geofabrik.de/europe/germany/nordrhein-westfalen/
        https://download.geofabrik.de/europe/germany/nordrhein-westfalen/muenster-regbez-200226.osm.pbf \
    && rm ./feed_info.txt \
    && java -Xmx14g -jar /opt/opentripplanner/otp-shaded.jar --build . \
    && rm ./muenster-regbez.pbf ./STWMS.zip \
    && apk del zip
