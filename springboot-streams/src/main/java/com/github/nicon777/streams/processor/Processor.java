package com.github.nicon777.streams.processor;

import com.github.nicon777.data.schema.entity.User;
import com.github.nicon777.data.schema.serde.UserSerde;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.kstream.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


@Component
public class Processor {
    private static final Logger log = LoggerFactory.getLogger(Processor.class);
    @Autowired
    public void processUserRegistrations(StreamsBuilder streamsBuilder) {
        final Serde<Long> longSerde = Serdes.Long();
        final Serde<User> userSerde = new UserSerde();
        final Serde<String> stringSerde = Serdes.String();

        KStream<Long, User> userRegistrationKStream = streamsBuilder
                .stream("user-registration-events");

        userRegistrationKStream.peek((k, v) -> log.info("Processing key: {}, value: {}", k, v));

        KTable<String, User> byCountryUserKTable = userRegistrationKStream
                .selectKey((k, v) -> v.getCountry())
                .toTable(Materialized.with(stringSerde, userSerde));

        KTable<String, Long> countByCountryKTable = byCountryUserKTable
                .toStream()
                .groupByKey()
                .count(Named.as("registrations-by-country"),
                        Materialized.with(stringSerde, longSerde));

        countByCountryKTable
                .toStream()
                .peek((k, v) -> log.info("Consuming here: {}, {}", k, v))
                .to("user-registrations-by-country",Produced.with(stringSerde, longSerde));
    }
}
