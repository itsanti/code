import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

/**
 * @author Aleksandr Kurov
 * @version dated Сент. 11, 2019
 */
public class ConfigLoader {

    private Properties properties;

    ConfigLoader(String configPath) {
        properties = new Properties();
        try {
            properties.load(new FileInputStream(configPath));
        } catch (IOException e) {
            System.err.println(String.format("ERROR: file <%s> not found", configPath));
        }
    }

    public Properties getProperties() {
        return properties;
    }
}
