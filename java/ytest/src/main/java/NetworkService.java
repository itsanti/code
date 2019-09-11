/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;
import java.util.Properties;

class NetworkService {

    private Retrofit mRetrofit;

    NetworkService(Properties properties) {
        mRetrofit = new Retrofit.Builder()
                .baseUrl(properties.getProperty("api.host"))
                .addConverterFactory(JacksonConverterFactory.create())
                .build();

    }

    ProductsAPI getProductsAPI() {
        return mRetrofit.create(ProductsAPI.class);
    }
}
