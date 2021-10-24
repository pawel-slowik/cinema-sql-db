The entity relationship diagram was generated using
[SchemaCrawler](https://www.schemacrawler.com/):

    docker pull schemacrawler/schemacrawler

    docker run \
        --mount type=bind,source="$(pwd)",target=/home/schcrwlr \
        --rm \
        schemacrawler/schemacrawler \
        /opt/schemacrawler/schemacrawler.sh \
        --command=schema \
        --info-level=standard \
        --server=sqlite \
        --database=cinema.sqlite \
        --output-format=svg \
        --output-file=cinema.svg
