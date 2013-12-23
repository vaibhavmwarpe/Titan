public class VFContactExtension {
    private final Account acct;
    public VFContactExtension (ApexPages.StandardController controller) {
        this.acct = (Account)controller.getRecord();
    }
    public String getTitle() {
        return 'Account: ' + acct.name + ' (' + acct.id + ')';
    }
}