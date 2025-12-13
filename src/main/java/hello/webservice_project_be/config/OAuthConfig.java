package hello.webservice_project_be.config;

import java.io.InputStream;
import java.util.Properties;

public class OAuthConfig {

    private static final Properties props = new Properties();

    static {
        try (InputStream is =
                     OAuthConfig.class
                             .getClassLoader()
                             .getResourceAsStream("github-oauth.properties")) {

            if (is == null) {
                throw new RuntimeException("github-oauth.properties 파일을 찾을 수 없습니다.");
            }

            props.load(is);

        } catch (Exception e) {
            throw new RuntimeException("OAuth 설정 로드 실패", e);
        }
    }

    public static final String CLIENT_ID =
            props.getProperty("github.client-id").trim();

    public static final String CLIENT_SECRET =
            props.getProperty("github.client-secret").trim();

    public static final String REDIRECT_URI =
            props.getProperty("github.redirect-uri").trim();
}
