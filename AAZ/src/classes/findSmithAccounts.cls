public class findSmithAccounts {
    private final List<Account> accounts;

    public findSmithAccounts() {
        accounts = [select Name from Account where Name LIKE 'Smith_%'];
    }

    public List<Account> getSmithAccounts() {
        return accounts;
    }
}