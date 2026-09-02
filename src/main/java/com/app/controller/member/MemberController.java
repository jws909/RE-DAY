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
                memberService.login(memberDTO);


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


        // 로그인 성공
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


        MemberDTO loginUser =
                (MemberDTO)
                session.getAttribute("loginUser");


        // 로그인 안 된 경우
        if (loginUser == null) {

            return "redirect:/member/signin";
        }


        // 파일 선택 안 한 경우
        if (profileImageFile == null
                || profileImageFile.isEmpty()) {

            System.out.println(
                    "선택된 프로필 사진이 없습니다."
            );

            return "redirect:/RE:DAY/my";
        }


        System.out.println(
                "선택한 파일명 : "
                + profileImageFile.getOriginalFilename()
        );


        // 실제 파일 저장 + DB UPDATE
        String profileImg =
                memberService.updateProfileImage(
                        loginUser,
                        profileImageFile
                );


        /*
         * 서비스에서 loginUser 객체의
         * profileImg도 변경했지만,
         * 명확하게 세션을 다시 넣어준다.
         */
        loginUser.setProfileImg(profileImg);


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

     // 현재 로그인 세션 전체 삭제
     session.invalidate();

     // 로그아웃 후 로그인 페이지로 이동
     return "redirect:/member/signin";
 }
}