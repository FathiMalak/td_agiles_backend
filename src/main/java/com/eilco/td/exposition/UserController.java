package com.eilco.td.exposition;

import com.eilco.td.application.UserService;
import com.eilco.td.domain.User;
import com.eilco.td.exposition.request.UserRequest;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/user")
@CrossOrigin(origins =  "http://localhost:4200")
@AllArgsConstructor
public class UserController {

    private UserService userService;

    @PostMapping
    public ResponseEntity<User> addUser(@RequestBody UserRequest userRequest){
        Optional<User> createdUser =  userService.createUser(userRequest.name(), userRequest.email(), userRequest.gender());
        return createdUser.map(user -> new ResponseEntity<>(user, HttpStatus.CREATED)).orElseGet(() -> new ResponseEntity<>(HttpStatus.BAD_REQUEST));
    }

    @GetMapping
    public ResponseEntity<User> getUserByName(@RequestParam String userName){
        Optional<User> existingUser =  userService.getActualUserByName(userName);
        return existingUser.map(user -> new ResponseEntity<>(user, HttpStatus.OK)).orElseGet(() -> new ResponseEntity<>(HttpStatus.BAD_REQUEST));
    }
}
