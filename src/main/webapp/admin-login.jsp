<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 로그인 - 노오력지수</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-color: #0d1117;
            color: #e5e7eb;
        }
    </style>
</head>
<body>
    <div class="min-h-screen flex items-center justify-center bg-[#0d1117] text-white">
        <div class="w-full max-w-sm bg-[#161b22] border border-gray-800 rounded-xl p-6">
            <div class="text-center mb-6">
                <div class="w-16 h-16 bg-gradient-to-br from-red-500 to-red-600 rounded-lg flex items-center justify-center mx-auto mb-4">
                    <i class="ri-shield-user-line text-white text-3xl"></i>
                </div>
                <h2 class="text-xl font-semibold mb-2">관리자 로그인</h2>
                <p class="text-sm text-gray-400">노오력지수 관리자 페이지</p>
            </div>

            <div id="errorMessage" class="hidden mb-4 p-3 bg-red-900/20 border border-red-800 rounded-lg">
                <p class="text-sm text-red-400" id="errorText"></p>
            </div>

            <form method="post" action="<%= request.getContextPath() %>/admin/login" id="adminLoginForm">
                <div class="mb-4">
                    <label class="block text-sm text-gray-400 mb-2">아이디</label>
                    <input 
                        name="username" 
                        type="text" 
                        required 
                        class="w-full px-4 py-2 rounded-lg bg-[#0d1117] border border-gray-700 text-white focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent" 
                        placeholder="관리자 아이디를 입력하세요"
                    />
                </div>
                <div class="mb-6">
                    <label class="block text-sm text-gray-400 mb-2">비밀번호</label>
                    <input 
                        name="password" 
                        type="password" 
                        required 
                        class="w-full px-4 py-2 rounded-lg bg-[#0d1117] border border-gray-700 text-white focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent" 
                        placeholder="비밀번호를 입력하세요"
                    />
                </div>
                <div class="text-center">
                    <button 
                        type="submit" 
                        class="w-full px-4 py-2 bg-red-600 hover:bg-red-700 rounded-lg transition-colors font-medium"
                    >
                        로그인
                    </button>
                </div>
            </form>

            <div class="mt-6 text-center">
                <a href="http://walab.handong.edu:8080/W25_22400742_1/index.jsp" class="text-sm text-gray-400 hover:text-white transition-colors">
                    <i class="ri-arrow-left-line"></i> 메인으로 돌아가기
                </a>
            </div>
        </div>
    </div>

    <script>
        // URL 파라미터에서 에러 확인
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        if (error) {
            const errorDiv = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            errorDiv.classList.remove('hidden');
            errorText.textContent = decodeURIComponent(error);
        }
    </script>
</body>
</html>

