package com.app.controller.oauth;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.app.dto.member.MemberDTO;
import com.app.service.oauth.OAuthService;

@Controller
public class OAuthController {

    @Autowired
    private OAuthService oauthService;

    private final SecureRandom secureRandom = new SecureRandom();

    private static final String GOOGLE_STATE_KEY =
            "GOOGLE_OAUTH_STATE";

    private static final String KAKAO_STATE_KEY =
            "KAKAO_OAUTH_STATE";


    /*
     * Google 로그인 시작
     */
    @GetMapping("/oauth/google")
    public String googleLogin(HttpSession session) {

        String state = createState();

        session.setAttribute(
                GOOGLE_STATE_KEY,
                state
        );

        String loginUrl =
                oauthService.getGoogleLoginUrl(state);

        return "redirect:" + loginUrl;
    }


    /*
     * Google 로그인 Callback
     */
    @GetMapping("/login/oauth2/code/google")
    public String googleCallback(
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String error,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        try {

            /*
             * state 검증
             */
            if (!validateState(
                    session,
                    GOOGLE_STATE_KEY,
                    state)) {

                redirectAttributes.addFlashAttribute(
                        "loginError",
                        "Google 로그인 요청이 올바르지 않습니다."
                );

                return "redirect:/member/signin";
            }


            /*
             * 사용자가 Google 로그인을 취소한 경우
             */
            if (error != null) {

                redirectAttributes.addFlashAttribute(
                        "loginError",
                        "Google 로그인이 취소되었습니다."
                );

                return "redirect:/member/signin";
            }


            /*
             * 인증 코드가 없는 경우
             */
            if (code == null || code.trim().isEmpty()) {

                redirectAttributes.addFlashAttribute(
                        "loginError",
                        "Google 인증 코드를 받지 못했습니다."
                );

                return "redirect:/member/signin";
            }


            /*
             * Google 로그인 처리
             */
            MemberDTO loginUser =
                    oauthService.loginWithGoogle(code);


            /*
             * 기존 일반 로그인과 같은 세션 이름 사용
             */
            session.setAttribute(
                    "loginUser",
                    loginUser
            );


            /*
             * 로그인 성공 후 메인페이지 이동
             */
            return "redirect:/RE:DAY/mainpage";


        } catch (IllegalArgumentException e) {

            redirectAttributes.addFlashAttribute(
                    "loginError",
                    e.getMessage()
            );

            return "redirect:/member/signin";


        } catch (Exception e) {

            e.printStackTrace();

            redirectAttributes.addFlashAttribute(
                    "loginError",
                    "Google 로그인 처리 중 오류가 발생했습니다."
            );

            return "redirect:/member/signin";
        }
    }


    /*
     * Kakao 로그인 시작
     */
    @GetMapping("/oauth/kakao")
    public String kakaoLogin(HttpSession session) {

        String state = createState();

        session.setAttribute(
                KAKAO_STATE_KEY,
                state
        );

        String loginUrl =
                oauthService.getKakaoLoginUrl(state);

        return "redirect:" + loginUrl;
    }


    /*
     * Kakao 로그인 Callback
     */
    @GetMapping("/oauth/kakao/callback")
    public String kakaoCallback(
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String error,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        try {

            /*
             * state 검증
             */
            if (!validateState(
                    session,
                    KAKAO_STATE_KEY,
                    state)) {

                redirectAttributes.addFlashAttribute(
                        "loginError",
                        "Kakao 로그인 요청이 올바르지 않습니다."
                );

                return "redirect:/member/signin";
            }


            /*
             * 사용자가 Kakao 로그인을 취소한 경우
             */
            if (error != null) {

                redirectAttributes.addFlashAttribute(
                        "loginError",
                        "Kakao 로그인이 취소되었습니다."
                );

                return "redirect:/member/signin";
            }


            /*
             * 인증 코드가 없는 경우
             */
            if (code == null || code.trim().isEmpty()) {

                redirectAttributes.addFlashAttribute(
                        "loginError",
                        "Kakao 인증 코드를 받지 못했습니다."
                );

                return "redirect:/member/signin";
            }


            /*
             * Kakao 로그인 처리
             */
            MemberDTO loginUser =
                    oauthService.loginWithKakao(code);


            /*
             * 기존 일반 로그인과 같은 세션 이름 사용
             */
            session.setAttribute(
                    "loginUser",
                    loginUser
            );


            /*
             * 로그인 성공 후 메인페이지 이동
             */
            return "redirect:/RE:DAY/mainpage";


        } catch (IllegalArgumentException e) {

            redirectAttributes.addFlashAttribute(
                    "loginError",
                    e.getMessage()
            );

            return "redirect:/member/signin";


        } catch (Exception e) {

            e.printStackTrace();

            redirectAttributes.addFlashAttribute(
                    "loginError",
                    "Kakao 로그인 처리 중 오류가 발생했습니다."
            );

            return "redirect:/member/signin";
        }
    }


    /*
     * OAuth CSRF 방지를 위한 state 생성
     */
    private String createState() {

        byte[] randomBytes =
                new byte[32];

        secureRandom.nextBytes(
                randomBytes
        );

        return Base64
                .getUrlEncoder()
                .withoutPadding()
                .encodeToString(randomBytes);
    }


    /*
     * Callback으로 돌아온 state와
     * Session에 저장한 state 비교
     */
    private boolean validateState(
            HttpSession session,
            String sessionKey,
            String receivedState) {

        Object savedObject =
                session.getAttribute(sessionKey);

        /*
         * 한 번 사용한 state는 바로 제거
         */
        session.removeAttribute(sessionKey);


        if (savedObject == null
                || receivedState == null) {

            return false;
        }


        String savedState =
                savedObject.toString();


        return MessageDigest.isEqual(
                savedState.getBytes(
                        StandardCharsets.UTF_8
                ),
                receivedState.getBytes(
                        StandardCharsets.UTF_8
                )
        );
    }
}