FROM codeformuenster/opentripplanner:master

COPY ./build-config.json ./graphs/cfm/
COPY ./router-config.json ./graphs/cfm/

RUN mkdir -p ./graphs/cfm \
    && cd ./graphs/cfm \
    && curl -sSfL -o ./STWMS.zip \
        # https://www.stadtwerke-muenster.de/privatkunden/mobilitaet/fahrplaninfos/fahr-netzplaene-downloads/open-data-gtfs/gtfs-download.html
        https://www.stadtwerke-muenster.de/fileadmin/stwms/busverkehr/kundencenter/dokumente/GTFS/stadtwerke_feed_20191028.zip \
    && curl -sSfL -o ./muenster-regbez.pbf \
        # https://download.geofabrik.de/europe/germany/nordrhein-westfalen/
        https://download.geofabrik.de/europe/germany/nordrhein-westfalen/muenster-regbez-191112.osm.pbf \
    && java -Xmx10g -jar /opt/opentripplanner/otp-shaded.jar --build . \
    && rm ./muenster-regbez.pbf ./STWMS.zip
