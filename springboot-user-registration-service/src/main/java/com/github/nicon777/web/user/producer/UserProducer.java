package com.github.nicon777.web.user.producer;

import com.github.nicon777.data.schema.entity.User;
import com.github.nicon777.web.user.configuration.UserServiceConfiguration;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

import java.util.concurrent.CompletableFuture;

@Component
public class UserProducer {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserProducer.class);
    private UserServiceConfiguration userServiceConfiguration;
    private KafkaTemplate<Long, User> userKafkaTemplate;

    @Autowired
    public UserProducer(final UserServiceConfiguration userServiceConfiguration,
                        final KafkaTemplate<Long, User> userKafkaTemplate) {
        this.userServiceConfiguration = userServiceConfiguration;
        this.userKafkaTemplate = userKafkaTemplate;
    }

    public void registerUser(final User user) {
        CompletableFuture<SendResult<Long, User>> send = userKafkaTemplate.send(
                userServiceConfiguration.getTopic(),
                user.getId(),
                user);

        send.whenComplete((result, throwable) -> {
            if (throwable != null) {
                LOGGER.error("There was an error sending message: {} to topic: {}. \n" +
                                "error: {}",
                        user,
                        userServiceConfiguration.getTopic(),
                        throwable.getMessage());
            }
            else {
                RecordMetadata recordMetadata = result.getRecordMetadata();
                LOGGER.info("Message sent to topic: {} with offset: {} and timestamp: {}",
                        recordMetadata.topic(),
                        recordMetadata.offset(),
                        recordMetadata.timestamp());
            }
        });
    }
}
