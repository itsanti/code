/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.io.IOException;
import respjson.*;

public class Runner {
    private List<Product> allProducts = new ArrayList<>();
    private static final int PRODUCTS_CNT = 120;

    public static void main(String[] args) throws IOException {

        Runner task = new Runner();

        System.out.println("task 1: find duplicates");
        task.fetchData(task.allProducts);
        List<Product> duplicates = task.findDuplicates(task.allProducts);
        if (duplicates.size() > 0) {
            duplicates.forEach(task::logProduct);
        } else {
            System.out.println("\tall products are unique");
        }
        task.allProducts.clear();

        System.out.println("\ntask 2: check city filter");

        Map<String,String> cities = Map.of(
                "Краснодар", "576d0615d53f3d80945f902c",
                "Самара", "576d0618d53f3d80945f95ae"
        );
        String cityId = cities.get("Самара");
        task.fetchData(task.allProducts, cityId);

        if (task.checkCityFilter(task.allProducts, cityId)) {
            System.out.println("\tnot all products has current cityId");
        } else {
            System.out.println("\tall products has current cityId");
        }

    }

    void logProduct(Product product) {
        String output = String.format("%s, %s - %s", product.getLocation().getCity_name(),
                product.getId(), product.getName());
        System.out.println(output);
    }

    List<Product> fetchData(List<Product> storage) throws IOException {
        return fetchData(storage, null);
    }

    List<Product> fetchData(List<Product> storage, String cityId) throws IOException {
        Products products;
        ProductsAPI productsApi = NetworkService.getInstance()
                .getJSONApi();

        for (int page = 1; storage.size() < PRODUCTS_CNT; page++) {
            if (cityId == null) {
                products = productsApi.getProducts(page)
                        .execute().body();
            } else {
                products = productsApi.getProductsByCity(page, cityId)
                        .execute().body();
            }
            storage.addAll(products.getData());
        }

        return storage;
    }

    List<Product> findDuplicates(List<Product> allProducts) {
        final Set<Product> duplicates = new HashSet<>();
        final Set<String> tmp = new HashSet<>();

        for (Product product : allProducts)
        {
            if (!tmp.add(product.getId()))
            {
                duplicates.add(product);
            }
        }
        return new ArrayList<>(duplicates);
    }

    Boolean checkCityFilter(List<Product> allProducts, String cityId) {
        return allProducts.stream()
                .anyMatch(p -> !p.getLocation().getCity().equals(cityId));
    }

}
