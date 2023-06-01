package com.github.nicon777.web.user.router;

import com.github.nicon777.web.user.configuration.UserServiceConfiguration;
import com.github.nicon777.web.user.handler.UserHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.ServerResponse;

import static org.springframework.web.reactive.function.server.RouterFunctions.route;

@Component
public class UserRouter {

    private UserServiceConfiguration userServiceConfiguration;
    private UserHandler userHandler;

    @Autowired
    public UserRouter(final UserServiceConfiguration userServiceConfiguration, final UserHandler userHandler) {
        this.userServiceConfiguration = userServiceConfiguration;
        this.userHandler = userHandler;
    }

    @Bean
    public RouterFunction<ServerResponse> userRouterFunction() {
        return route()
                .POST(userServiceConfiguration.getRegistrationPath(), userHandler::registerUser)
                .build();
    }
}
