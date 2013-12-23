/*VW - 1*/
public class BCNewProductsCreator implements System.Schedulable{
    public void execute(System.SchedulableContext sc){
        BCProductsViewCon.fetchProductsFromFuture();
        List<String> productsFromBC = BCProductsViewCon.productsFromFuture;
        System.debug('===BCNewProductsCreator.execute====productsFromBC=====' + productsFromBC);
    }

}