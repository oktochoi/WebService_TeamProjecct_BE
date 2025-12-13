<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 이미 로그인한 경우 대시보드로 리다이렉트
    // JSP에서 session은 내장 객체이므로 별도로 선언할 필요 없음
    if (session != null && session.getAttribute("authenticated") != null && 
        (Boolean) session.getAttribute("authenticated")) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 노오력지수</title>
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
    <div class="min-h-screen bg-[#0d1117] flex items-center justify-center">
        <div class="w-full max-w-md">
            <div class="text-center mb-8">
                <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center mx-auto mb-4">
                    <i class="ri-bar-chart-box-line text-white text-3xl"></i>
                </div>
                <h1 class="text-3xl font-bold text-white mb-2">노오력지수</h1>
                <p class="text-gray-400">GitHub 기반 팀플 기여도 분석</p>
            </div>

            <div class="bg-[#161b22] border border-gray-800 rounded-xl p-8">
                <h2 class="text-xl font-semibold text-white mb-6 text-center">로그인</h2>
                
                <div id="errorMessage" class="hidden mb-4 p-3 bg-red-900/20 border border-red-800 rounded-lg">
                    <p class="text-sm text-red-400" id="errorText"></p>
                </div>

                <div id="loadingMessage" class="hidden mb-4 p-3 bg-blue-900/20 border border-blue-800 rounded-lg">
                    <p class="text-sm text-blue-400 flex items-center gap-2">
                        <i class="ri-loader-4-line animate-spin"></i>
                        GitHub 인증 중...
                    </p>
                </div>

                <a
                    href="<%= request.getContextPath() %>/github-auth/oauth"
                    id="loginButton"
                    onclick="checkOAuthConfig(event)"
                    class="w-full px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors cursor-pointer flex items-center justify-center gap-2 font-medium"
                >
                    <i class="ri-github-fill text-xl"></i>
                    GitHub로 로그인
                </a>

                <p class="text-xs text-gray-400 text-center mt-6">
                    GitHub 계정으로 로그인하여 프로젝트를 분석할 수 있습니다.
                </p>
                
                <div class="mt-4 p-3 bg-yellow-900/20 border border-yellow-800 rounded-lg">
                    <p class="text-xs text-yellow-400">
                        <i class="ri-information-line"></i> 
                        <strong>설정 필요:</strong> GitHub OAuth App을 먼저 생성해야 합니다.
                        <br>
                        <a href="https://github.com/settings/developers" target="_blank" class="underline">GitHub OAuth App 생성하기</a>
                    </p>
                </div>
            </div>

            <div class="text-center mt-6">
                <a href="index.jsp" class="text-sm text-gray-400 hover:text-white transition-colors cursor-pointer">
                    <i class="ri-arrow-left-line"></i> 메인으로 돌아가기
                </a>
            </div>
        </div>
    </div>

    <script>
        // URL 파라미터에서 에러 확인
        (function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            
            if (error) {
                const errorMessage = document.getElementById('errorMessage');
                const errorText = document.getElementById('errorText');
                
                let errorMsg = '로그인에 실패했습니다.';
                switch(error) {
                    case 'invalid_state':
                        errorMsg = '보안 검증에 실패했습니다. 다시 시도해주세요.';
                        break;
                    case 'no_code':
                        errorMsg = '인증 코드를 받지 못했습니다. GitHub OAuth App 설정을 확인해주세요.';
                        break;
                    case 'token_failed':
                        errorMsg = '액세스 토큰을 받지 못했습니다. Client ID와 Client Secret을 확인해주세요.';
                        break;
                    case 'auth_failed':
                        errorMsg = '사용자 정보를 가져오지 못했습니다. 다시 시도해주세요.';
                        break;
                    case 'server_error':
                        errorMsg = '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
                        break;
                    default:
                        errorMsg = '로그인 중 오류가 발생했습니다: ' + error;
                }
                
                errorText.textContent = errorMsg;
                errorMessage.classList.remove('hidden');
            }
        })();
        
        // OAuth 설정 확인
        function checkOAuthConfig(event) {
            // 실제로는 서버에서 확인해야 하지만, 클라이언트에서 기본 체크
            console.log('[login.jsp] GitHub OAuth 로그인 시작');
            // 링크는 정상적으로 작동하도록 함
        }
    </script>
</body>
</html>

