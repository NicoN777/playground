package com.github.nicon777.data.schema.deserializer;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.nicon777.data.schema.entity.User;
import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.common.serialization.Deserializer;

import java.io.IOException;

public class UserDeserializer implements Deserializer<User> {
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper().findAndRegisterModules();
    @Override
    public User deserialize(String topic, byte[] bytes) {
        if (bytes == null) {
            return null;
        }

        try {
            return OBJECT_MAPPER.readValue(bytes, User.class);
        } catch (IOException e) {
            throw new SerializationException("Error deserializing JSON message.", e);
        }
    }
}
