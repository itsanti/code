import org.junit.*;

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
        app = new App("src/test/resources/test.yml");
        productsCnt = 120;
        cityId = "576d0618d53f3d80945f95ae";
    }

    @Test
    public void getProductsWithoutCityThenCheckNoDuplicates() {
        app.fetchData(productsCnt);

        Assert.assertTrue("products without city has duplicates",
                app.checkNoDuplicates());
    }

    @Test
    public void getProductsWithoutCityThenCheckCityFilter() {
        app.fetchData(productsCnt);

        Assert.assertTrue("all products has current cityId",
                app.checkCityFilter(cityId));
    }

    @Test
    public void getProductsWithCityThenCheckNoDuplicates() {
        app.fetchDataByCity(productsCnt, cityId);

        Assert.assertTrue("products with city has duplicates",
                app.checkNoDuplicates());
    }

    @Test
    public void getProductsWithCityThenCheckCityFilter() {
        app.fetchDataByCity(productsCnt, cityId);

        Assert.assertFalse("not all products has current cityId",
                app.checkCityFilter(cityId));
    }

    @After
    public void clear() {
        app.clearProducts();
    }
}
