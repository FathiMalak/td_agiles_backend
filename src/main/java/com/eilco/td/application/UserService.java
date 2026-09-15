package com.eilco.td.application;

import com.eilco.td.domain.Gender;
import com.eilco.td.domain.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Slf4j
public class UserService {

    public final List<User> users = new ArrayList<>();

    public Optional<User> createUser(String name, String email, String gender){
       User createdUser = User.createUser(name, email, Gender.valueOf(gender));
       users.add(createdUser);
       return users.stream().filter(user -> user.getUserId().equals(createdUser.getUserId())).findFirst();
    }

    public Optional<User> getActualUserByName(String userName){
        return users.stream().filter(user -> user.getName().equals(userName)).findFirst();
    }
}