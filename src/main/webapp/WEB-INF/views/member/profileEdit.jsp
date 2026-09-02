<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>

<meta charset="UTF-8">

<title>RE:DAY - 프로필 수정</title>


<%-- =========================================
     공통 HEAD
========================================= --%>
<%@ include file="/WEB-INF/views/include/head.jsp"%>


<%-- =========================================
     프로필 수정 페이지 CSS
========================================= --%>
<style>

/* =========================================
       프로필 수정 전체 영역
    ========================================= */
.profile_edit_container {
	width: 100%;
	max-width: 700px;
	margin: 0 auto;
	padding: 40px 16px;
}

/* =========================================
       프로필 수정 제목
    ========================================= */
.profile_edit_header {
	margin-bottom: 24px;
}

.profile_edit_header h1 {
	margin: 0 0 8px;
	font-size: 26px;
	font-weight: 800;
	color: #0f172a;
}

.profile_edit_header p {
	margin: 0;
	font-size: 14px;
	color: #64748b;
}

/* =========================================
       프로필 수정 카드
    ========================================= */
.profile_edit_card {
	padding: 28px;
	background-color: #ffffff;
	border: 2px dashed #cbd5e1;
	border-radius: 18px;
}

/* =========================================
       현재 프로필 이미지
    ========================================= */
.profile_edit_avatar {
	width: 90px;
	height: 90px;
	margin: 0 auto 28px;
	display: flex;
	align-items: center;
	justify-content: center;
	overflow: hidden;
	border-radius: 50%;
	background-color: #f1f5f9;
	font-size: 38px;
}

.profile_edit_avatar img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.profile_edit_avatar span {
	width: 100%;
	height: 100%;
	align-items: center;
	justify-content: center;
}

/* =========================================
       프로필 수정 FORM
    ========================================= */
.profile_edit_form {
	width: 100%;
}

/* =========================================
       입력 영역
    ========================================= */
.profile_edit_row {
	margin-bottom: 20px;
}

.profile_edit_label {
	display: block;
	margin-bottom: 8px;
	font-size: 13px;
	font-weight: 700;
	color: #475569;
}

.profile_edit_input {
	width: 100%;
	height: 46px;
	padding: 0 14px;
	border: 1px solid #cbd5e1;
	border-radius: 10px;
	background-color: #ffffff;
	font-size: 14px;
	color: #0f172a;
	outline: none;
}

.profile_edit_input:focus {
	border-color: #6366f1;
}

/* =========================================
       수정 불가능한 회원 정보
    ========================================= */
.profile_edit_readonly {
	width: 100%;
	min-height: 46px;
	display: flex;
	align-items: center;
	padding: 0 14px;
	border-radius: 10px;
	background-color: #f8fafc;
	font-size: 14px;
	color: #64748b;
}

/* =========================================
       버튼 영역
    ========================================= */
.profile_edit_actions {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 28px;
}

.profile_edit_cancel_btn, .profile_edit_save_btn {
	min-height: 42px;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding: 0 18px;
	border-radius: 10px;
	font-size: 13px;
	font-weight: 700;
	text-decoration: none;
	cursor: pointer;
}

/* 취소 버튼 */
.profile_edit_cancel_btn {
	border: 1px solid #cbd5e1;
	background-color: #ffffff;
	color: #475569;
}

/* 저장 버튼 */
.profile_edit_save_btn {
	border: none;
	background-color: #0f172a;
	color: #ffffff;
}

/* =========================================
       모바일
    ========================================= */
@media ( max-width : 767px) {
	.profile_edit_container {
		padding: 24px 16px;
	}
	.profile_edit_card {
		padding: 22px 18px;
	}
	.profile_edit_actions {
		flex-direction: column-reverse;
	}
	.profile_edit_cancel_btn, .profile_edit_save_btn {
		width: 100%;
	}
}
</style>

</head>


<body>


	<%-- =========================================
     상단 네비게이션 바
========================================= --%>
	<%@ include file="/WEB-INF/views/include/navbar.jsp"%>


	<%-- =========================================
     프로필 수정 전체 영역
