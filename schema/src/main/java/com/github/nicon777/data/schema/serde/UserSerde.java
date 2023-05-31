package com.github.nicon777.data.schema.serde;

import com.github.nicon777.data.schema.deserializer.UserDeserializer;
import com.github.nicon777.data.schema.entity.User;
import com.github.nicon777.data.schema.serializer.UserSerializer;
import org.apache.kafka.common.serialization.Deserializer;
import org.apache.kafka.common.serialization.Serde;
import org.apache.kafka.common.serialization.Serializer;

public class UserSerde implements Serde<User> {
    @Override
    public Serializer<User> serializer() {
        return new UserSerializer();
    }

    @Override
    public Deserializer<User> deserializer() {
        return new UserDeserializer();
    }
}
