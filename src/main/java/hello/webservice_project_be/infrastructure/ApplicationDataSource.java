package hello.webservice_project_be.infrastructure;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 애플리케이션 기본 JDBC 커넥션 팩토리.
 * MyBatis 외에 순수 JDBC가 필요한 레거시 DAO에서 사용합니다.
 */
public class ApplicationDataSource {

    // MariaDB 연결 정보 - 환경에 맞게 변경하세요.
    // 전체 URL에 데이터베이스명을 포함해야 INSERT/SELECT가 정상 동작합니다.
    private static final String DB_URL = "jdbc:mariadb://walab.handong.edu:3306/W25_22400742";
    private static final String DB_USER = "W25_22400742";
    private static final String DB_PASSWORD = "iWie8s";

    private static Connection connection;

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("org.mariadb.jdbc.Driver");
                connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            } catch (ClassNotFoundException e) {
                throw new SQLException("MariaDB JDBC 드라이버를 찾을 수 없습니다.", e);
            }
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
            } catch (SQLException e) {
                System.err.println("데이터베이스 연결 종료 오류: " + e.getMessage());
            }
        }
    }

    // 새로고침 트랜잭션 등에서 전역 커넥션에 영향 주지 않기 위해 새로운 Connection을 생성해서 반환합니다.
    public static Connection getNewConnection() throws SQLException {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MariaDB JDBC 드라이버를 찾을 수 없습니다.", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
