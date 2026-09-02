package com.app.controller.member;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.app.dto.member.MemberDTO;
import com.app.service.member.MemberService;


@Controller
@RequestMapping("/member")
public class MemberController {


    @Autowired
    MemberService memberService;


    // ========================================
    // 로그인 페이지
    // ========================================
    @GetMapping("/signin")
    public String signin() {

        return "member/signin";
    }


    // ========================================
    // 로그인 처리
    // ========================================
    @PostMapping("/signin")
    public String signinAction(
            @ModelAttribute MemberDTO memberDTO,
            HttpSession session,
            Model model) {

        System.out.println(
                "========== 로그인 시작 =========="
        );

        System.out.println(
                "email = "
                + memberDTO.getEmail()
        );


        // ========================================
        // 로그인 DB 조회
        // ========================================
        MemberDTO loginUser =
                memberService.login(
                        memberDTO
                );


        System.out.println(
                "로그인 결과 = "
                + loginUser
        );


        // ========================================
        // 로그인 실패
        // ========================================
        if (loginUser == null) {

            model.addAttribute(
                    "loginError",
                    "이메일 또는 비밀번호가 올바르지 않습니다."
            );

            return "member/signin";
        }


        // ========================================
        // 로그인 성공
        // 로그인 회원 정보를 세션에 저장
        // ========================================
        session.setAttribute(
                "loginUser",
                loginUser
        );


        System.out.println(
                "로그인 성공 : "
                + loginUser.getEmail()
        );


        System.out.println(
                "==============================="
        );


        // 메인 페이지 이동
        return "redirect:/RE:DAY/mainpage";
    }


    // ========================================
    // 회원가입 페이지
    // ========================================
    @GetMapping("/signup")
    public String signup() {

        return "member/signup";
    }


    // ========================================
    // 회원가입 처리
    // ========================================
    @PostMapping("/signup")
    public String signupAction(

            @ModelAttribute MemberDTO memberDTO,

            @RequestParam(
                    value = "interests",
                    required = false
            )
            String[] interests,

            Model model) {


        try {

            System.out.println("");
            System.out.println(
                    "======================================"
            );

            System.out.println(
                    "1. 회원가입 Controller 진입"
            );


            // ========================================
            // 입력값 출력
            // ========================================

            System.out.println(
                    "email = "
                    + memberDTO.getEmail()
            );

            System.out.println(
                    "password = "
                    + memberDTO.getPassword()
            );

            System.out.println(
                    "nickname = "
                    + memberDTO.getNickname()
            );


            // ========================================
            // 1. 닉네임 검사
            // ========================================

            if (memberDTO.getNickname() == null
                    || memberDTO
                            .getNickname()
                            .trim()
                            .isEmpty()) {


                model.addAttribute(
                        "errorMessage",
                        "닉네임을 입력해주세요."
                );


                return "member/signup";
            }


            // ========================================
            // 2. 이메일 검사
            // ========================================

            if (memberDTO.getEmail() == null
                    || memberDTO
                            .getEmail()
                            .trim()
                            .isEmpty()) {


                model.addAttribute(
                        "errorMessage",
                        "이메일을 입력해주세요."
                );


                return "member/signup";
            }


            // ========================================
            // 3. 비밀번호 검사
            // ========================================

            if (memberDTO.getPassword() == null
                    || memberDTO
                            .getPassword()
                            .length() < 8) {


                model.addAttribute(
                        "errorMessage",
                        "비밀번호는 8자 이상 입력해주세요."
                );


                return "member/signup";
            }


            // ========================================
            // 관심 키워드 처리
            // ========================================

            /*
             * JSP에서 interests를 여러 개 선택할 수 있음
             *
             * 예:
             *
             * 재택근무
             * 운동
             * 테크
             *
             * ↓
             *
             * 재택근무,운동,테크
             *
             * 형태로 DB에 저장
             */

            if (interests != null
                    && interests.length > 0) {


                String interestString =
                        String.join(
                                ",",
                                interests
                        );


                memberDTO.setInterests(
                        interestString
                );


            } else {


                memberDTO.setInterests(
                        null
                );
            }


            System.out.println(
                    "interests = "
                    + memberDTO.getInterests()
            );


            // ========================================
            // 4. 이메일 중복 검사
            // ========================================

            System.out.println(
                    "2. 이메일 중복 검사 시작"
            );


            boolean duplicated =
                    memberService
                            .isEmailDuplicated(
                                    memberDTO.getEmail()
                            );


            System.out.println(
                    "3. 이메일 중복 검사 완료 = "
                    + duplicated
            );


            // ========================================
            // 이미 가입된 이메일
            // ========================================

            if (duplicated) {


                model.addAttribute(
                        "errorMessage",
                        "이미 가입된 이메일입니다."
                );


                return "member/signup";
            }


            // ========================================
            // 5. DB INSERT
            // ========================================

            System.out.println(
                    "4. 회원 INSERT 시작"
            );


            int result =
                    memberService.signup(
                            memberDTO
                    );


            System.out.println(
                    "5. 회원 INSERT 결과 = "
                    + result
            );


            // ========================================
            // 회원가입 성공
            // ========================================

            if (result > 0) {


                System.out.println(
                        "6. 회원가입 성공"
                );


                System.out.println(
                        "가입 이메일 = "
                        + memberDTO.getEmail()
                );


                System.out.println(
                        "======================================"
                );


                // 회원가입 성공 후 로그인 페이지
                return "redirect:/member/signin";
            }


            // ========================================
            // INSERT 결과가 0인 경우
            // ========================================

            System.out.println(
                    "회원가입 INSERT 실패"
            );


            model.addAttribute(
                    "errorMessage",
                    "회원가입에 실패했습니다."
            );


            return "member/signup";


        } catch (Exception e) {


            // ========================================
            // 실제 오류 확인용
            // ========================================

            System.out.println("");
            System.out.println(
                    "========== 회원가입 실제 오류 =========="
            );


            System.out.println(
                    "오류 클래스 : "
                    + e.getClass().getName()
            );


            System.out.println(
                    "오류 메시지 : "
                    + e.getMessage()
            );


            // Eclipse Console에 전체 오류 출력
            e.printStackTrace();


            System.out.println(
                    "======================================="
            );


            // 화면에 표시되는 메시지
            model.addAttribute(
                    "errorMessage",
                    "회원가입 처리 중 오류가 발생했습니다."
            );


            return "member/signup";
        }
    }


