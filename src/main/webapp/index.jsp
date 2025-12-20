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
            <!-- Hero Section -->
            <div class="text-center mb-20">
                <div class="inline-flex items-center gap-2 px-4 py-2 bg-blue-500/10 border border-blue-500/20 rounded-full mb-6">
                    <i class="ri-github-fill text-blue-400"></i>
                    <span class="text-sm text-blue-300 font-medium">GitHub 기반 분석 플랫폼</span>
                </div>
                <h1 class="text-6xl md:text-7xl font-bold mb-6 text-white leading-tight">
                    팀 프로젝트의<br/>
                    <span class="bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">진짜 기여도</span>를 확인하세요
                </h1>
                <p class="text-xl md:text-2xl text-gray-400 mb-10 max-w-3xl mx-auto leading-relaxed">
                    커밋, PR, 이슈를 종합 분석하여 팀원들의 실제 기여도를 객관적으로 평가합니다
                </p>
                <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
                    <a
                        href="login.jsp"
                        class="inline-flex items-center gap-2 px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-all cursor-pointer text-lg font-semibold shadow-lg shadow-blue-600/30 hover:shadow-xl hover:shadow-blue-600/40 transform hover:-translate-y-0.5"
                    >
                        <i class="ri-rocket-line"></i>
                        무료로 시작하기
                    </a>
                    <a
                        href="dashboard.jsp"
                        class="inline-flex items-center gap-2 px-8 py-4 bg-[#161b22] hover:bg-[#1f2937] border border-gray-700 text-white rounded-lg transition-all cursor-pointer text-lg font-semibold"
                    >
                        <i class="ri-dashboard-line"></i>
                        대시보드 둘러보기
                    </a>
                </div>
            </div>

            <!-- Features Section -->
            <div class="mb-20">
                <div class="text-center mb-12">
                    <h2 class="text-4xl font-bold text-white mb-4">주요 기능</h2>
                    <p class="text-lg text-gray-400">팀 프로젝트 관리를 위한 강력한 도구들</p>
                </div>
                <div class="grid md:grid-cols-3 gap-8">
                    <div class="group p-8 bg-[#161b22] border border-gray-800 rounded-xl hover:border-blue-500/50 transition-all hover:shadow-lg hover:shadow-blue-500/10 transform hover:-translate-y-1">
                        <div class="w-14 h-14 bg-gradient-to-br from-blue-500/20 to-blue-600/20 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                            <i class="ri-git-commit-line text-3xl text-blue-400"></i>
                        </div>
                        <h3 class="text-2xl font-semibold mb-3 text-white">실시간 커밋 분석</h3>
                        <p class="text-gray-400 leading-relaxed mb-4">
                            각 팀원의 커밋 수, 코드 라인 변경량, 커밋 빈도를 실시간으로 추적하고 분석합니다
                        </p>
                        <div class="flex items-center gap-2 text-blue-400 text-sm font-medium">
                            <span>자세히 보기</span>
                            <i class="ri-arrow-right-line"></i>
                        </div>
                    </div>

                    <div class="group p-8 bg-[#161b22] border border-gray-800 rounded-xl hover:border-purple-500/50 transition-all hover:shadow-lg hover:shadow-purple-500/10 transform hover:-translate-y-1">
                        <div class="w-14 h-14 bg-gradient-to-br from-purple-500/20 to-purple-600/20 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                            <i class="ri-team-line text-3xl text-purple-400"></i>
                        </div>
                        <h3 class="text-2xl font-semibold mb-3 text-white">팀원 기여도 평가</h3>
                        <p class="text-gray-400 leading-relaxed mb-4">
                            PR, 이슈 해결, 코드 리뷰 등 다양한 활동을 종합하여 객관적인 기여도 점수를 산출합니다
                        </p>
                        <div class="flex items-center gap-2 text-purple-400 text-sm font-medium">
                            <span>자세히 보기</span>
                            <i class="ri-arrow-right-line"></i>
                        </div>
                    </div>

                    <div class="group p-8 bg-[#161b22] border border-gray-800 rounded-xl hover:border-green-500/50 transition-all hover:shadow-lg hover:shadow-green-500/10 transform hover:-translate-y-1">
                        <div class="w-14 h-14 bg-gradient-to-br from-green-500/20 to-green-600/20 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform">
                            <i class="ri-line-chart-line text-3xl text-green-400"></i>
                        </div>
                        <h3 class="text-2xl font-semibold mb-3 text-white">직관적인 시각화</h3>
                        <p class="text-gray-400 leading-relaxed mb-4">
                            프로젝트 기여도를 차트와 그래프로 시각화하여 한눈에 파악할 수 있습니다
                        </p>
                        <div class="flex items-center gap-2 text-green-400 text-sm font-medium">
                            <span>자세히 보기</span>
                            <i class="ri-arrow-right-line"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stats Section -->
            <div class="grid md:grid-cols-4 gap-6 mb-20">
                <div class="p-6 bg-gradient-to-br from-blue-500/10 to-blue-600/5 border border-blue-500/20 rounded-xl text-center">
                    <div class="text-4xl font-bold text-blue-400 mb-2">100%</div>
                    <div class="text-gray-400 text-sm">정확한 분석</div>
                </div>
                <div class="p-6 bg-gradient-to-br from-purple-500/10 to-purple-600/5 border border-purple-500/20 rounded-xl text-center">
                    <div class="text-4xl font-bold text-purple-400 mb-2">실시간</div>
                    <div class="text-gray-400 text-sm">데이터 동기화</div>
                </div>
                <div class="p-6 bg-gradient-to-br from-green-500/10 to-green-600/5 border border-green-500/20 rounded-xl text-center">
                    <div class="text-4xl font-bold text-green-400 mb-2">무료</div>
                    <div class="text-gray-400 text-sm">평생 무료</div>
                </div>
                <div class="p-6 bg-gradient-to-br from-yellow-500/10 to-yellow-600/5 border border-yellow-500/20 rounded-xl text-center">
                    <div class="text-4xl font-bold text-yellow-400 mb-2">쉽게</div>
                    <div class="text-gray-400 text-sm">시작하기</div>
                </div>
            </div>

            <!-- CTA Section -->
            <div class="relative bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 rounded-2xl p-12 md:p-16 text-center overflow-hidden">
                <div class="absolute inset-0 bg-[url('data:image/svg+xml,%3Csvg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"%3E%3Cg fill="none" fill-rule="evenodd"%3E%3Cg fill="%23ffffff" fill-opacity="0.05"%3E%3Cpath d="M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z"/%3E%3C/g%3E%3C/g%3E%3C/svg%3E')] opacity-20"></div>
                <div class="relative z-10">
                    <h2 class="text-4xl md:text-5xl font-bold mb-4 text-white">
                        지금 바로 시작하세요
                    </h2>
                    <p class="text-xl mb-10 text-blue-50 max-w-2xl mx-auto">
                        GitHub 저장소만 연결하면 즉시 프로젝트 분석을 시작할 수 있습니다.<br/>
                        별도의 설정 없이 바로 사용해보세요.
                    </p>
                    <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
                        <a href="login.jsp" class="inline-flex items-center gap-2 px-8 py-4 bg-white text-blue-600 rounded-lg font-semibold hover:bg-gray-50 transition-all cursor-pointer whitespace-nowrap shadow-lg hover:shadow-xl transform hover:-translate-y-0.5">
                            <i class="ri-github-fill"></i>
                            GitHub로 시작하기
                        </a>
                        <a href="dashboard.jsp" class="inline-flex items-center gap-2 px-8 py-4 bg-white/10 backdrop-blur-sm border border-white/20 text-white rounded-lg font-semibold hover:bg-white/20 transition-all cursor-pointer whitespace-nowrap">
                            <i class="ri-eye-line"></i>
                            데모 보기
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <footer class="border-t border-gray-800 bg-[#161b22] mt-20">
            <div class="max-w-7xl mx-auto px-6 py-12">
                <div class="grid md:grid-cols-4 gap-8 mb-8">
                    <div>
                        <div class="flex items-center gap-2 mb-4">
                            <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                                <i class="ri-bar-chart-box-line text-white text-sm"></i>
                            </div>
                            <span class="font-bold text-white">노오력지수</span>
                        </div>
                        <p class="text-sm text-gray-400">
                            GitHub 기반 팀 프로젝트 기여도 분석 플랫폼
                        </p>
                    </div>
                    <div>
                        <h4 class="font-semibold text-white mb-4">제품</h4>
                        <ul class="space-y-2">
                            <li><a href="dashboard.jsp" class="text-sm text-gray-400 hover:text-white transition-colors cursor-pointer">대시보드</a></li>
                            <li><a href="coming-soon.jsp" class="text-sm text-gray-400 hover:text-white transition-colors cursor-pointer">통계</a></li>
                            <li><a href="coming-soon.jsp" class="text-sm text-gray-400 hover:text-white transition-colors cursor-pointer">팀원 관리</a></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="font-semibold text-white mb-4">지원</h4>
                        <ul class="space-y-2">
                            <li><a href="settings.jsp" class="text-sm text-gray-400 hover:text-white transition-colors cursor-pointer">설정</a></li>
                            <li><a href="login.jsp" class="text-sm text-gray-400 hover:text-white transition-colors cursor-pointer">로그인</a></li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="font-semibold text-white mb-4">연결</h4>
                        <div class="flex gap-4">
                            <a href="https://github.com" target="_blank" class="w-10 h-10 bg-gray-800 hover:bg-gray-700 rounded-lg flex items-center justify-center text-gray-400 hover:text-white transition-colors cursor-pointer">
                                <i class="ri-github-fill text-xl"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="border-t border-gray-800 pt-8 flex flex-col md:flex-row items-center justify-between gap-4">
                    <p class="text-sm text-gray-400">
                        © 2024 노오력지수. All rights reserved.
                    </p>
                    <a href="https://readdy.ai/?origin=logo" class="text-sm text-gray-400 hover:text-white transition-colors cursor-pointer whitespace-nowrap">
                        made by 최옥토 & 허주은
                    </a>
                </div>
            </div>
        </footer>
    </div>

</body>
</html>
