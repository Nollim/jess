FROM elasticsearch:6.8.6

RUN wget https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-icu/analysis-icu-6.8.6.zip -P /tmp
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install file:///tmp/analysis-icu-6.8.6.zip
