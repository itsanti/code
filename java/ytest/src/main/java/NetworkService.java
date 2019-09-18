/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

import config.ApiConfig;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

class NetworkService {

    private Retrofit mRetrofit;

    NetworkService(ApiConfig properties) {
        mRetrofit = new Retrofit.Builder()
                .baseUrl(properties.getApiHost())
                .addConverterFactory(JacksonConverterFactory.create())
                .build();

    }

    ProductsAPI getProductsAPI() {
        return mRetrofit.create(ProductsAPI.class);
    }
}
