package com.github.nicon777.web.user.handler;

import com.github.nicon777.data.schema.entity.User;
import com.github.nicon777.web.user.producer.UserProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

@Component
public class UserHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserHandler.class);
    private UserProducer userProducer;

    @Autowired
    public UserHandler(UserProducer userProducer) {
        this.userProducer = userProducer;
    }

    public Mono<ServerResponse> registerUser(ServerRequest request) {
        Mono<User> userMono = request.bodyToMono(User.class);
        return userMono.doOnNext(user -> userProducer.registerUser(user))
                .flatMap(user -> ServerResponse.ok().build());
    }
}
