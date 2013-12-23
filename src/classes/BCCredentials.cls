/**
 * Provides access to the credentials required to access a Bigcommerce REST API.
 */
public interface BCCredentials {
	String getUsername();
    String getApiKey();
}