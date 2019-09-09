package respjson;
import com.fasterxml.jackson.annotation.JsonProperty;
/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */
public class Location
{
    @JsonProperty("latitude")
    private float latitude;
    @JsonProperty("longitude")
    private float longitude;
    @JsonProperty("description")
    private String description;
    @JsonProperty("city")
    private String city;
    @JsonProperty("city_name")
    private String city_name;
    @JsonProperty("show_exact_address")
    private Boolean show_exact_address;


    public float getLatitude() {
        return latitude;
    }

    public void setLatitude(float latitude) {
        this.latitude = latitude;
    }

    public float getLongitude() {
        return longitude;
    }

    public void setLongitude(float longitude) {
        this.longitude = longitude;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCity_name() {
    return city_name;
}

    public void setCity_name(String city_name) {
        this.city_name = city_name;
    }
    public Boolean getShow_exact_address() {
        return show_exact_address;
    }

    public void setShow_exact_address(Boolean show_exact_address) {
        this.show_exact_address = show_exact_address;
    }
}
