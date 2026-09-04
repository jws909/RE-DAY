package com.app.dto.member;

import lombok.Data;

@Data
public class MemberDTO {

    private String userId;
    private String email;
    private String password;
    private String nickname;
    private String profileImg;
    private String provider;
    private Integer cheerCount;
    private String userLevel;
    private String interests;
    private String isPublic;
    private Integer streakCount;
    
    private String providerId;

}