    // ========================================
    // 프로필 이미지 변경
    // ========================================
    @PostMapping("/profile/image")
    public String updateProfileImage(

            MultipartFile profileImageFile,

            HttpSession session) {


        // ========================================
        // 로그인 회원 정보 가져오기
        // ========================================
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute(
                        "loginUser"
                );


        // ========================================
        // 로그인하지 않은 경우
        // ========================================
        if (loginUser == null) {


            return "redirect:/member/signin";
        }


        // ========================================
        // 파일 선택하지 않은 경우
        // ========================================
        if (profileImageFile == null
                || profileImageFile.isEmpty()) {


            System.out.println(
                    "선택된 프로필 사진이 없습니다."
            );


            return "redirect:/RE:DAY/my";
        }


        System.out.println(
                "선택한 파일명 : "
                + profileImageFile
                        .getOriginalFilename()
        );


        // ========================================
        // 파일 저장 + DB UPDATE
        // ========================================
        String profileImg =
                memberService
                        .updateProfileImage(
                                loginUser,
                                profileImageFile
                        );


        // ========================================
        // 로그인 회원 객체의 프로필 이미지 변경
        // ========================================
        loginUser.setProfileImg(
                profileImg
        );


        // ========================================
        // 변경된 회원 정보 세션에 저장
        // ========================================
        session.setAttribute(
                "loginUser",
                loginUser
        );


        System.out.println(
                "저장된 프로필 URL : "
                + profileImg
        );


        // MY 페이지 이동
        return "redirect:/RE:DAY/my";
    }


    // ========================================
    // 프로필 수정 페이지
    // ========================================
    @GetMapping("/profile/edit")
    public String editProfile(
            HttpSession session,
            Model model) {


        // ========================================
        // 현재 로그인 회원 정보
        // ========================================
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute(
                        "loginUser"
                );


        // ========================================
        // 로그인하지 않은 경우
        // ========================================
        if (loginUser == null) {


            return "redirect:/member/signin";
        }


        /*
         * 프로필 수정 화면에서
         * 현재 회원 정보를 사용할 수 있도록 전달
         */
        model.addAttribute(
                "loginUser",
                loginUser
        );


        // /WEB-INF/views/member/profileEdit.jsp
        return "member/profileEdit";
    }


    // ========================================
    // 프로필 정보 수정 처리
    // 현재 단계에서는 닉네임 수정
    // ========================================
    @PostMapping("/profile/edit")
    public String updateProfile(
            @ModelAttribute MemberDTO memberDTO,
            HttpSession session) {


        // ========================================
        // 현재 로그인 회원 정보
        // ========================================
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute(
                        "loginUser"
                );


        // ========================================
        // 로그인하지 않은 경우
        // ========================================
        if (loginUser == null) {


            return "redirect:/member/signin";
        }


        /*
         * 화면에서 넘어온 USER_ID를 믿지 않고
         * 현재 로그인한 회원의 USER_ID를 사용한다.
         */
        memberDTO.setUserId(
                loginUser.getUserId()
        );


        // ========================================
        // 프로필 정보 DB 수정
        // ========================================
        int result =
                memberService.updateProfile(
                        memberDTO
                );


        // ========================================
        // DB 수정 실패
        // ========================================
        if (result == 0) {


            throw new RuntimeException(
                    "프로필 정보 수정에 실패했습니다."
            );
        }


        /*
         * DB만 수정하면 현재 세션에는
         * 예전 닉네임이 남아 있으므로
         * 세션의 닉네임도 새 값으로 변경한다.
         */
        loginUser.setNickname(
                memberDTO.getNickname()
        );


        // ========================================
        // 변경된 회원 정보 세션에 다시 저장
        // ========================================
        session.setAttribute(
                "loginUser",
                loginUser
        );


        // 수정 완료 후 MY 페이지로 이동
        return "redirect:/RE:DAY/my";
    }


    // ========================================
    // 로그아웃 처리
    // ========================================
    @GetMapping("/logout")
    public String logout(
            HttpSession session) {


        // ========================================
        // 로그인 세션 전체 제거
        // ========================================
        session.invalidate();


        // 로그인 페이지 이동
        return "redirect:/member/signin";
    }

}