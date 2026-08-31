package com.app.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.app.dto.MemberDTO;
import com.app.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;


    // ==========================================
    // 회원가입 페이지
    // ==========================================

    @GetMapping("/signup")
    public String signupPage() {

        return "member/signup";
    }


    // ==========================================
    // 회원가입
    // ==========================================

    @PostMapping("/signup")
    public String signup(
            MemberDTO member,
            @RequestParam(
                    value = "memberPwCheck",
                    defaultValue = "")
            String memberPwCheck,
            Model model) {


        // ----------------------------------
        // 닉네임 검사
        // ----------------------------------

        if (member.getNickname() == null
                || member.getNickname().trim().isEmpty()) {

            model.addAttribute(
                    "errorMessage",
                    "활동 닉네임을 입력해주세요."
            );

            model.addAttribute(
                    "member",
                    member
            );

            return "member/signup";
        }


        // ----------------------------------
        // 이메일 검사
        // ----------------------------------

        if (member.getEmail() == null
                || member.getEmail().trim().isEmpty()) {

            model.addAttribute(
                    "errorMessage",
                    "이메일 주소를 입력해주세요."
            );

            model.addAttribute(
                    "member",
                    member
            );

            return "member/signup";
        }


        // ----------------------------------
        // 비밀번호 검사
        // ----------------------------------

        if (member.getMemberPw() == null
                || member.getMemberPw().length() < 8) {

            model.addAttribute(
                    "errorMessage",
                    "비밀번호는 8자 이상 입력해주세요."
            );

            model.addAttribute(
                    "member",
                    member
            );

            return "member/signup";
        }


        // ----------------------------------
        // 비밀번호 확인
        // ----------------------------------

        if (!member.getMemberPw()
                .equals(memberPwCheck)) {

            model.addAttribute(
                    "errorMessage",
                    "비밀번호가 일치하지 않습니다."
            );

            model.addAttribute(
                    "member",
                    member
            );

            return "member/signup";
        }


        // ----------------------------------
        // 약관 동의
        // ----------------------------------

        if (!member.isTermsAgreed()) {

            model.addAttribute(
                    "errorMessage",
                    "서비스 이용약관 및 개인정보 처리방침에 동의해주세요."
            );

            model.addAttribute(
                    "member",
                    member
            );

            return "member/signup";
        }


        // ----------------------------------
        // 이메일 중복
        // ----------------------------------

        if (memberService.checkEmail(
                member.getEmail()) > 0) {

            model.addAttribute(
                    "errorMessage",
                    "이미 가입된 이메일 주소입니다."
            );

            model.addAttribute(
                    "member",
                    member
            );

            return "member/signup";
        }


        // ----------------------------------
        // 닉네임 중복
        // ----------------------------------

        if (memberService.checkNickname(
                member.getNickname()) > 0) {

            model.addAttribute(
                    "errorMessage",
                    "이미 사용 중인 닉네임입니다."
            );

            model.addAttribute(
                    "member",
                    member
            );

            return "member/signup";
        }


        // ----------------------------------
        // 회원가입 실행
        // ----------------------------------

        int result =
                memberService.signup(member);


        if (result > 0) {

            // 회원가입 성공
            return "redirect:/";
        }


        model.addAttribute(
                "errorMessage",
                "회원가입 처리 중 문제가 발생했습니다."
        );


        return "member/signup";
    }


    // ==========================================
    // 이메일 중복 확인
    // ==========================================

    @GetMapping("/checkEmail")
    @ResponseBody
    public int checkEmail(
            @RequestParam("email") String email) {

        return memberService.checkEmail(email);
    }


    // ==========================================
    // 닉네임 중복 확인
    // ==========================================

    @GetMapping("/checkNickname")
    @ResponseBody
    public int checkNickname(
            @RequestParam("nickname")
            String nickname) {

        return memberService
                .checkNickname(nickname);
    }


    // ==========================================
    // 프로필 페이지
    // ==========================================

    @GetMapping("/profile")
    public String profile(
            HttpSession session,
            Model model) {


        MemberDTO loginMember =
                (MemberDTO) session.getAttribute(
                        "loginMember"
                );


        // 아직 로그인 기능 구현 전
        if (loginMember == null) {

            return "redirect:/member/login";
        }


        MemberDTO member =
                memberService.selectMember(
                        loginMember.getMemberNo()
                );


        model.addAttribute(
                "member",
                member
        );


        return "member/profile";
    }


    // ==========================================
    // 프로필 수정
    // ==========================================

    @PostMapping("/profile")
    public String updateProfile(
            MemberDTO member,
            HttpSession session) {


        MemberDTO loginMember =
                (MemberDTO) session.getAttribute(
                        "loginMember"
                );


        if (loginMember == null) {

            return "redirect:/member/login";
        }


        // 클라이언트에서 다른 번호를
        // 임의로 보내지 못하게
        // 세션의 회원번호 사용

        member.setMemberNo(
                loginMember.getMemberNo()
        );


        int result =
                memberService.updateProfile(member);


        if (result > 0) {

            MemberDTO updatedMember =
                    memberService.selectMember(
                            loginMember.getMemberNo()
                    );


            session.setAttribute(
                    "loginMember",
                    updatedMember
            );
        }


        return "redirect:/member/profile";
    }
}