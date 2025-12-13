<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>노오력지수 - GitHub 기반 팀플 기여도 분석</title>
    <meta name="description" content="GitHub 데이터로 팀 프로젝트 기여도를 분석하고 관리하세요">
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
    <div class="min-h-screen bg-[#0d1117]">
        <nav class="border-b border-gray-800 bg-[#161b22]">
            <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                        <i class="ri-bar-chart-box-line text-white text-lg"></i>
                    </div>
                    <span class="text-xl font-bold text-white">노오력지수</span>
                </div>
                <div class="flex items-center gap-4">
                    <a href="dashboard.jsp" class="text-gray-300 hover:text-white transition-colors cursor-pointer whitespace-nowrap">
                        대시보드
                    </a>
                    <a href="login.jsp" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors cursor-pointer whitespace-nowrap inline-block">
                        시작하기
                    </a>
                </div>
            </div>
        </nav>

        <div class="max-w-7xl mx-auto px-6 py-20">
            <div class="text-center mb-16">
                <h1 class="text-5xl font-bold mb-6 text-white">
                    GitHub 기반 팀플 기여도 분석
                </h1>
                <p class="text-xl text-gray-400 mb-8">
                    GitHub 데이터로 팀 프로젝트의 진짜 기여도를 분석하고 관리하세요
                </p>
                <a
                    href="login.jsp"
                    class="inline-block px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors cursor-pointer text-lg font-semibold"
                >
                    시작하기
                </a>
            </div>

            <div class="grid md:grid-cols-3 gap-8 mb-20">
                <div class="p-6 bg-[#161b22] border border-gray-800 rounded-xl">
                    <div class="w-12 h-12 bg-blue-500/10 rounded-lg flex items-center justify-center mb-4">
                        <i class="ri-git-commit-line text-2xl text-blue-500"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2 text-white">커밋 분석</h3>
                    <p class="text-gray-400">
                        각 팀원의 커밋 수, 코드 라인 변경량을 정확하게 분석합니다
                    </p>
                </div>

                <div class="p-6 bg-[#161b22] border border-gray-800 rounded-xl">
                    <div class="w-12 h-12 bg-purple-500/10 rounded-lg flex items-center justify-center mb-4">
                        <i class="ri-team-line text-2xl text-purple-500"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2 text-white">팀원 평가</h3>
                    <p class="text-gray-400">
                        팀원들에게 피드백을 남기고 기여도를 평가할 수 있습니다
                    </p>
                </div>

                <div class="p-6 bg-[#161b22] border border-gray-800 rounded-xl">
                    <div class="w-12 h-12 bg-green-500/10 rounded-lg flex items-center justify-center mb-4">
                        <i class="ri-line-chart-line text-2xl text-green-500"></i>
                    </div>
                    <h3 class="text-xl font-semibold mb-2 text-white">시각화</h3>
                    <p class="text-gray-400">
                        프로젝트 기여도를 직관적인 차트와 그래프로 확인하세요
                    </p>
                </div>
            </div>

            <div class="bg-gradient-to-r from-blue-600 to-purple-600 rounded-2xl p-12 text-center">
                <h2 class="text-3xl font-bold mb-4 text-white">
                    지금 바로 시작하세요
                </h2>
                <p class="text-xl mb-8 text-blue-100">
                    GitHub 저장소만 있으면 바로 분석을 시작할 수 있습니다
                </p>
                <a href="login.jsp" class="px-8 py-3 bg-white text-blue-600 rounded-lg font-semibold hover:bg-gray-100 transition-colors cursor-pointer whitespace-nowrap inline-block">
                    무료로 시작하기
                </a>
            </div>
        </div>

        <footer class="border-t border-gray-800 bg-[#161b22] mt-20">
            <div class="max-w-7xl mx-auto px-6 py-8">
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <div class="w-6 h-6 bg-gradient-to-br from-blue-500 to-purple-600 rounded"></div>
                        <span class="font-semibold text-white">노오력지수</span>
                    </div>
                    <div class="flex gap-6">
                        <a href="https://readdy.ai/?origin=logo" class="text-gray-400 hover:text-white transition-colors cursor-pointer whitespace-nowrap">
                            Made with Readdy
                        </a>
                    </div>
                </div>
            </div>
        </footer>
    </div>

</body>
</html>
