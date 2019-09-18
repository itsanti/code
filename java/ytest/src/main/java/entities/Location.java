package entities;
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
    private String cityName;
    @JsonProperty("show_exact_address")
    private boolean showExactAddress;


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

    public String getCityName() {
    return cityName;
}

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public boolean getShowExactAddress() {
        return showExactAddress;
    }

    public void setShowExactAddress(boolean showExactAddress) {
        this.showExactAddress = showExactAddress;
    }
}
