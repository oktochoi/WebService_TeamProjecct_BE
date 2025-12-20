<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 로그인</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<div class="min-h-screen flex items-center justify-center bg-[#0d1117] text-white">
    <div class="w-full max-w-sm bg-[#161b22] border border-gray-800 rounded-xl p-6">
        <h2 class="text-xl font-semibold mb-4 text-center">관리자 로그인</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin/login">
            <div class="mb-3">
                <label class="block text-sm text-gray-400 mb-1">아이디</label>
                <input name="username" type="text" required class="w-full px-3 py-2 rounded bg-[#0b1116] border border-gray-800 text-white" />
            </div>
            <div class="mb-4">
                <label class="block text-sm text-gray-400 mb-1">비밀번호</label>
                <input name="password" type="password" required class="w-full px-3 py-2 rounded bg-[#0b1116] border border-gray-800 text-white" />
            </div>
            <div class="text-center">
                <button type="submit" class="px-4 py-2 bg-red-600 hover:bg-red-700 rounded-lg">로그인</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>

