package com.github.nicon777.web.user.configuration;


import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "configuration.service")
public class UserServiceConfiguration {
    public static final ObjectMapper OBJECT_MAPPER = new ObjectMapper().findAndRegisterModules();
    private String baseUrl;

    private String registrationPath;

    private String topic;

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(final String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getRegistrationPath() {
        return registrationPath;
    }

    public void setRegistrationPath(final String registrationPath) {
        this.registrationPath = registrationPath;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(final String topic) {
        this.topic = topic;
    }

    @Override
    public String toString() {
        return "UserServiceConfiguration{" +
                "baseUrl='" + baseUrl + '\'' +
                ", registrationPath='" + registrationPath + '\'' +
                ", topic='" + topic + '\'' +
                '}';
    }
}
