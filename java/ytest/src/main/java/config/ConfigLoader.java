package config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import java.io.File;
import java.io.IOException;

/**
 * @author Aleksandr Kurov
 * @version dated Сент. 11, 2019
 */
public class ConfigLoader<T> {

    private T properties;

    public ConfigLoader(String configPath, Class<T> configClass) {
        ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
        mapper.findAndRegisterModules();
        try {
            properties = mapper.readValue(new File(configPath), configClass);
        } catch (IOException e) {
            System.err.println(String.format("ERROR: file <%s> not found", configPath));
        }
    }

    public T getProperties() {
        return properties;
    }
}
