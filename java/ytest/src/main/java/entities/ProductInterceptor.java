package entities;

/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown=true)
public class ProductInterceptor
{
    @JsonProperty("data")
    private List<Product> data;
    @JsonProperty("status")
    private int status;
    @JsonProperty("detail")
    private String detail;

    public void setData(List<Product> data){
        this.data = data;
    }
    public List<Product> getData(){
        return data;
    }
    public void setStatus(int status){
        this.status = status;
    }
    public int getStatus(){
        return status;
    }
    public void setDetail(String detail){
        this.detail = detail;
    }
    public String getDetail(){
        return detail;
    }
}