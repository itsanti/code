/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

import retrofit2.http.GET;
import retrofit2.http.Query;
import retrofit2.Call;
import respjson.Products;

public interface ProductsAPI {
    @GET("products")
    Call<Products> getProducts(@Query("page") int page);
    @GET("products")
    Call<Products> getProductsByCity(@Query("page") int page, @Query("city") String city);
}
