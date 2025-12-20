package hello.webservice_project_be.service;

import hello.webservice_project_be.model.User;

import java.util.List;

/**
 * 최소한의 UserService 계약(interface)입니다.
 * 프로젝트에 이미 구현체가 존재한다면 해당 구현체가 이 인터페이스를 구현하도록 맞춰주십시오.
 * 현재 AdminService 컴파일을 위해 listUsers()와 deleteUserById(int) 메서드 시그니처만 정의합니다.
 */
public interface UserService {
    List<User> listUsers();
    boolean deleteUserById(int userId);
}

