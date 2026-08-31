<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로필 설정</title>
</head>

<body>

<h1>프로필 설정</h1>


<form action="${pageContext.request.contextPath}/member/profile"
      method="post">


    <!-- 아이디 -->
    <div>
        <label>아이디</label>

        <input type="text"
               value="${member.memberId}"
               readonly>
    </div>

    <br>


    <!-- 이름 -->
    <div>
        <label>이름</label>

        <input type="text"
               value="${member.memberName}"
               readonly>
    </div>

    <br>


    <!-- 닉네임 -->
    <div>
        <label for="nickname">닉네임</label>

        <input type="text"
               id="nickname"
               name="nickname"
               value="${member.nickname}"
               required>

        <button type="button"
                onclick="checkNickname()">
            중복 확인
        </button>

        <span id="nicknameMessage"></span>
    </div>

    <br>


    <!-- 이메일 -->
    <div>
        <label for="email">이메일</label>

        <input type="email"
               id="email"
               name="email"
               value="${member.email}"
               required>
    </div>

    <br>


    <!-- 프로필 이미지 -->
    <div>
        <label for="profileImage">
            프로필 이미지
        </label>

        <input type="text"
               id="profileImage"
               name="profileImage"
               value="${member.profileImage}"
               placeholder="이미지 경로">
    </div>

    <br>


    <!-- 현재 프로필 이미지 -->
    <div>

        <p>현재 프로필 이미지</p>

        <img src="${pageContext.request.contextPath}${member.profileImage}"
             alt="프로필 이미지"
             width="150"
             height="150">

    </div>

    <br>


    <!-- 자기소개 -->
    <div>

        <label for="introduction">
            자기소개
        </label>

        <br>

        <textarea id="introduction"
                  name="introduction"
                  rows="5"
                  cols="40"
                  maxlength="1000">${member.introduction}</textarea>

    </div>

    <br>


    <button type="submit">
        프로필 수정
    </button>

</form>


<script>

const contextPath =
    '${pageContext.request.contextPath}';


// 닉네임 중복 검사
function checkNickname() {

    const nickname =
        document.getElementById("nickname").value.trim();

    const message =
        document.getElementById("nicknameMessage");


    if (nickname === "") {

        message.innerText =
            "닉네임을 입력해주세요.";

        return;
    }


    fetch(
        contextPath
        + "/member/checkNickname?nickname="
        + encodeURIComponent(nickname)
    )
    .then(response => response.text())
    .then(result => {

        if (Number(result) === 0) {

            message.innerText =
                "사용 가능한 닉네임입니다.";

        } else {

            message.innerText =
                "이미 사용 중인 닉네임입니다.";
        }
    });

}

</script>

</body>
</html>