import entities.*;
import java.util.*;
import java.io.IOException;

/**
 * @author Aleksandr Kurov
 * @version dated Сент. 11, 2019
 */
class App {

    private Properties config;
    private List<Product> allProducts;

    App(String configPath) {
        config = new ConfigLoader(configPath).getProperties();
        allProducts = new ArrayList<>();
    }

    List<Product> fetchData(int productsCnt) throws IOException {
        return fetchData(productsCnt, null);
    }

    List<Product> fetchData(int productsCnt, String cityId) throws IOException {
        ProductInterceptor productInterceptor;

        ProductsAPI productsApi = new NetworkService(config)
                .getProductsAPI();

        for (int page = 1; allProducts.size() < productsCnt; page++) {
            if (cityId == null) {
                productInterceptor = productsApi.getProducts(page)
                        .execute().body();
            } else {
                productInterceptor = productsApi.getProductsByCity(page, cityId)
                        .execute().body();
            }
            allProducts.addAll(productInterceptor.getData());
        }

        return allProducts;
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
