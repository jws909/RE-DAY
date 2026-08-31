package com.app.controller.member;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.app.dto.member.MemberDTO;
import com.app.service.member.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    MemberService memberService;

    // 로그인 페이지
    @GetMapping("/signin")
    public String signin() {

        return "member/signin";
    }

    // 로그인 처리
    @PostMapping("/signin")
    public String signinAction(
            @ModelAttribute MemberDTO memberDTO,
            HttpSession session,
            Model model) {

        // DB에서 이메일 + 비밀번호 확인
        MemberDTO loginUser = memberService.login(memberDTO);

        // 로그인 실패
        if (loginUser == null) {
            model.addAttribute(
                "loginError",
                "이메일 또는 비밀번호가 올바르지 않습니다."
            );

            return "member/signin";
        }

        // 로그인 성공
        session.setAttribute("loginUser", loginUser);

        return "redirect:/RE:DAY/mainpage";
    }

}