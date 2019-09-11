import org.junit.*;

import java.io.IOException;

/**
 * @author Aleksandr Kurov
 * @version dated Сент. 12, 2019
 */

public class AppTest {

    private static App app;
    private static int productsCnt;
    private static String cityId;

    @BeforeClass
    public static void setUp() {
        app = new App("src/test/resources/test.properties");
        productsCnt = 120;
        cityId = "576d0618d53f3d80945f95ae";
    }

    @Test
    public void getProductsWithoutCityThenCheckNoDuplicates() {
        try {
            app.fetchData(productsCnt);
        } catch (IOException e) {
            e.printStackTrace();
        }

        Assert.assertTrue(app.checkNoDuplicates());
    }

    @Test
    public void getProductsWithoutCityThenCheckCityFilter() {
        try {
            app.fetchData(productsCnt);
        } catch (IOException e) {
            e.printStackTrace();
        }

        Assert.assertTrue(app.checkCityFilter(cityId));
    }

    @Test
    public void getProductsWithCityThenCheckNoDuplicates() {
        try {
            app.fetchData(productsCnt, cityId);
        } catch (IOException e) {
            e.printStackTrace();
        }

        Assert.assertTrue(app.checkNoDuplicates());
    }

    @Test
    public void getProductsWithCityThenCheckCityFilter() {
        try {
            app.fetchData(productsCnt, cityId);
        } catch (IOException e) {
            e.printStackTrace();
        }

        Assert.assertFalse(app.checkCityFilter(cityId));
    }

    @After
    public void clear() {
        app.clearProducts();
    }
}
