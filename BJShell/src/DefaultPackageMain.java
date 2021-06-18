/**
 * @author Bryan Klumpp
 *
 *         This class is supposed to be in the default package for a small set
 *         of development functions, not used for end-user production
 *         functionality
 */
public class DefaultPackageMain {
	public static void main(String[] args) {
		System.out.println(DefaultPackageMain.class.getResource(DefaultPackageMain.class.getName() + ".class"));
	}
}
