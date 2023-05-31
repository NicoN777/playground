package com.github.nicon777.data.schema.serializer;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.nicon777.data.schema.entity.User;
import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.common.serialization.Serializer;

public class UserSerializer implements Serializer<User> {
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper().findAndRegisterModules();
    @Override
    public byte[] serialize(String s, User user) {
        if (user == null) {
            return null;
        }

        try {
            return OBJECT_MAPPER.writeValueAsBytes(user);
        } catch (JsonProcessingException e) {
            throw new SerializationException("Error serializing to JSON.", e);
        }
    }
}