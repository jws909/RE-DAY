package com.app.service.oauth.impl;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.app.dao.oauth.OAuthMemberDAO;
import com.app.dto.member.MemberDTO;
import com.app.dto.oauth.OAuthUserDTO;
import com.app.service.oauth.OAuthService;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service
public class OAuthServiceImpl implements OAuthService {

    // Google OAuth 주소
    private static final String GOOGLE_AUTH_URL =
            "https://accounts.google.com/o/oauth2/v2/auth";

    private static final String GOOGLE_TOKEN_URL =
            "https://oauth2.googleapis.com/token";

    private static final String GOOGLE_USERINFO_URL =
            "https://openidconnect.googleapis.com/v1/userinfo";


    // Kakao OAuth 주소
    private static final String KAKAO_AUTH_URL =
            "https://kauth.kakao.com/oauth/authorize";

    private static final String KAKAO_TOKEN_URL =
            "https://kauth.kakao.com/oauth/token";

    private static final String KAKAO_USERINFO_URL =
            "https://kapi.kakao.com/v2/user/me";


    private final HttpClient httpClient =
            HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(10))
                    .build();


    @Autowired
    private OAuthMemberDAO oauthMemberDAO;


    /*
     * Google 로그인 페이지 URL 생성
     */
    @Override
    public String getGoogleLoginUrl(String state) {

        String clientId = requiredConfig("GOOGLE_CLIENT_ID");
        String redirectUri = requiredConfig("GOOGLE_REDIRECT_URI");

        return GOOGLE_AUTH_URL
                + "?client_id=" + encode(clientId)
                + "&redirect_uri=" + encode(redirectUri)
                + "&response_type=code"
                + "&scope=" + encode("openid email profile")
                + "&state=" + encode(state);
    }


    /*
     * Google 로그인 처리
     */
    @Override
    public MemberDTO loginWithGoogle(String code) {

        try {

            String clientId = requiredConfig("GOOGLE_CLIENT_ID");
            String clientSecret = requiredConfig("GOOGLE_CLIENT_SECRET");
            String redirectUri = requiredConfig("GOOGLE_REDIRECT_URI");


            /*
             * 1. Google에서 Access Token 받기
             */
            Map<String, String> tokenParams = new LinkedHashMap<>();

            tokenParams.put("client_id", clientId);
            tokenParams.put("client_secret", clientSecret);
            tokenParams.put("code", code);
            tokenParams.put("grant_type", "authorization_code");
            tokenParams.put("redirect_uri", redirectUri);


            JsonObject tokenJson =
                    postForm(GOOGLE_TOKEN_URL, tokenParams);


            String accessToken =
                    getString(tokenJson, "access_token");


            if (isBlank(accessToken)) {
                throw new IllegalStateException(
                        "Google Access Token을 받지 못했습니다."
                );
            }


            /*
             * 2. Google 사용자 정보 요청
             */
            JsonObject userJson =
                    getWithBearer(
                            GOOGLE_USERINFO_URL,
                            accessToken
                    );


            String providerId =
                    getString(userJson, "sub");

            String email =
                    getString(userJson, "email");

            String nickname =
                    getString(userJson, "name");

            String profileImg =
                    getString(userJson, "picture");


            if (isBlank(providerId)) {
                throw new IllegalStateException(
                        "Google 사용자 고유 ID를 가져오지 못했습니다."
                );
            }


            if (isBlank(email)) {
                throw new IllegalStateException(
                        "Google 이메일 정보를 가져오지 못했습니다."
                );
            }


            /*
             * email_verified 값이 존재하면 인증 여부 확인
             */
            if (userJson.has("email_verified")) {

                boolean emailVerified =
                        userJson.get("email_verified")
                                .getAsBoolean();

                if (!emailVerified) {
                    throw new IllegalArgumentException(
                            "인증되지 않은 Google 이메일입니다."
                    );
                }
            }


            /*
             * 3. OAuth 사용자 정보 생성
             */
            OAuthUserDTO oauthUser =
                    new OAuthUserDTO();

            oauthUser.setEmail(email);
            oauthUser.setNickname(nickname);
            oauthUser.setProfileImg(profileImg);

            oauthUser.setProvider("GOOGLE");
            oauthUser.setProviderId(providerId);


            /*
             * 4. 기존 회원 로그인 또는 신규 가입
             */
            return loginOrCreate(oauthUser);

        } catch (IOException | InterruptedException e) {

            Thread.currentThread().interrupt();

            throw new IllegalStateException(
                    "Google 로그인 처리 중 오류가 발생했습니다.",
                    e
            );
        }
    }


    /*
     * Kakao 로그인 페이지 URL 생성
     */
    @Override
    public String getKakaoLoginUrl(String state) {

        String clientId =
                requiredConfig("KAKAO_REST_API_KEY");

        String redirectUri =
                requiredConfig("KAKAO_REDIRECT_URI");


        return KAKAO_AUTH_URL
                + "?client_id=" + encode(clientId)
                + "&redirect_uri=" + encode(redirectUri)
                + "&response_type=code"
                + "&state=" + encode(state);
    }


    /*
     * Kakao 로그인 처리
     */
    @Override
    public MemberDTO loginWithKakao(String code) {

        try {

            String clientId =
                    requiredConfig("KAKAO_REST_API_KEY");

            String redirectUri =
                    requiredConfig("KAKAO_REDIRECT_URI");

            String clientSecret =
                    optionalConfig("KAKAO_CLIENT_SECRET");


            /*
             * 1. Kakao에서 Access Token 받기
             */
            Map<String, String> tokenParams =
                    new LinkedHashMap<>();

            tokenParams.put(
                    "grant_type",
                    "authorization_code"
            );

            tokenParams.put(
                    "client_id",
                    clientId
            );

            tokenParams.put(
                    "redirect_uri",
                    redirectUri
            );

            tokenParams.put(
                    "code",
                    code
            );


            /*
             * Kakao Client Secret을 사용하는 경우
             */
            if (!isBlank(clientSecret)) {
                tokenParams.put(
                        "client_secret",
                        clientSecret
                );
            }


            JsonObject tokenJson =
                    postForm(
                            KAKAO_TOKEN_URL,
                            tokenParams
                    );


            String accessToken =
                    getString(
                            tokenJson,
                            "access_token"
                    );


            if (isBlank(accessToken)) {
                throw new IllegalStateException(
                        "Kakao Access Token을 받지 못했습니다."
                );
            }


            /*
             * 2. Kakao 사용자 정보 가져오기
             */
            JsonObject userJson =
                    getWithBearer(
                            KAKAO_USERINFO_URL,
                            accessToken
                    );


            String providerId = null;
            String email = null;
            String nickname = null;
            String profileImg = null;


            if (userJson.has("id")) {
                providerId =
                        userJson.get("id")
                                .getAsString();
            }


            JsonObject kakaoAccount =
                    getObject(
                            userJson,
                            "kakao_account"
                    );


            if (kakaoAccount != null) {

                email =
                        getString(
                                kakaoAccount,
                                "email"
                        );


                JsonObject profile =
                        getObject(
                                kakaoAccount,
                                "profile"
                        );


                if (profile != null) {

                    nickname =
                            getString(
                                    profile,
                                    "nickname"
                            );

                    profileImg =
                            getString(
                                    profile,
                                    "profile_image_url"
                            );
                }
            }


            if (isBlank(providerId)) {
                throw new IllegalStateException(
                        "Kakao 사용자 고유 ID를 가져오지 못했습니다."
                );
            }

            if (isBlank(email)) {
                email = "kakao_"
                        + providerId
                        + "@oauth.reday.local";
            }


            /*
             * 3. OAuth 사용자 정보 생성
             */
            OAuthUserDTO oauthUser =
                    new OAuthUserDTO();

            oauthUser.setEmail(email);
            oauthUser.setNickname(nickname);
            oauthUser.setProfileImg(profileImg);

            oauthUser.setProvider("KAKAO");
            oauthUser.setProviderId(providerId);


            /*
             * 4. 기존 회원 로그인 또는 신규 회원가입
             */
            return loginOrCreate(oauthUser);

        } catch (IOException | InterruptedException e) {

            Thread.currentThread().interrupt();

            throw new IllegalStateException(
                    "Kakao 로그인 처리 중 오류가 발생했습니다.",
                    e
            );
        }
    }


    /*
     * 이미 가입된 소셜 회원이면 로그인
     * 처음 로그인한 회원이면 신규 가입
     */
    private MemberDTO loginOrCreate(
            OAuthUserDTO oauthUser) {

        /*
         * PROVIDER + PROVIDER_ID로 회원 조회
         */
        MemberDTO member =
                oauthMemberDAO.findMemberByProvider(
                        oauthUser.getProvider(),
                        oauthUser.getProviderId()
                );


        /*
         * 이미 소셜 가입된 회원이면 바로 로그인
         */
        if (member != null) {
            return member;
        }


        /*
         * 같은 이메일의 기존 회원 확인
         */
        MemberDTO emailMember =
                oauthMemberDAO.findMemberByEmail(
                        oauthUser.getEmail()
                );


        /*
         * 같은 이메일로 LOCAL 또는 다른 방식의 회원이
         * 이미 존재하면 자동 연결하지 않음
         */
        if (emailMember != null) {

            throw new IllegalArgumentException(
                    "이미 같은 이메일로 가입된 계정이 있습니다. "
                    + "기존 로그인 방법으로 로그인해주세요."
            );
        }


        /*
         * 신규 소셜 회원 정보 생성
         */
        oauthUser.setUserId(
                generateUserId()
        );

        oauthUser.setPassword(
                generateUnusedPassword()
        );

        oauthUser.setNickname(
                makeNickname(
                        oauthUser.getNickname(),
                        oauthUser.getProvider(),
                        oauthUser.getProviderId()
                )
        );

        oauthUser.setInterests(null);


        /*
         * DB INSERT
         */
        int result =
                oauthMemberDAO.insertOAuthMember(
                        oauthUser
                );


        if (result != 1) {
            throw new IllegalStateException(
                    "소셜 회원가입에 실패했습니다."
            );
        }


        /*
         * 방금 가입된 회원 다시 조회
         */
        member =
                oauthMemberDAO.findMemberByProvider(
                        oauthUser.getProvider(),
                        oauthUser.getProviderId()
                );


        if (member == null) {
            throw new IllegalStateException(
                    "가입된 회원 정보를 불러오지 못했습니다."
            );
        }


        return member;
    }


    /*
     * RE:DAY 내부 USER_ID 생성
     */
    private String generateUserId() {

        String uuid =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "");

        return "S"
                + uuid.substring(0, 19);
    }


    /*
     * 소셜 회원용 내부 비밀번호
     *
     * 실제 로그인에는 사용하지 않음
     */
    private String generateUnusedPassword() {

        String uuid =
                UUID.randomUUID()
                        .toString()
                        .replace("-", "");

        return "S_"
                + uuid.substring(0, 18);
    }


    /*
     * 닉네임 생성
     */
    private String makeNickname(
            String nickname,
            String provider,
            String providerId) {

        String baseNickname = nickname;

        if (isBlank(baseNickname)) {
            baseNickname = "사용자";
        }

        baseNickname =
                baseNickname.trim();


        /*
         * 닉네임 길이가 너무 길면 줄임
         */
        if (baseNickname.length() > 10) {
            baseNickname =
                    baseNickname.substring(0, 10);
        }


        String providerCode =
                "GOOGLE".equals(provider)
                        ? "G"
                        : "K";


        String suffix = providerId;

        if (suffix.length() > 4) {
            suffix =
                    suffix.substring(
                            suffix.length() - 4
                    );
        }


        return baseNickname
                + "_"
                + providerCode
                + suffix;
    }


    /*
     * POST Form 요청
     */
    private JsonObject postForm(
            String url,
            Map<String, String> params)
            throws IOException, InterruptedException {

        String body =
                toFormData(params);


        HttpRequest request =
                HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .timeout(Duration.ofSeconds(15))
                        .header(
                                "Content-Type",
                                "application/x-www-form-urlencoded;charset=UTF-8"
                        )
                        .POST(
                                HttpRequest.BodyPublishers
                                        .ofString(body)
                        )
                        .build();


        HttpResponse<String> response =
                httpClient.send(
                        request,
                        HttpResponse.BodyHandlers.ofString()
                );


        if (response.statusCode() < 200
                || response.statusCode() >= 300) {

            throw new IllegalStateException(
                    "OAuth 요청 실패: HTTP "
                    + response.statusCode()
            );
        }


        return JsonParser
                .parseString(response.body())
                .getAsJsonObject();
    }


    /*
     * Bearer Token을 이용한 GET 요청
     */
    private JsonObject getWithBearer(
            String url,
            String accessToken)
            throws IOException, InterruptedException {

        HttpRequest request =
                HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .timeout(Duration.ofSeconds(15))
                        .header(
                                "Authorization",
                                "Bearer " + accessToken
                        )
                        .GET()
                        .build();


        HttpResponse<String> response =
                httpClient.send(
                        request,
                        HttpResponse.BodyHandlers.ofString()
                );


        if (response.statusCode() < 200
                || response.statusCode() >= 300) {

            throw new IllegalStateException(
                    "사용자 정보 요청 실패: HTTP "
                    + response.statusCode()
            );
        }


        return JsonParser
                .parseString(response.body())
                .getAsJsonObject();
    }


    /*
     * Form 데이터를 문자열로 변환
     */
    private String toFormData(
            Map<String, String> params) {

        return params
                .entrySet()
                .stream()
                .map(entry ->
                        encode(entry.getKey())
                        + "="
                        + encode(entry.getValue())
                )
                .collect(
                        Collectors.joining("&")
                );
    }


    /*
     * URL Encoding
     */
    private String encode(String value) {

        return URLEncoder.encode(
                value,
                StandardCharsets.UTF_8
        );
    }


    /*
     * JSON 문자열 가져오기
     */
    private String getString(
            JsonObject object,
            String key) {

        if (object == null
                || !object.has(key)) {
            return null;
        }


        JsonElement element =
                object.get(key);


        if (element == null
                || element.isJsonNull()) {
            return null;
        }


        return element.getAsString();
    }


    /*
     * JSON Object 가져오기
     */
    private JsonObject getObject(
            JsonObject object,
            String key) {

        if (object == null
                || !object.has(key)) {
            return null;
        }


        JsonElement element =
                object.get(key);


        if (element == null
                || element.isJsonNull()
                || !element.isJsonObject()) {
            return null;
        }


        return element.getAsJsonObject();
    }


    /*
     * 필수 설정값 읽기
     */
    private String requiredConfig(String key) {

        String value =
                optionalConfig(key);


        if (isBlank(value)) {
            throw new IllegalStateException(
                    key + " 설정이 없습니다."
            );
        }


        return value.trim();
    }


    /*
     * 환경변수 또는 JVM 설정값 읽기
     */
    private String optionalConfig(String key) {

        String value =
                System.getenv(key);


        if (isBlank(value)) {
            value =
                    System.getProperty(key);
        }


        return value;
    }


    /*
     * null / 빈 문자열 확인
     */
    private boolean isBlank(String value) {

        return value == null
                || value.trim().isEmpty();
    }
}