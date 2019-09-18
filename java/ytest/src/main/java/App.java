import config.*;
import entities.*;
import java.util.*;
import java.io.IOException;

/**
 * @author Aleksandr Kurov
 * @version dated Сент. 11, 2019
 */
class App {

    private ApiConfig config;
    private List<Product> allProducts;

    App(String configPath) {
        config = new ConfigLoader<>(configPath, ApiConfig.class).getProperties();
        allProducts = new ArrayList<>();
    }

    void fetchData(int productsCnt) {
        Interceptor<Product> interceptor;

        ProductsAPI productsApi = new NetworkService(config)
                .getProductsAPI();
        try {
            for (int page = 1; allProducts.size() < productsCnt; page++) {

                    interceptor = productsApi.getProducts(page)
                                    .execute().body();
                allProducts.addAll(interceptor.getData());
            }
        } catch (IOException e) {
            System.err.println("ERROR: fetch data error");
        }
    }

    void fetchDataByCity(int productsCnt, String cityId) {
        Interceptor<Product> interceptor;

        ProductsAPI productsApi = new NetworkService(config)
                .getProductsAPI();
        try {
            for (int page = 1; allProducts.size() < productsCnt; page++) {
                    interceptor = productsApi.getProductsByCity(page, cityId)
                            .execute().body();
                allProducts.addAll(interceptor.getData());
            }
        } catch (IOException e) {
            System.err.println("ERROR: fetch data by city error");
        }
    }

    void printDuplicates() {
        Set<String> tmp = new HashSet<>();

        for (Product product : allProducts) {
            if (!tmp.add(product.getId())) {
                logProduct(product);
            }
        }
    }

    boolean checkNoDuplicates() {
        return allProducts.stream()
                .distinct().count() == allProducts.size();
    }

    boolean checkCityFilter(String cityId) {
        return allProducts.stream()
                .anyMatch(p -> !p.getLocation().getCity().equals(cityId));
    }

    void logProduct(Product product) {
        String output = String.format("%s, %s - %s", product.getLocation().getCityName(),
                product.getId(), product.getName());
        System.out.println(output);
    }

    void clearProducts() {
        allProducts.clear();
    }

    List<Product> getAllProducts() {
        return allProducts;
    }
}
