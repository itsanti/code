/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

public class NetworkService {
    private static NetworkService mInstance;
    private static final String BASE_URL = "https://api.youla.io/api/v1/";
    private Retrofit mRetrofit;

    private NetworkService() {
        mRetrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(JacksonConverterFactory.create())
                .build();
    }

    public static NetworkService getInstance() {
        if (mInstance == null) {
            mInstance = new NetworkService();
        }
        return mInstance;
    }

    public ProductsAPI getJSONApi() {
        return mRetrofit.create(ProductsAPI.class);
    }
}