========================================= --%>
	<div class="profile_edit_container">


		<%-- =========================================
         프로필 수정 제목
    ========================================= --%>
		<div class="profile_edit_header">

			<h1>프로필 수정</h1>

			<p>나의 프로필 정보를 수정할 수 있습니다.</p>

		</div>


		<%-- =========================================
         프로필 수정 카드
    ========================================= --%>
		<div class="profile_edit_card">

			<%-- =========================================
         프로필 정보 수정 FORM
         - 닉네임 + 프로필 이미지를 함께 전송
    ========================================= --%>
			<form action="${pageContext.request.contextPath}/member/profile/edit"
				method="post" enctype="multipart/form-data"
				class="profile_edit_form">

				<%-- =========================================
             현재 프로필 이미지
        ========================================= --%>
				<div class="profile_edit_avatar">

					<c:choose>

						<%-- 프로필 이미지가 있는 경우 --%>
						<c:when test="${not empty loginUser.profileImg}">

							<img id="profileImagePreview"
								src="${pageContext.request.contextPath}${loginUser.profileImg}"
								alt="프로필 이미지"
								onerror="
								this.style.display='none';
        						this.nextElementSibling.style.display='flex';
   							 ">

							<%-- 이미지 로드 실패 시 기본 이미지 --%>
							<span id="profileImageDefault" style="display: none;"> 👤
							</span>

						</c:when>


						<%-- 프로필 이미지가 없는 경우 --%>
						<c:otherwise>

							<%-- 이미지 선택 전 기본 프로필 --%>
							<img id="profileImagePreview" src="" alt="프로필 이미지 미리보기"
								style="display: none;">

							<%-- 기본 프로필 아이콘 --%>
							<span id="profileImageDefault" style="display: flex;"> 👤
							</span>

						</c:otherwise>

					</c:choose>

				</div>
				<%-- =========================================
     프로필 이미지 변경
     - 선택한 이미지는 저장 전 미리보기
     - 실제 저장은 아래 FORM 전송 시 처리
========================================= --%>
				<div class="profile_edit_row profile_edit_image_row">
					<label for="profileImageFile" class="profile_edit_label">
						프로필 사진 </label> <input type="file" id="profileImageFile"
						name="profileImageFile" accept="image/*"
						class="profile_edit_file_input">
				</div>
				<%-- =========================================
                 닉네임
                 실제 수정 가능한 항목
            ========================================= --%>
				<div class="profile_edit_row">

					<label for="nickname" class="profile_edit_label"> 닉네임 </label> <input
						type="text" id="nickname" name="nickname"
						class="profile_edit_input" value="${loginUser.nickname}"
						maxlength="30" required>

				</div>


				<%-- =========================================
                 이메일
                 현재 단계에서는 수정하지 않음
            ========================================= --%>
				<div class="profile_edit_row">

					<span class="profile_edit_label"> 이메일 </span>

					<div class="profile_edit_readonly">${loginUser.email}</div>

				</div>


				<%-- =========================================
                 현재 레벨
                 사용자가 직접 수정할 수 없는 정보
            ========================================= --%>
				<div class="profile_edit_row">

					<span class="profile_edit_label"> 레벨 </span>

					<div class="profile_edit_readonly">${loginUser.userLevel}</div>

				</div>


				<%-- =========================================
                 버튼 영역
            ========================================= --%>
				<div class="profile_edit_actions">


					<%-- 취소 / MY 페이지로 돌아가기 --%>
					<a href="${pageContext.request.contextPath}/RE:DAY/my"
						class="profile_edit_cancel_btn"> 취소 </a>


					<%-- 프로필 정보 저장 --%>
					<button type="submit" class="profile_edit_save_btn">저장하기</button>


				</div>


			</form>


		</div>


	</div>

	<%-- =========================================
     프로필 이미지 미리보기
     - 파일 선택 즉시 화면에 미리보기 표시
     - 실제 저장은 저장하기 버튼 클릭 시 처리
========================================= --%>
	<script>
		document.addEventListener("DOMContentLoaded", function() {

			const profileImageInput = document
					.getElementById("profileImageFile");

			const profileImagePreview = document
					.getElementById("profileImagePreview");

			const profileImageDefault = document
					.getElementById("profileImageDefault");

			if (!profileImageInput) {
				return;
			}

			profileImageInput.addEventListener("change", function() {

				const file = this.files[0];

				// 파일 선택을 취소한 경우
				if (!file) {
					return;
				}

				// 이미지 파일만 허용
				if (!file.type.startsWith("image/")) {
					alert("이미지 파일만 선택할 수 있습니다.");
					this.value = "";
					return;
				}

				// 10MB 제한
				if (file.size > 10 * 1024 * 1024) {
					alert("프로필 이미지는 10MB 이하만 가능합니다.");
					this.value = "";
					return;
				}

				const reader = new FileReader();

				reader.onload = function(e) {

					if (profileImagePreview) {
						profileImagePreview.src = e.target.result;
						profileImagePreview.style.display = "block";
					}

					if (profileImageDefault) {
						profileImageDefault.style.display = "none";
					}
				};

				reader.readAsDataURL(file);
			});

		});
	</script>
</body>

</html>