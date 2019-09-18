/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

import retrofit2.http.GET;
import retrofit2.http.Query;
import retrofit2.Call;
import entities.*;

public interface ProductsAPI {
    @GET("products")
    Call<Interceptor<Product>> getProducts(@Query("page") int page);
    @GET("products")
    Call<Interceptor<Product>> getProductsByCity(@Query("page") int page, @Query("city") String city);
}
