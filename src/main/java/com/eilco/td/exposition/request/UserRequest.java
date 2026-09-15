package com.eilco.td.exposition.request;

import com.eilco.td.domain.Gender;

public record UserRequest(String name, String email, String gender) {

}