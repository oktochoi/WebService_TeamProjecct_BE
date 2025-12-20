<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>준비중입니다 - 노오력지수</title>
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
    <div class="flex min-h-screen bg-[#0d1117]">
        <%@ include file="includes/sidebar.jsp" %>
        
        <div class="flex-1 ml-64">
            <div class="flex items-center justify-center min-h-screen">
                <div class="text-center">
                    <div class="mb-6">
                        <i class="ri-tools-line text-6xl text-gray-500 mb-4"></i>
                    </div>
                    <h1 class="text-3xl font-bold text-white mb-4">준비중입니다</h1>
                    <p class="text-gray-400 text-lg">이 기능은 곧 제공될 예정입니다.</p>
                    <div class="mt-8">
                        <a href="dashboard.jsp" class="inline-flex items-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors">
                            <i class="ri-arrow-left-line"></i>
                            대시보드로 돌아가기
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

