package com.app.dto.oauth;

import lombok.Data;

@Data
public class OAuthUserDTO {

    private String userId;
    private String email;
    private String password;
    private String nickname;
    private String profileImg;

    private String provider;
    private String providerId;

    private String interests;
}