import java.io.IOException;

/**
 * @author Aleksandr Kurov
 * @version dated Сент. 09, 2019
 */

public class Runner {

    public static void main(String[] args) {

        App app = new App("src/main/resources/config.properties");
        int productsCnt = 120;
        String cityId = "576d0618d53f3d80945f95ae";

        try {
            System.out.println("task 1: find duplicates");
            app.fetchData(productsCnt);

            if (app.checkNoDuplicates()) {
                System.out.println("\tall products are unique");
            } else {
                app.printDuplicates();
            }

            System.out.println("\ntask 2: check city filter");

            if (app.checkCityFilter(cityId)) {
                System.out.println("\tnot all products has current cityId");
            } else {
                System.out.println("\tall products has current cityId");
            }

            //app.getAllProducts().forEach(product -> System.out.println(product.getLocation().getCityName()));

        } catch (IOException e) {
            System.err.println("ERROR while fetch products");
        }
    }
}