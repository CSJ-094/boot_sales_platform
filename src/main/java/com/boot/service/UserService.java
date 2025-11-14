package com.boot.service;

import com.boot.dao.MemDAO;
import com.boot.dto.MemDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private MemDAO userMapper;

    public MemDTO getUserById(String memberId) {
        return userMapper.getUserById(memberId);
    }
}
