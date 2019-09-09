package respjson;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */
@JsonIgnoreProperties(ignoreUnknown=true)
public class Product
{
    @JsonProperty("id")
    private String id;
    @JsonProperty("location")
    private Location location;
    @JsonProperty("name")
    private String name;


    public void setId(String id){this.id = id;}
    public String getId(){return id;}

    public void setLocation(Location location){this.location = location;}
    public Location getLocation(){return location;}

    public void setName(String name){this.name = name;}
    public String getName(){return name;}
}