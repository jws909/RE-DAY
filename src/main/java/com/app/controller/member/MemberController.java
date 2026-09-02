package com.app.controller.member;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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

        MemberDTO loginUser =
                memberService.login(
                        memberDTO
                );

        System.out.println(
                "로그인 입력값 : "
                + memberDTO
        );

        System.out.println(
                "로그인 결과 : "
                + loginUser
        );


        // 로그인 실패
        if (loginUser == null) {

            model.addAttribute(
                    "loginError",
                    "이메일 또는 비밀번호가 올바르지 않습니다."
            );

            return "member/signin";
        }


        // 로그인 회원 정보를 세션에 저장
        session.setAttribute(
                "loginUser",
                loginUser
        );


        return "redirect:/RE:DAY/mainpage";
    }


    // ========================================
    // 프로필 이미지 변경
    // ========================================
    @PostMapping("/profile/image")
    public String updateProfileImage(
            MultipartFile profileImageFile,
            HttpSession session) {

        // 현재 로그인 회원 정보
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute(
                        "loginUser"
                );


        // 로그인하지 않은 경우
        if (loginUser == null) {

            return "redirect:/member/signin";
        }


        // 선택한 이미지가 없는 경우
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


        // 프로필 이미지 저장
        String profileImg =
                memberService.updateProfileImage(
                        loginUser,
                        profileImageFile
                );


        // 세션의 프로필 이미지도 변경
        loginUser.setProfileImg(
                profileImg
        );

        session.setAttribute(
                "loginUser",
                loginUser
        );


        System.out.println(
                "저장된 프로필 URL : "
                + profileImg
        );


        return "redirect:/RE:DAY/my";
    }


    // ========================================
    // 프로필 수정 페이지
    // ========================================
    @GetMapping("/profile/edit")
    public String editProfile(
            HttpSession session,
            Model model) {

        // 현재 로그인 회원 정보
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute(
                        "loginUser"
                );


        // 로그인하지 않은 경우
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

        // 현재 로그인 회원 정보
        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute(
                        "loginUser"
                );


        // 로그인하지 않은 경우
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


        // 프로필 정보 DB 수정
        int result =
                memberService.updateProfile(
                        memberDTO
                );


        // DB 수정 실패
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


        session.setAttribute(
                "loginUser",
                loginUser
        );


        // 수정 완료 후 MY 페이지로 이동
        return "redirect:/RE:DAY/my";
    }


    // ========================================
    // 회원가입 페이지
    // ========================================
    @GetMapping("/signup")
    public String signup() {

        return "member/signup";
    }


    // ========================================
    // 로그아웃 처리
    // ========================================
    @GetMapping("/logout")
    public String logout(
            HttpSession session) {

        // 로그인 세션 전체 제거
        session.invalidate();


        return "redirect:/member/signin";
    }

}